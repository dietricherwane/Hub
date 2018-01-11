class Log < ActiveRecord::Base
  # Accessible fields
  attr_accessible :object_inspector, :request_log, :response_log
end
