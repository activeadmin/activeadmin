require 'spec_helper'

describe ActiveAdmin::ResourceController::Decorators do
  let(:controller_class) do
    Class.new do
      include ActiveAdmin::ResourceController::Decorators

      def self.name
        "Test Controller using Decorators"
      end

      public :apply_decorator, :apply_collection_decorator
    end
  end

  let(:controller) { controller_class.new }
  before { controller.stub(active_admin_config: double(decorator_class: decorator_class)) }


  describe '#apply_decorator' do
    let(:resource) { Post.new }
    subject(:applied) { controller.apply_decorator(resource) }

    context 'with a decorator configured' do
      let(:decorator_class) { PostDecorator }
      it { should be_kind_of(PostDecorator) }
    end

    context 'with no decorator configured' do
      let(:decorator_class) { nil }
      it { should be_kind_of(Post) }
    end
  end

  describe '#apply_collection_decorator' do
    before { Post.create! }
    let(:collection) { Post.scoped }
    subject(:applied) { controller.apply_collection_decorator(collection) }

    context 'when a decorator is configured' do
      context 'and it is using a recent version of draper' do
        let(:decorator_class) { PostDecorator }

        it 'calling certain scope collections work' do
          # This is an example of one of the methods that was consistently
          # failing before this feature existed
          expect(applied.reorder('').count).to eq applied.count
        end

        it 'has a good description for the generated class' do
          expect(applied.class.name).to eq "Draper::CollectionDecorator of PostDecorator with ActiveAdmin extensions"
        end

      end
    end
  end
end
