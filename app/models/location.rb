class Location < ActiveRecord::Base
  EMAIL_REGEX = /\A([^@\s]+)@((?:(?!-)[-a-z0-9]+(?<!-)\.)+[a-z]{2,})\z/i
  URL_REGEX = %r{\Ahttps?://([^\s:@]+:[^\s:@]*@)?[A-Za-z\d\-]+(\.[A-Za-z\d\-]+)+\.?(:\d{1,5})?([\/?]\S*)?\z}i

  include Search
  include ValidationState

  attr_accessible :accessibility, :address, :admin_emails, :contacts,
                  :description, :emails, :faxes, :hours, :languages,
                  :latitude, :longitude, :mail_address, :name, :phones,
                  :short_desc, :transportation, :urls, :address_attributes,
                  :contacts_attributes, :faxes_attributes,
                  :mail_address_attributes, :phones_attributes,
                  :services_attributes, :organization_id

  belongs_to :organization
  accepts_nested_attributes_for :organization

  has_one :address, dependent: :destroy
  accepts_nested_attributes_for :address, allow_destroy: true
  validates_associated :address

  has_many :contacts, dependent: :destroy
  accepts_nested_attributes_for :contacts,
                                allow_destroy: true, reject_if: :all_blank
  validates_associated :contacts

  has_many :faxes, dependent: :destroy
  accepts_nested_attributes_for :faxes,
                                allow_destroy: true, reject_if: :all_blank
  validates_associated :faxes

  has_one :mail_address, dependent: :destroy
  accepts_nested_attributes_for :mail_address, allow_destroy: true
  validates_associated :mail_address

  has_many :phones, dependent: :destroy
  accepts_nested_attributes_for :phones,
                                allow_destroy: true, reject_if: :all_blank
  validates_associated :phones

  has_many :services, dependent: :destroy
  accepts_nested_attributes_for :services, allow_destroy: true
  validates_associated :services

  # has_many :schedules, dependent: :destroy
  # accepts_nested_attributes_for :schedules

  validates :mail_address,
            presence: {
              message: 'A location must have at least one address type.'
            },
            unless: proc { |loc| loc.address.present? }

  validates :address,
            presence: {
              message: 'A location must have at least one address type.'
            },
            unless: proc { |loc| loc.mail_address.present? }

  validates :description, :organization, :name,
            presence: { message: "can't be blank for Location" }

  validates :urls, array: {
    format: {
      allow_blank: true,
      message: "%{value} is not a valid URL",
      with: URL_REGEX,
    }
  }

  validates :emails, :admin_emails, array: {
    format: {
      allow_blank: true,
      message: "%{value} is not a valid email",
      with: EMAIL_REGEX,
    }
  }

  # Only call Google's geocoding service if the address has changed
  # to avoid unnecessary requests that affect our rate limit.
  after_validation :geocode, if: :needs_geocoding?

  after_validation :reset_coordinates, if: proc { |l| l.address.blank? }

  geocoded_by :full_physical_address

  extend Enumerize
  serialize :accessibility, Array
  # Don't change the terms here! You can change their display
  # name in config/locales/en.yml
  enumerize :accessibility,
            in: [:cd, :deaf_interpreter, :disabled_parking, :elevator, :ramp,
                 :restroom, :tape_braille, :tty, :wheelchair, :wheelchair_van],
            multiple: true,
            scope: true

  serialize :admin_emails, Array
  serialize :emails, Array
  serialize :languages, Array
  serialize :urls, Array

  auto_strip_attributes :description, :hours, :name, :short_desc,
                        :transportation

  auto_strip_attributes :admin_emails, :emails, :urls,
                        reject_blank: true, nullify: false

  extend FriendlyId
  friendly_id :slug_candidates, use: [:history]

  # Try building a slug based on the following fields in
  # increasing order of specificity.
  def slug_candidates
    [
      :name,
      [:name, :address_street],
      [:name, :mail_address_city]
    ]
  end

  def address_street
    address.street if address.present?
  end

  def mail_address_city
    mail_address.city if mail_address.present?
  end

  def full_physical_address
    return unless address.present?
    "#{address.street}, #{address.city}, #{address.state} #{address.zip}"
  end

  def coordinates
    [longitude, latitude] if longitude.present? && latitude.present?
  end

  def reset_coordinates
    self.latitude = nil
    self.longitude = nil
  end

  def needs_geocoding?
    address.changed? || latitude.nil? || longitude.nil? if address.present?
  end
end
