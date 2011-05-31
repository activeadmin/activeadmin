require 'spec_helper'

include ActiveAdmin

describe ActiveAdmin::Renderer do

  context "when initiailizing from a view" do
    it "should have a view" do
      view = action_view
      renderer = Renderer.new(view)
      renderer.view.should == view
    end

    it "should assign all local variables from the view" do
      Renderer.new(action_view(:foo => "bar")).send(:instance_variable_get, "@foo").should == "bar"
    end
    
    it "should assing an instance variable to the view" do
      view = action_view
      renderer = Renderer.new(view)
      renderer.send :set_ivar_on_view, "@my_ivar", 'Hello World'
      view.instance_variable_get("@my_ivar").should == 'Hello World'
    end
  end

  context "when initializing from another renderer" do
    it "should have the view" do
      view = action_view
      renderer = Renderer.new(Renderer.new(view))
      renderer.view.should == view
    end

    it "should assign local variables from the renderer" do
      view = action_view(:foo => 'bar')
      renderer = Renderer.new(Renderer.new(view))
      renderer.send(:instance_variable_get, "@foo").should == 'bar'
    end

    it "should assing an instance variable to the view" do
      view = action_view
      renderer = Renderer.new(Renderer.new(view))
      renderer.send :set_ivar_on_view, "@my_ivar", 'Hello World'
      view.instance_variable_get("@my_ivar").should == 'Hello World'
    end    
  end

  context "when initializing from some other object" do
    it "should initialize successfully" do
      lambda {
        Renderer.new "Hello World"
      }.should_not raise_exception
    end
  end

  describe "rendering HAML" do
    before do
      @haml_renderer = Class.new(Renderer)
      @haml_renderer.class_eval do
        def hello_world
          "Hello World"
        end
      end
    end
    it "should render haml within the context of the renderer" do
      @haml_renderer.class_eval do
        def to_html
          haml <<-HAML
%p
  =hello_world
          HAML
        end
      end
      @renderer = @haml_renderer.new(action_view)
      @renderer.to_html.should == "<p>\n  Hello World\n</p>\n"
    end

    it "should allow for indentation at the start of the template" do
      @haml_renderer.class_eval do
        def to_html
          haml <<-HAML
            %p
              =hello_world
          HAML
        end
      end
      @renderer = @haml_renderer.new(action_view)
      @renderer.to_html.should == "<p>\n  Hello World\n</p>\n"      
    end
  end

  describe "#call_method_or_proc_on" do
    let(:renderer){ Renderer.new(action_view) }
    let(:obj){ "Hello World" }
    it "should return nil if no symbol or proc given" do
      renderer.send(:call_method_or_proc_on, obj, 1).should == nil
    end
    it "should call the method if a symbol is given" do
      renderer.send(:call_method_or_proc_on, obj, :size).should == obj.size
    end
    it "should call the method if a string is given" do
      renderer.send(:call_method_or_proc_on, obj, "size").should == obj.size
    end
    it "should call the proc with the object if a proc is given" do
      p = Proc.new{|string| string.size }
      renderer.send(:call_method_or_proc_on, obj, p).should == obj.size
    end
  end
end
