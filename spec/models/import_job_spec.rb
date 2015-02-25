require "rails_helper"

describe ImportJob do
  describe "after_create" do
    it "enqueues an import" do
      import_job = FactoryGirl.build(:import_job)
      allow(import_job).to receive(:perform)

      import_job.save

      expect(import_job).to have_received(:perform)
    end
  end
end
