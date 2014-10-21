require 'rails_helper'

describe ActiveAdmin::ViewHelpers::ColumnsHelper do
  let(:view)    { action_view }
  let(:options) { { span: 2, max_width: '200px', min_width: '100px' } }

  context '#columns' do
    it 'calls ActiveAdmin::Views::Columns#columns' do
      expect_any_instance_of(ActiveAdmin::Views::Columns).to receive(:columns)
      view.columns {}
    end
  end

  context '#column' do
    it 'calls ActiveAdmin::Views::Columns#column with options' do
      expect_any_instance_of(ActiveAdmin::Views::Columns).to receive(:column).with(options)
      view.column(options)
    end
  end

end
