# frozen_string_literal: true

class CreateTranslations < ActiveRecord::Migration[ActiveRecord.gem_version.to_s.to_f]
  def self.up
    create_table :translations do |t|
      t.string :locale
      t.string :key
      t.text   :value
      t.text   :interpolations
      t.boolean :is_proc, default: false

      t.timestamps
    end
  end

  def self.down
    drop_table :translations
  end
end
