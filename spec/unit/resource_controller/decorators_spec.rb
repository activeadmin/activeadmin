require 'spec_helper'

describe ActiveAdmin::ResourceController::Decorators do
  let(:controller_class) do
    Class.new do
      def self.name
        "Test Controller using Decorators"
      end

      include ActiveAdmin::ResourceController::Decorators

      public :apply_decorator, :apply_collection_decorator
    end
  end

  let(:controller) { controller_class.new }
  let(:active_admin_config) { double(decorator_class: decorator_class) }
  before { controller.stub(active_admin_config: active_admin_config) }
  before { controller.stub(action_name: action) }


  describe '#apply_decorator' do
    let(:action) { 'show' }
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
    let(:action) { 'index' }
    let(:collection) { Post.where nil }
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
          expect(applied.class.name).to eq "Draper::CollectionDecorator of PostDecorator + ActiveAdmin"
        end

      end
    end
  end

  describe 'form actions' do
    let(:action) { 'edit' }
    let(:resource) { Post.new }
    let(:form_presenter) { double options: { decorate: decorate_form } }
    let(:decorator_class) { PostDecorator }
    before { allow(active_admin_config).to receive(:get_page_presenter).with(:form).and_return form_presenter }

    subject(:applied) { controller.apply_decorator(resource) }

    context 'when the form is not configured to decorate' do
      let(:decorate_form) { false }
      it { should be_kind_of(Post) }
    end

    context 'when the form is configured to decorate' do
      let(:decorate_form) { true }
      it { should be_kind_of(PostDecorator) }
    end

  end
end
