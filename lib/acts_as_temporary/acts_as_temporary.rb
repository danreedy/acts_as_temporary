module ActsAsTemporary
  def can_be_temporary
    #has_many :reviews, :as=>:reviewable, :dependent=>:destroy
    include InstanceMethods
    attr_reader :temporary_id
    after_save :drop_temporary
    
    def recall(temp_id=nil)
      raise ArgumentError, "Please provide a temporary object ID" if temp_id.blank?
      temporary_object = TemporaryObject.find(temp_id)
      if temporary_object
        raise TypeError, "Temporary object and calling object must be the same class" unless temporary_object.permanent_class.eql?(self.name)
        new_object = self.new(temporary_object.definition)
        new_object.instance_variable_set("@temporary_id",temp_id)
        new_object
      end
    end
    
    def clear_stale_objects
      expiry_date = Time.now - Rails.application.config.acts_as_temporary_shelf_life
      TemporaryObject.delete_all(["permanent_class = ? AND created_at < ?", self.name, expiry_date])
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
      temporary_object = @temporary_id.present? ? TemporaryObject.find(@temporary_id) : TemporaryObject.new
      temporary_object.permanent_class = self.class.name
      temporary_object.definition = self.attributes
      temporary_object.save
      @temporary_id = temporary_object.id
    end
    
    def recall(temp_id=nil)
      temp_id ||= @temporary_id
      self.class.send(:recall, temp_id)
    end
    
    def is_temporary?
      @temporary_id.present?
    end
    
    def drop_temporary
      if @temporary_id.present?
        TemporaryObject.destroy(@temporary_id)
        @temporary_id = nil
      end
    end
    
    
  end
end

ActiveRecord::Base.extend ActsAsTemporary