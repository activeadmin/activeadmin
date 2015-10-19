require 'rails_helper'

describe ActiveAdmin::ResourceController::Forms do
  let(:controller_class) do
    Class.new do
      def self.name
        "Test Controller using Forms"
      end

      include ActiveAdmin::ResourceController::Forms

      public :apply_form
    end
  end

  let(:controller) { controller_class.new }
  let(:active_admin_config) { double(form_class: form_class) }
  before do
    allow(controller).to receive(:active_admin_config).and_return(active_admin_config)
    allow(controller).to receive(:action_name).and_return(action)
  end

  describe '#apply_form' do
    let(:action) { 'edit' }
    let(:resource) { Post.new }
    subject(:applied) { controller.apply_form(resource) }

    context 'with a form class configured' do
      let(:form_class) { PostForm }
      it { is_expected.to be_kind_of(PostForm) }
    end

    context 'with a form class configured on show action' do
      let(:form_class) { PostForm }
      let(:action) { 'show' }
      it { is_expected.to be_kind_of(Post) }
    end

    context 'with no form class configured' do
      let(:form_class) { nil }
      it { is_expected.to be_kind_of(Post) }
    end
  end
end
