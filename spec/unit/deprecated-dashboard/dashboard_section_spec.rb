require 'spec_helper' 

describe ActiveAdmin::Dashboards::Section do

  def section(options = {})
    name = options.delete(:name) || "Recent Posts"
    ActiveAdmin::Dashboards::Section.new(:admin, name, options){ }
  end

  describe "accessors" do
    it "should have a namespace" do
      section.namespace.should == :admin
    end

    it "should have a block" do
      section.block.class.should == Proc
    end

    it "should have a name" do
      section.name.should == 'Recent Posts'
    end
  end

  describe "priority" do
    context "when not set" do
      subject{ section.priority }
      it { should == ActiveAdmin::Dashboards::Section::DEFAULT_PRIORITY }
    end

    context "when set" do
      subject{ section(:priority => 1).priority }
      it { should == 1 }
    end
  end

  describe "icon" do
    it "should set the icon" do
      s = section(:icon => :my_icon)
      s.icon.should == :my_icon
    end
    it "should be nil by default" do
      section.icon.should be_nil
    end
  end

  describe "sorting sections" do
    it "should sort by priority then alpha" do
      s1 = section :name => "Woot"
      s2 = section :name => :Alpha
      s3 = section :name => "Zulu", :priority => 1
      s4 = section :name => "Beta", :priority => 100
      [s1,s2,s3,s4].sort.should == [s3, s2, s1, s4]
    end
  end

end
