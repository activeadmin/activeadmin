require 'rails_helper'

RSpec.describe ActiveAdmin::ResourceController::Decorators do
  describe '#apply_decorator' do
    let(:resource) { Post.new }
    let(:controller) { controller_with_decorator(action, decorator_class) }
    subject(:applied) { controller.apply_decorator(resource) }

    context "in show action" do
      let(:action) { 'show' }
      let(:decorator_class) { PostDecorator }

      it { is_expected.to be_kind_of(PostDecorator) }
    end

    context "in update action" do
      let(:action) { 'update' }
      let(:decorator_class) { nil }

      it { is_expected.not_to be_kind_of(PostDecorator) }
    end
  end

  describe '#apply_collection_decorator' do
    before { Post.create! }
    let(:collection) { Post.where nil }
    let(:controller) { controller_with_decorator("index", PostDecorator) }
    subject(:applied) { controller.apply_collection_decorator(collection) }

    context 'when a decorator is configured' do
      context 'and it is using a recent version of draper' do
        it 'calling certain scope collections work' do
          # This is an example of one of the methods that was consistently
          # failing before this feature existed
          expect(applied.reorder('').count).to eq applied.count
        end

        it 'has a good description for the generated class' do
          expect(applied.class.name).to eq "Draper::CollectionDecorator of PostDecorator + ActiveAdmin"
        end
      end
    end
  end

  describe 'form actions' do
    let(:resource) { Post.new }
    let(:controller) { controller_with_decorator("edit", decorator_class) }

    subject(:applied) { controller.apply_decorator(resource) }

    context 'when the form is not configured to decorate' do
      let(:decorator_class) { nil }
      it { is_expected.to be_kind_of(Post) }
    end

    context 'when the form is configured to decorate' do
      let(:decorator_class) { PostDecorator }
      it { is_expected.to be_kind_of(PostDecorator) }
    end
  end
end
