# frozen_string_literal: true

class CreateCities < ActiveRecord::Migration[ActiveRecord.gem_version.to_s.to_f]
  def change
    create_table :cities do |t|
      t.string :name, null: false
      t.references :province, foreign_key: true

      t.timestamps
    end
  end
end
