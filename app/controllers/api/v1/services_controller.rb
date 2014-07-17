module Api
  module V1
    class ServicesController < ApplicationController
      include TokenValidator
      include CustomErrors

      before_action :validate_token!, only: [:update, :destroy, :create, :update_categories]

      def index
        location = Location.find(params[:location_id])
        services = location.services
        render json: services, status: 200
      end

      def update
        service = Service.find(params[:id])
        location = Location.find(params[:location_id])
        service.update!(params.merge(location_id: location.id))
        render json: service, status: 200
      end

      def create
        location = Location.find(params[:location_id])
        service = location.services.build(params)
        service.save!
        render json: service, status: 201
      end

      def destroy
        service = Service.find(params[:id])
        service.destroy
        head 204
      end

      def update_categories
        service = Service.find(params[:service_id])
        service.category_ids = cat_ids(params[:oe_ids])
        service.save!

        render json: service, status: 200
      end

      private

      def cat_ids(oe_ids)
        return [] unless oe_ids.present?
        Category.where(oe_id: oe_ids).pluck(:id)
      end
    end
  end
end
