require 'rails_helper'

RSpec.describe ActiveAdmin::Views::Pages::Show do

  describe "the resource" do
    let(:helpers) { double resource: resource }
    let(:arbre_context) { Arbre::Context.new({}, helpers) }
    subject(:page) { ActiveAdmin::Views::Pages::Show.new(arbre_context) }

    context 'when the resource does not respond to #decorator' do
      let(:resource) { 'Test Resource' }

      it "normally returns the resource" do
        expect(page.resource).to eq 'Test Resource'
      end
    end

    context 'when you pass a block to main content' do
      let(:block) { lambda { } }
      let(:resource) { double('resource') }

      before { allow(page).to receive(:active_admin_config).and_return(double(comments?: false, resource_columns: [:field]))}

      it 'appends it to the output' do
        expect(page).to receive(:attributes_table).with(:field).and_yield
        page.default_main_content(&block)
      end
    end

  end

end
