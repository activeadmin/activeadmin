require 'rails_helper'

RSpec.describe ActiveAdmin::Filters::Active do

  let(:resource) do
    namespace = ActiveAdmin::Namespace.new(ActiveAdmin::Application.new, :admin)
    namespace.register(Post)
  end

  subject { described_class.new(resource, search) }

  let(:params) do
    ::ActionController::Parameters.new(q: {author_id_eq: 1})
  end

  let(:search) do
    Post.ransack(params[:q])
  end

  it 'should have filters' do
    expect(subject.filters.size).to eq(1)
  end

end
