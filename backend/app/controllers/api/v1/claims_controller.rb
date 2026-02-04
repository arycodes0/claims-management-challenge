require "csv"

module Api
  module V1
    class ClaimsController < BaseController
      before_action :set_claim, only: [:show, :update, :destroy]

      def index
        claims = Claim.includes(:patient).order(created_at: :desc)
        claims = claims.where(status: params[:status]) if params[:status].present?
        claims = claims.where(patient_id: params[:patient_id]) if params[:patient_id].present?

        render json: claims.map { |c| claim_json(c) }
      end

      def show
        render json: claim_json(@claim)
      end

      def create
        claim = Claim.create!(claim_params)
        render json: claim_json(claim), status: :created
      end

      def update
        @claim.update!(claim_params)
        render json: claim_json(@claim)
      end

      def destroy
        @claim.destroy!
        head :no_content
      end

      def export
        claims = Claim.includes(:patient).order(:claim_number)

        csv_data = CSV.generate(headers: true) do |csv|
          csv << ["claim_number", "patient_name", "service_date", "amount", "status"]
          claims.each do |claim|
            csv << [
              claim.claim_number,
              claim.patient.full_name,
              claim.service_date.to_s,
              claim.amount.to_s,
              claim.status
            ]
          end
        end

        send_data csv_data, filename: "claims_export_#{Date.today}.csv", type: "text/csv"
      end

      private

      def set_claim
        @claim = Claim.find(params[:id])
      end

      def claim_params
        params.permit(:patient_id, :claim_number, :service_date, :amount, :status)
      end

      def claim_json(claim)
        {
          id: claim.id,
          claim_number: claim.claim_number,
          patient_id: claim.patient_id,
          patient_name: claim.patient&.full_name,
          service_date: claim.service_date,
          amount: claim.amount.to_f,
          status: claim.status,
          claim_import_id: claim.claim_import_id,
          created_at: claim.created_at,
          updated_at: claim.updated_at
        }
      end
    end
  end
end
