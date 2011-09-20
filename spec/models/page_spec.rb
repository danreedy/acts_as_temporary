require 'spec_helper'

describe Page do

  context "includes ActsAsTemporary class methods" do
    subject { Page.methods }
    it { should include :can_be_temporary }
  end
  
  context "includes ActsAsTemporary instance methods" do    
    subject { Page.new }    
    its(:methods) { should include :can_be_temporary? }
    its(:methods) { should include :shelf_life }
    its(:shelf_life) { should == 365.days }
  end
end