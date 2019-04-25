# frozen_string_literal: true

class CreateProvinces < ActiveRecord::Migration[ActiveRecord.gem_version.to_s.to_f]
  def change
    create_table :provinces do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
