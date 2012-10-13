class AddMembershipsCountToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :memberships_count, :integer, :default=>0
  end
end
