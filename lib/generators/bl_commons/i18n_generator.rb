# frozen_string_literal: true

module BlCommons
  module Generators
    class I18nGenerator < ::Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('templates', __dir__)

      desc 'install i18n-active_record related'

      def self.next_migration_number(path)
        unless @prev_migration_nr
          @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        else
          @prev_migration_nr += 1
        end
        @prev_migration_nr.to_s
      end

      def copy_migrations
        migration_template 'create_translations.rb', 'db/migrate/create_translations.rb'
      end
    end
  end
end
