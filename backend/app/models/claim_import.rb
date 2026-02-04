class ClaimImport < ApplicationRecord
  has_many :claims, dependent: :nullify

  validates :file_name, presence: true
  validates :status, presence: true, inclusion: { in: %w[pending processing completed failed] }
end
