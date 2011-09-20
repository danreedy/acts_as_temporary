module ActsAsTemporary
  def can_be_temporary
    #has_many :reviews, :as=>:reviewable, :dependent=>:destroy
    include InstanceMethods
  end
  module InstanceMethods
    def can_be_temporary?
      true
    end
    
    def shelf_life
      Rails.application.config.acts_as_temporary_shelf_life
    end
  end
end

ActiveRecord::Base.extend ActsAsTemporary