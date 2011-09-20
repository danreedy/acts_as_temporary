class TemporaryObject < ActiveRecord::Base
  validates_presence_of :permanent_class
  validates_presence_of :definition
  serialize :definition
end
