class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :name, :default => ""
      t.string :nickname
      t.string :email
      t.string :image
    end
  end
end