class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, :default => ""
    end
  end
end