module Api
  module V1
    class PatientsController < BaseController
      before_action :set_patient, only: [:show, :update, :destroy]

      def index
        patients = Patient.order(:last_name, :first_name)
        render json: patients
      end

      def show
        render json: @patient.as_json(include: :claims)
      end

      def create
        patient = Patient.create!(patient_params)
        render json: patient, status: :created
      end

      def update
        @patient.update!(patient_params)
        render json: @patient
      end

      def destroy
        @patient.destroy!
        head :no_content
      end

      private

      def set_patient
        @patient = Patient.find(params[:id])
      end

      def patient_params
        params.permit(:first_name, :last_name, :dob)
      end
    end
  end
end
