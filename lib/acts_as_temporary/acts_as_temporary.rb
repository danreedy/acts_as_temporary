module ActsAsTemporary
  def can_be_temporary
    #has_many :reviews, :as=>:reviewable, :dependent=>:destroy
    include InstanceMethods
    attr_reader :temporary_id
    
    def recall(temp_id=nil)
      raise ArgumentError, "Please provide a temporary object ID" if temp_id.blank?
      temporary_object = TemporaryObject.find(temp_id)
      if temporary_object
        raise TypeError, "Temporary object and calling object must be the same class" unless temporary_object.permanent_class.eql?(self.name)
      end
    end
  end
  module InstanceMethods
    def can_be_temporary?
      true
    end
    
    def shelf_life
      Rails.application.config.acts_as_temporary_shelf_life
    end
    
    def store
      temporary_object = TemporaryObject.new
      temporary_object.permanent_class = self.class.name
      temporary_object.definition = self.attributes
      temporary_object.save
      @temporary_id = temporary_object.id
    end
    
    def recall(temp_id=nil)
      temp_id ||= @temporary_id
      self.class.send(:recall, temp_id)
    end
  end
end

ActiveRecord::Base.extend ActsAsTemporary