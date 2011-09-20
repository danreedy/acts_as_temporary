require 'acts_as_temporary'
require 'rails'

module ActsAsTemporary
  class Engine < Rails::Engine
    config.before_initialize do |app|
      app.config.acts_as_temporary_shelf_life = 365.days
    end
  end
end