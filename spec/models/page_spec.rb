require 'spec_helper'

describe Page do
  before { @page = Page.new(title: "Example Page", body: "It was the best of times") }

  context "includes ActsAsTemporary class methods" do
    subject { Page.methods }
    it { should include :can_be_temporary }
    it { should include :recall }
  end
  
  context "includes ActsAsTemporary instance methods" do    
    subject { @page }    
    its(:methods) { should include :temporary_id }
    its(:methods) { should_not include :temporary_id= }
    its(:methods) { should include :can_be_temporary? }
    its(:methods) { should include :shelf_life }
    its(:methods) { should include :store }
    its(:methods) { should include :recall }
    its(:shelf_life) { should == 365.days }
  end
  
  describe :store do
    subject { @page }
    it "should increase the TemporaryObject count by 1" do
      lambda {
        subject.store
      }.should change(TemporaryObject, :count).by(1)
    end
  end
  
  describe :temporary_id do
    subject { @page }
    context "a temporary object has not been stored" do
      its(:temporary_id) { should be_blank }
    end
    context "a temporary object has been stored" do
      before(:each) { subject.store }
      its(:temporary_id) { should_not be_blank }
      it "should locate a TemporaryObjects record" do
        temporary_object = TemporaryObject.find(subject.temporary_id)
        temporary_object.should_not be_blank
        temporary_object.should be_a TemporaryObject
      end
    end
  end
  
  describe :recall do
    before { @temporary_object = TemporaryObject.create(permanent_class: "NotAPage", definition: { id: nil, title: "None" } ) }
    
    context "exception handling" do
      it "should raise an ArgumentError if a temporary id is not provided" do
        lambda {
          Page.recall
        }.should raise_error(ArgumentError, "Please provide a temporary object ID")
      end

      it "should raise a TypeError exception if the classes do not match" do
        lambda {
          Page.recall(@temporary_object.id)
        }.should raise_error(TypeError, "Temporary object and calling object must be the same class")
      end
    end
    
    
    
  end
  
  
end