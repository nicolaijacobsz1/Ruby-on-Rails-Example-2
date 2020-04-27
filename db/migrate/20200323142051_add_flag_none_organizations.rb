class AddFlagNoneOrganizations < ActiveRecord::Migration[5.2]
  def change
    add_column :organizations,  :flag_none, :boolean, default: false
    add_column :qualifications,  :organization_name, :string
  end
end
