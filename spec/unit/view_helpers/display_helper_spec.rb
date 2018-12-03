require 'rails_helper'
require 'active_admin/view_helpers/active_admin_application_helper'
require 'active_admin/view_helpers/auto_link_helper'
require 'active_admin/view_helpers/display_helper'
require 'active_admin/view_helpers/method_or_proc_helper'

RSpec.describe ActiveAdmin::ViewHelpers::DisplayHelper do
  include ActiveAdmin::ViewHelpers::ActiveAdminApplicationHelper
  include ActiveAdmin::ViewHelpers::AutoLinkHelper
  include ActiveAdmin::ViewHelpers::DisplayHelper
  include MethodOrProcHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TranslationHelper
  include ActionView::Helpers::SanitizeHelper

  def active_admin_namespace
    active_admin_application.namespaces[:admin]
  end

  def authorized?(*)
    true
  end

  def url_options
    { locale: nil }
  end

  let(:displayed_name) { display_name(resource) }

  before do
    load_resources do
      ActiveAdmin.register(User)
      ActiveAdmin.register(Post){ belongs_to :user, optional: true }
    end
  end

  describe '#display_name' do
    let(:resource) { klass.new }

    ActiveAdmin::Application.new.display_name_methods.map(&:to_s).each do |m|
      context "when it is the identity" do
        let(:klass) do
          Class.new do
            define_method(m) { m }
          end
        end

        it "should return #{m}" do
          expect(displayed_name).to eq m
        end
      end

      context "when it includes js" do
        let(:klass) do
          Class.new do
            define_method(m) { '<script>alert(1)</script>' }
          end
        end

        it "should sanitize the result of #{m}" do
          expect(displayed_name).to eq 'alert(1)'
        end
      end
    end

    describe "memoization" do
      let(:klass) { Class.new }

      it "should memoize the result for the class" do
        expect(resource).to receive(:name).and_return "My Name"
        expect(displayed_name).to eq "My Name"

        expect(ActiveAdmin.application).to_not receive(:display_name_methods)
        expect(displayed_name).to eq "My Name"
      end

      it "should not call a method if it's an association" do
        allow(klass).to receive(:reflect_on_all_associations).and_return [ double(name: :login) ]
        allow(resource).to receive :login
        expect(resource).to_not receive :login
        allow(resource).to receive(:email).and_return 'foo@bar.baz'

        expect(displayed_name).to eq 'foo@bar.baz'
      end
    end

    context "when the passed object is `nil`" do
      let(:resource) { nil }

      it "should return `nil` when the passed object is `nil`" do
        expect(displayed_name).to eq nil
      end
    end

    context "when the passed object is `false`" do
      let(:resource) { false }

      it "should return 'false' when the passed object is `false`" do
        expect(displayed_name).to eq "false"
      end
    end

    describe "default implementation" do
      let(:klass) { Class.new }

      it "should default to `to_s`" do
        result = resource.to_s

        expect(displayed_name).to eq sanitize(result)
      end
    end

    context "when no display name method is defined" do
      context "when no ID" do
        let(:resource) do
          class ThisModel
            extend ActiveModel::Naming
          end

          ThisModel.new
        end

        it "should show the model name" do
          expect(displayed_name).to eq "This model"
        end
      end

      context "when ID" do
        let(:resource) { Tagging.create! }

        it "should show the model name, plus the ID if in use" do
          expect(displayed_name).to eq "Tagging #1"
        end

        it "should translate the model name" do
          with_translation activerecord: {models: {tagging: {one: "Different"}}} do
            expect(displayed_name).to eq "Different #1"
          end
        end
      end
    end
  end

  describe '#format_attribute' do
    it 'calls the provided block to format the value' do
      value = format_attribute double(foo: 2), ->r { r.foo + 1 }

      expect(value).to eq '3'
    end

    it 'finds values as methods' do
      value = format_attribute double(name: 'Joe'), :name

      expect(value).to eq 'Joe'
    end

    it 'finds values from hashes' do
      value = format_attribute({id: 100}, :id)

      expect(value).to eq '100'
    end

    [1, 1.2, :a_symbol].each do |val|
      it "calls to_s to format the value of type #{val.class}" do
        value = format_attribute double(foo: val), :foo

        expect(value).to eq val.to_s
      end
    end

    it 'localizes dates' do
      date = Date.parse '2016/02/28'

      value = format_attribute double(date: date), :date

      expect(value).to eq 'February 28, 2016'
    end

    it 'localizes times' do
      time = Time.parse '2016/02/28 9:34 PM'

      value = format_attribute double(time: time), :time

      expect(value).to eq 'February 28, 2016 21:34'
    end

    it 'uses a display_name method for arbitrary objects' do
      object = double to_s: :wrong, display_name: :right

      value = format_attribute double(object: object), :object

      expect(value).to eq 'right'
    end

    it 'auto-links ActiveRecord records by association' do
      post = Post.create! author: User.new

      value = format_attribute post, :author

      expect(value).to match /<a href="\/admin\/users\/\d+"> <\/a>/
    end

    it 'auto-links ActiveRecord records & uses a display_name method' do
      post = Post.create! author: User.new(first_name: 'A', last_name: 'B')

      value = format_attribute post, :author

      expect(value).to match /<a href="\/admin\/users\/\d+">A B<\/a>/
    end

    pending 'auto-links Mongoid records'

    it 'calls status_tag for boolean values' do
      post = Post.new starred: true

      value = format_attribute post, :starred

      expect(value.to_s).to eq "<span class=\"status_tag yes\">Yes</span>\n"
    end

    it 'calls status_tag for boolean non-database values' do
      post = Post.new
      post.define_singleton_method(:true_method) do
        true
      end
      post.define_singleton_method(:false_method) do
        false
      end
      true_value = format_attribute post, :true_method
      expect(true_value.to_s).to eq "<span class=\"status_tag yes\">Yes</span>\n"
      false_value = format_attribute post, :false_method
      expect(false_value.to_s).to eq "<span class=\"status_tag no\">No</span>\n"
    end

  end
end
