# frozen_string_literal: true

class City < ApplicationRecord
  belongs_to :province
  has_many :counties, dependent: :destroy
end
