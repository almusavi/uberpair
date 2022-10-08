class AddFieldsToDevise < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :education, :string
    add_column :accounts, :location, :string
    add_column :accounts, :description, :text    
  end
end
