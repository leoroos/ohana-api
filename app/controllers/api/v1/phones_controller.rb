module Api
  module V1
    class PhonesController < ApplicationController
      include TokenValidator

      def index
        location = Location.find(params[:location_id])
        phones = location.phones
        render json: phones, status: 200
      end

      def update
        phone = Phone.find(params[:id])
        phone.update!(params)
        render json: phone, status: 200
      end

      def create
        location = Location.find(params[:location_id])
        phone = location.phones.build(params)
        phone.save!
        render json: phone, status: 201
      end

      def destroy
        phone = Phone.find(params[:id])
        phone.destroy
        head 204
      end
    end
  end
end
