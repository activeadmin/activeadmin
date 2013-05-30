require 'spec_helper'

describe ActiveAdmin::Views::Pages::Show do

  describe "the resource" do
    let(:helpers) { mock(:resource => resource) }
    let(:arbre_context) { Arbre::Context.new({}, helpers) }

    context 'when the resource does not respond to #decorator' do
      let(:resource) { 'Test Resource' }

      it "normally returns the resource" do
        page = ActiveAdmin::Views::Pages::Show.new(arbre_context)
        page.resource.should == 'Test Resource'
      end
    end

  end

end
