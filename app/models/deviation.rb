class Deviation < ActiveRecord::Base
  belongs_to :service, :primary_key => "service_id"
end