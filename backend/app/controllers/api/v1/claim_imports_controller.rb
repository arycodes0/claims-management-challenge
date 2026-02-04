require "csv"

module Api
  module V1
    class ClaimImportsController < BaseController
      def create
        unless params[:file].present?
          return render json: { error: "No file uploaded" }, status: :unprocessable_entity
        end

        file = params[:file]
        claim_import = ClaimImport.create!(
          file_name: file.original_filename,
          status: "processing"
        )

        rows = CSV.parse(file.read, headers: true)
        claim_import.update!(total_records: rows.size)

        processed = 0
        errors_list = []

        rows.each_with_index do |row, index|
          begin
            patient = Patient.find_or_create_by!(
              first_name: row["patient_first_name"]&.strip,
              last_name: row["patient_last_name"]&.strip,
              dob: row["patient_dob"].present? ? Date.parse(row["patient_dob"].strip) : nil
            )

            Claim.create!(
              patient: patient,
              claim_import: claim_import,
              claim_number: row["claim_number"]&.strip,
              service_date: Date.parse(row["service_date"]&.strip),
              amount: row["amount"]&.strip&.to_d,
              status: row["status"]&.strip&.downcase || "pending"
            )

            processed += 1
          rescue StandardError => e
            errors_list << { row: index + 2, error: e.message }
          end
        end

        claim_import.update!(processed_records: processed, status: "completed")

        render json: {
          id: claim_import.id,
          file_name: claim_import.file_name,
          total_records: claim_import.total_records,
          processed_records: claim_import.processed_records,
          failed_records: claim_import.total_records - processed,
          status: claim_import.status,
          errors: errors_list
        }, status: :created
      end

      def index
        imports = ClaimImport.order(created_at: :desc)
        render json: imports
      end

      def show
        claim_import = ClaimImport.find(params[:id])
        render json: claim_import
      end
    end
  end
end
