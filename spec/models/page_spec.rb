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
    
    context "exception handling" do
      before(:each) { @temporary_object = TemporaryObject.create(permanent_class: "NotAPage", definition: { id: nil, title: "None" } ) }
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
    
    context "valid temporary objects" do
      before(:each) do
         @page.store
       end
       subject { Page.recall(temporary_id) }
       let(:temporary_id) { @page.temporary_id }       
       its(:attributes) { should eql @page.attributes }
       it { should be_a Page}
    end
    
  end
  
  describe :save do
    
    context "Storing and saving from the same instance" do
      subject { @page }
      before(:each) { @page.store }
    
      it "should delete the temporary object when saved" do
        lambda {
          @page.save
        }.should change(TemporaryObject, :count).by(-1)
      end
      it "should not delete the temporary object when failed to save" do
        @page.stub(:save).and_return(false)
        lambda {
          @page.save
        }.should_not change(TemporaryObject, :count)
      end
      
      it "should set #temporary_id to nil" do
        lambda {
          @page.save
        }.should change(@page, :temporary_id).to(nil)
      end
      it "should not set #temporary_id to nil when failed to save" do
        @page.stub(:save).and_return(false)
        lambda {
          @page.save
        }.should_not change(@page, :temporary_id)
      end
      
    end
    
    context "Storing and saving from the class level" do
      before(:each) do
        @page.store
        temporary_id = @page.temporary_id
        @page = nil
        @page = Page.recall(temporary_id)
      end
      
      it "should build from the temporary object and then delete it on save" do
        lambda {
          @page.save
        }.should change(TemporaryObject, :count).by(-1)
      end
      it "should set #temporary_id to nil" do
        lambda {
          @page.save
        }.should change(@page, :temporary_id).to(nil)
      end
    end
    
  end
  
  describe :is_temporary? do
    subject { @page }
    
    context "when stored as a temporary object" do
      it "should return true for #is_temporary?" do
        lambda {
          @page.store
        }.should change(@page, :is_temporary?).from(false).to(true)        
      end
    end
    context "when recalled and saved" do
      it "should no longer report as a temporary object" do
        @page.store
        @page = Page.recall(@page.temporary_id)
        lambda {
          @page.save
        }.should change(@page, :is_temporary?).from(true).to(false)
      end
    end   
    
  end
  
  describe :drop_temporary do
    before(:each) { @page.store }
    
    it "should destroy the temporary object" do
      lambda {
        @page.drop_temporary
      }.should change(TemporaryObject, :count).by(-1)
    end
    it "should not save the object" do
      lambda {
        @page.drop_temporary
      }.should_not change(Page, :count)
    end
    it "should set #temporary_id to nil" do
      lambda {
        @page.drop_temporary
      }.should change(@page, :is_temporary?).from(true).to(false)
    end
  end
  
end