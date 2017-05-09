require 'rails_helper'

RSpec.describe ActiveAdmin::Filters::ActiveFilter do

  let(:namespace) do
    ActiveAdmin::Namespace.new(ActiveAdmin::Application.new, :admin)
  end

  let(:resource) do
    namespace.register(Post)
  end

  let(:user){ User.create! first_name: "John", last_name: "Doe" }
  let(:category){ Category.create! name: "Category" }
  let(:post){ Post.create! title: "Hello World", category: category, author: user }

  let(:search) do
    Post.ransack(title_equals: post.title)
  end

  let(:condition) do
    search.conditions[0]
  end

  subject do
    ActiveAdmin::Filters::ActiveFilter.new(resource, condition)
  end

  it 'should have valid values' do
    expect(subject.values).to eq([post.title])
  end

  it 'should have valid label' do
    expect(subject.label).to eq("Title equals")
  end

  context 'search by belongs_to association' do
    let(:search) do
      Post.ransack(custom_category_id_eq: category.id)
    end

    it 'should have valid values' do
      expect(subject.values[0]).to be_a(Category)
    end

    it 'should have valid label' do
      expect(subject.label).to eq("Category")
    end

  end

  context 'search by has many association' do
    let(:resource) do
      namespace.register(Category)
    end

    let(:search) do
      Category.ransack(posts_id_eq: post.id)
    end

    it 'should have valid values' do
      expect(subject.values[0]).to be_a(Post)
    end

    it 'should have valid label' do
      expect(subject.label).to eq("Post")
    end

    context 'search by has many through association' do
      let(:resource) do
        namespace.register(User)
      end

      let(:search) do
        User.ransack(posts_category_id_eq: category.id)
      end

      it 'should have valid values' do
        expect(subject.values[0]).to be_a(Category)
      end

      it 'should have valid label' do
        expect(subject.label).to eq("Category")
      end

    end

  end

end