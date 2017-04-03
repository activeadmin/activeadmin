require 'rails_helper'

RSpec.describe ActiveAdmin::Filters::Active do
  subject { described_class.new(Post, params) }

  let(:params) do
    ::ActionController::Parameters.new(q: {author_id_eq: 1})
  end

  it 'should have filters' do
    expect(subject.filters.size).to eq(1)
  end

end
