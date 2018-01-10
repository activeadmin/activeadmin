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

  before do
    load_resources do
      ActiveAdmin.register(User)
      ActiveAdmin.register(Post){ belongs_to :user, optional: true }
    end
  end

  describe '#display_name' do
    ActiveAdmin::Application.new.display_name_methods.map(&:to_s).each do |m|
      it "should return #{m} when defined" do
        klass = Class.new do
          define_method(m) { m }
        end
        expect(display_name klass.new).to eq m
      end

      it "should sanitize the result of #{m} when defined" do
        klass = Class.new do
          define_method(m) { '<script>alert(1)</script>' }
        end
        expect(display_name klass.new).to eq 'alert(1)'
      end
    end

    it "should memoize the result for the class" do
      subject = Class.new.new
      expect(subject).to receive(:name).twice.and_return "My Name"

      expect(display_name subject).to eq "My Name"

      expect(ActiveAdmin.application).to_not receive(:display_name_methods)
      expect(display_name subject).to eq "My Name"
    end

    it "should not call a method if it's an association" do
      klass = Class.new
      subject = klass.new
      allow(klass).to receive(:reflect_on_all_associations).and_return [ double(name: :login) ]
      allow(subject).to receive :login
      expect(subject).to_not receive :login
      allow(subject).to receive(:email).and_return 'foo@bar.baz'

      expect(display_name subject).to eq 'foo@bar.baz'
    end

    it "should return `nil` when the passed object is `nil`" do
      expect(display_name nil).to eq nil
    end

    it "should return 'false' when the passed object is `false`" do
      expect(display_name false).to eq "false"
    end

    it "should default to `to_s`" do
      subject = Class.new.new
      expect(display_name subject).to eq sanitize(subject.to_s)
    end

    context "when no display name method is defined" do
      context "on a Rails model" do
        it "should show the model name" do
          class ThisModel
            extend ActiveModel::Naming
          end
          subject = ThisModel.new
          expect(display_name subject).to eq "This model"
        end

        it "should show the model name, plus the ID if in use" do
          subject = Tagging.create!
          expect(display_name subject).to eq "Tagging #1"
        end

        it "should translate the model name" do
          with_translation activerecord: {models: {tagging: {one: "Different"}}} do
            subject = Tagging.create!
            expect(display_name subject).to eq "Different #1"
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
