class CreatePatients < ActiveRecord::Migration[8.1]
  def change
    create_table :patients do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.date :dob

      t.timestamps
    end

    add_index :patients, [:first_name, :last_name, :dob], unique: true, name: "index_patients_on_identity"
  end
end
