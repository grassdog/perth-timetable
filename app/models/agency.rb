require 'csv'

class Agency < ActiveRecord::Base
  has_many :routes, :primary_key => 'agency_id'
end