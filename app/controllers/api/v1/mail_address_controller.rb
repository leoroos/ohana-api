module Api
  module V1
    class MailAddressController < ApplicationController
      include TokenValidator

      def update
        mail_address = MailAddress.find(params[:id])
        mail_address.validate = true
        mail_address.update!(params)
        render json: mail_address, status: 200
      end

      def create
        location = Location.find(params[:location_id])
        unless location.mail_address.present?
          mail_address = location.build_mail_address(params)
          mail_address.validate = true
          mail_address.save!
        end
        render json: mail_address, status: 201
      end

      def destroy
        location = Location.find(params[:location_id])
        location.validate = true
        mail_address_id = location.mail_address.id
        location.mail_address_attributes = { id: mail_address_id, _destroy: '1' }
        location.save!
        head 204
      end
    end
  end
end
