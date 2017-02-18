require 'rails_helper'

RSpec.describe ActiveAdmin::Filters::Active do
  subject { described_class.new(Post, params) }
  let(:params_klass) do
    if defined? ::ActionController::Parameters
      ::ActionController::Parameters
    else
      HashWithIndifferentAccess #remove this when drop rails 3 support
    end
  end

  let(:params) do
    params_klass.new(q: {author_id_eq: 1})
  end

  it 'should have filters' do
    expect(subject.filters.size).to eq(1)
  end

end
