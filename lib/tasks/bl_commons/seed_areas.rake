# frozen_string_literal: true

namespace :bl_commons do
  task seed_areas: :environment do
    File.open File.expand_path('../../../config/areas-data.json', __dir__) do |file|
      area_data = JSON.parse file.read
      Province.transaction do
        area_data.each do |province_data|
          # 1. Create provinces data
          province = Province.create! name: province_data['name']

          p province

          province_data['children'].each do |city_data|
            # 2. Create cities data
            city = City.create! name: city_data['name'], province: province

            p city

            city_data['children'].each do |county_data|
              # 3. Create counties data
              p County.create! name: county_data['name'], city: city
            end
          end
        end
      end
    end
  end
end
