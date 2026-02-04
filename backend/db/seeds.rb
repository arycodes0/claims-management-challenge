admin = User.find_or_create_by!(email: "admin@example.com") do |u|
  u.password = "password123"
  u.password_confirmation = "password123"
  u.role = "admin"
end
puts "Admin user: admin@example.com / password123"

patients_data = [
  { first_name: "John", last_name: "Doe", dob: "1985-03-15" },
  { first_name: "Jane", last_name: "Smith", dob: "1990-07-22" },
  { first_name: "Robert", last_name: "Johnson", dob: "1978-11-03" },
]

patients_data.each { |attrs| Patient.find_or_create_by!(attrs) }
puts "Created #{patients_data.size} sample patients"

[
  { patient: Patient.find_by(first_name: "John"), claim_number: "CLM-001", service_date: "2025-01-15", amount: 150.00, status: "paid" },
  { patient: Patient.find_by(first_name: "John"), claim_number: "CLM-002", service_date: "2025-02-01", amount: 275.50, status: "pending" },
  { patient: Patient.find_by(first_name: "Jane"), claim_number: "CLM-003", service_date: "2025-01-20", amount: 500.00, status: "denied" },
].each do |attrs|
  Claim.find_or_create_by!(claim_number: attrs[:claim_number]) do |c|
    c.assign_attributes(attrs)
  end
end
puts "Created sample claims"
