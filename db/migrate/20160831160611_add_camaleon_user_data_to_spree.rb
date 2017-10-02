class AddCamaleonUserDataToSpree < CamaManager.migration_class
  def change
    add_column(CamaleonCms::User.table_name, :email, :string) unless column_exists?(CamaleonCms::User.table_name, :email)
    add_column(CamaleonCms::User.table_name, :role, :string, default: 'client', index: true) unless column_exists?(CamaleonCms::User.table_name, :role)
    add_column(CamaleonCms::User.table_name, :parent_id, :integer) unless column_exists?(CamaleonCms::User.table_name, :parent_id)
    add_column(CamaleonCms::User.table_name, :site_id, :integer, index: true, default: -1) unless column_exists?(CamaleonCms::User.table_name, :site_id)
    add_column(CamaleonCms::User.table_name, :auth_token, :string) unless column_exists?(CamaleonCms::User.table_name, :auth_token)
    add_column CamaleonCms::User.table_name, :first_name, :string unless column_exists?(CamaleonCms::User.table_name, :first_name)
    add_column CamaleonCms::User.table_name, :last_name, :string unless column_exists?(CamaleonCms::User.table_name, :last_name)

    Spree::User.includes(:spree_roles).where(spree_roles: {name: 'admin'}).each do |s_user|
      s_user.update_column(:role, 'admin')
    end
  end
end
