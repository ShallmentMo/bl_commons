# frozen_string_literal: true

class CreateCounties < ActiveRecord::Migration[ActiveRecord.gem_version.to_s.to_f]
  def change
    create_table :counties do |t|
      t.string :name, null: false
      t.references :city, foreign_key: true

      t.timestamps
    end
  end
end
