module ActsAsTemporary
  def can_be_temporary
    #has_many :reviews, :as=>:reviewable, :dependent=>:destroy
    include InstanceMethods
  end
  module InstanceMethods
    def can_be_temporary?
      true
    end
  end
end

ActiveRecord::Base.extend ActsAsTemporary