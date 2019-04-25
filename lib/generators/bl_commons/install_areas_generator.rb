# frozen_string_literal: true

module BlCommons
  module Generators
    class InstallAreasGenerator < ::Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('templates', __dir__)

      desc 'install areas related'

      def self.next_migration_number(path)
        unless @prev_migration_nr
          @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        else
          @prev_migration_nr += 1
        end
        @prev_migration_nr.to_s
      end

      def copy_migrations
        migration_template 'create_provinces.rb', 'db/migrate/create_provinces.rb'
        migration_template 'create_cities.rb', 'db/migrate/create_cities.rb'
        migration_template 'create_counties.rb', 'db/migrate/create_counties.rb'
      end

      def copy_models
        copy_file 'province.rb', 'app/models/province.rb'
        copy_file 'city.rb', 'app/models/city.rb'
        copy_file 'county.rb', 'app/models/county.rb'
      end
    end
  end
end
