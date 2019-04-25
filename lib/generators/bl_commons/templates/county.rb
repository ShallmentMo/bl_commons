# frozen_string_literal: true

class County < ApplicationRecord
  belongs_to :city
end
