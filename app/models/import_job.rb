class ImportJob < ActiveRecord::Base
  include AASM
  include DelayedJobHerokuScaler

  aasm do
    state :new_job, initial: true
    state :started_job
    state :finished_job
    state :deleted_job

    event(:start_job) { transitions from: :new_job, to: :started_job }
    event(:finish_job) { transitions from: :started_job, to: :finished_job }

    event :delete_job do
      after { cascade_delete }
      transitions from: :finished_job, to: :deleted_job
    end
  end

  belongs_to :admin
  has_and_belongs_to_many :organizations

  attr_accessible :url

  validates :url, presence: true, format: { with: /\A(http|https):\/\// }

  after_create :perform

  def perform
    start_job!

    data = open(url).read
    records = JSON.parse(data)
    records.each { |record| save_organization(record) }

    finish_job!
  end
  handle_asynchronously :perform

  def save_organization(org_params)
    organization = Organization.find_or_initialize_by(name: org_params["name"])
    organization.update(org_params.except("locations"))
    organization.save(validate: false)

    locs = org_params["locations"] || []
    locs.each { |location_params| save_location(location_params, organization) }

    unless organizations.include? organization
      organizations << organization
    end
  end

  def save_location(location_params, organization)
    Location.new(
      location_params.merge(organization_id: organization.id)
    ).save(validate: false)
  end

  def cascade_delete
    organizations.each(&:destroy)
  end
  handle_asynchronously :cascade_delete
end
