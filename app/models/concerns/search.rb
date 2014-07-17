module Search
  extend ActiveSupport::Concern

  included do
    scope :has_language, ->(l) { where('languages @@ :q', q: l) if l.present? }
    scope :has_keyword, ->(k) { keyword_search(k) if k.present? }
    scope :has_category, ->(c) { joins(services: :categories).where(categories: { name: c }) if c.present? }

    scope :is_near, (lambda do |loc, lat_lng, r|
      if loc.present?
        result = Geocoder.search(loc, bounds: SETTINGS[:bounds])
        coords = result.first.coordinates if result.present?
        near(coords, validated_radius(r, 5))
      elsif lat_lng.present?
        coords = validated_coordinates(lat_lng)
        near(coords, validated_radius(r, 5))
      end
    end)

    scope :belongs_to_org, (lambda do |org|
      if org.present?
        joins(:organization).where('organizations.name @@ :q', q: org)
      end
    end)

    scope :has_email, (lambda do |email|
      if email.present?
        return Location.none unless email.include?('@')

        domain = email.split('@').last

        locations = Location.arel_table

        if SETTINGS[:generic_domains].include?(domain)
          # where('admin_emails @@ :q or emails @@ :q', q: email)
          Location.where(locations[:admin_emails].matches("%#{email}%").
                  or(locations[:emails].matches("%#{email}%")))
        else
          # where('urls ilike :q or emails ilike :q or admin_emails @@ :p', q: "%#{domain}%", p: email)
          Location.where(locations[:admin_emails].matches("%#{email}%").
                  or(locations[:urls].matches("%#{domain}%")).
                  or(locations[:emails].matches("%#{domain}%")))
        end
      end
    end)

    include PgSearch

    pg_search_scope :keyword_search,
                    against: :tsv_body,
                    using: {
                      tsearch: {
                        dictionary: 'english',
                        any_word: false,
                        prefix: true,
                        tsvector_column: 'tsv_body'
                      }
                    }
  end

  module ClassMethods
    require 'exceptions'

    def text_search(params = {})
      Location.has_language(params[:language]).
              has_category(params[:category]).
              belongs_to_org(params[:org_name]).
              has_email(params[:email]).
              is_near(params[:location], params[:lat_lng], params[:radius]).
              has_keyword(params[:keyword])
    end

    def validated_radius(radius, custom_radius)
      return custom_radius unless radius.present?
      if radius.to_f == 0.0
        fail Exceptions::InvalidRadius
      else
        # radius must be between 0.1 miles and 50 miles
        [[0.1, radius.to_f].max, 50].min
      end
    end

    def validated_coordinates(lat_lng)
      lat, lng = lat_lng.split(',')
      fail Exceptions::InvalidLatLon if lat.to_f == 0.0 || lng.to_f == 0.0
      [Float(lat), Float(lng)]
    end
  end
end
