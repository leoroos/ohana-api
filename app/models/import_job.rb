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

    begin
      data = open(url).read
      records = JSON.parse(data)
      records.each_with_index do |record, index|
        begin
          org, rejected = save_record(record)
          logger.info(
            { index: index, id: org.id, organization: rejected }.to_json
          )
        rescue
          logger.info({ index: index, error: $!.to_s }.to_json)
        end
      end
    rescue
      puts $!.backtrace
      puts $!
    end
    finish_job!
  end
  handle_asynchronously :perform

  def save_record(record)
    Organization.transaction do
      params = record.except('locations')
      org = Organization.new params
      # look for rejected params in Organization
      sanitized = org.send :sanitize_for_mass_assignment, params
      rejected = { rejected: [] }
      params.each do |k, v|
        rejected[:rejected] << k unless sanitized.has_key?(k)
      end
      if org.save(validate: false)
        rejected[:locations] = []
        locs = record['locations']
        locs.each do |location|
          params = location.merge(organization_id: org.id)
          location = Location.new(params)
          # look for rejected params in Location
          sanitized = location.send :sanitize_for_mass_assignment, params
          keys = []
          params.each do |k, v|
            keys << k unless sanitized.has_key?(k)
          end
          rejected[:locations] << { }
          rejected[:locations].last[:rejected] = keys unless keys.empty?
          [ :address, :contacts, :faxes, :mail_address, :phones, :services ].each do |klass|
            key = "#{klass}_attributes"
            if params[key]
              if params[key].kind_of?(Hash)
                obj = klass.to_s.singularize.classify.constantize.new
                sanitized = obj.send :sanitize_for_mass_assignment, params[key]
                keys = []
                params[key].each do |k, v|
                  keys << k unless sanitized.has_key?(k)
                end
                rejected[:locations].last[key] = { rejected: keys } unless keys.empty?
              elsif params[key].kind_of?(Array)
                obj = klass.to_s.singularize.classify.constantize.new
                keys = []
                params[key].each do |data|
                  sanitized = obj.send :sanitize_for_mass_assignment, data
                  data.each do |k, v|
                    keys << k unless sanitized.has_key?(k) || keys.include?(k)
                  end
                end
                rejected[:locations].last[key] = { rejected: keys } unless keys.empty?
              end
            end
          end
          location.save(validate: false)
          rejected[:locations].last[:id] = location.id unless location.id.blank?
          sleep 0.2 # to prevent Geocoder rate limit exception
        end unless locs.nil?
        organizations << org
      end
      return org, rejected
    end
  end

  def cascade_delete
    self.organizations.each do |org|
      org.destroy
    end
  end
  handle_asynchronously :cascade_delete
end
