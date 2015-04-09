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

  describe "#perform" do
    it "fetches data from a URL" do
      url = "http://example.com/"
      stub_request(:get, url).
        to_return(status: 200, body: "[]", headers: {})

      create(:import_job, url: url)
    end

    it "imports organizations" do
      url = "http://example.com/"
      stub_request(:get, url).
        to_return(status: 200, body: body.to_json, headers: {})

      job = create(:import_job, url: url)

      imported_org_id = JSON.parse(job.log)[0]["id"]

      expect(imported_org_id).to eq(Organization.last.id)
      expect(Organization.last.name).to eq org_name
    end

    it "imports locations for each organization" do
      url = "http://example.com/"
      languages = body[0][:locations][0][:languages]
      stub_request(:get, url).
        to_return(status: 200, body: body.to_json, headers: {})

      create(:import_job, url: url)

      imported_org = Organization.last
      expect(imported_org.name).to eq org_name
      expect(imported_org.locations.first.languages).to eq languages
    end
  end

  def org_name
    body[0][:locations][0][:name]
  end

  def body
    [
      {
        locations: [
          {
            languages: [
              "English",
              "Spanish",
              "Chinese"
            ],
            name: "30th Street Senior Center",
            phones_attributes: [
              { number: "415 550-2210" },
              {
                type: "TTY",
                number: "415 647-6332"
              }
            ],
            short_desc: "30th Street Center offers five distinct programs.",
            hours: "Monday - Saturday, 8:30am - 5:00pm",
            urls: ["http://www.onlok.org/30thsite"],
            address_attributes: {
              city: "San Francisco",
              state: "CA",
              street: "225 30th Street, 3rd Floor",
              zip: "94131"
            },
            emails: ["30thStSeniorServices@onlok.org"],
            description: "30th Street Senior Center, " +
              "one of the largest multi-purpose senior centers " +
              "in San Francisco, offers five distinct programs."
          }
        ],
        services_attributes: {
          audience: "Seniors and their Families",
          fees: "None"
        },
        name: "30th Street Senior Center"
      }
    ]
  end
end
