class Phone < ActiveRecord::Base
  include ValidationState

  default_scope { order('id ASC') }

  attr_accessible :department, :extension, :number, :number_type,
                  :vanity_number

  belongs_to :location, touch: true

  validates :number,
            presence: { message: "can't be blank for Phone" },
            phone: { unless: ->(phone) { phone.number == '711' } }

  auto_strip_attributes :department, :extension, :number, :number_type,
                        :vanity_number, squish: true
end
