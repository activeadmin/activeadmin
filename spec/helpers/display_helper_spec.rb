# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::DisplayHelper, type: :helper do
  let(:active_admin_namespace) { helper.active_admin_application.namespaces[:admin] }
  let(:displayed_name) { helper.display_name(resource) }

  before do
    helper.class.send(:include, ActiveAdmin::LayoutHelper)
    helper.class.send(:include, ActiveAdmin::AutoLinkHelper)
    helper.class.send(:include, MethodOrProcHelper)
    allow(helper).to receive(:authorized?).and_return(true)
    allow(helper).to receive(:active_admin_namespace).and_return(active_admin_namespace)
    allow(helper).to receive(:url_options).and_return(locale: nil)

    load_resources do
      ActiveAdmin.register(User)
      ActiveAdmin.register(Post) { belongs_to :user, optional: true }
    end
  end

  describe "display name fallback constant" do
    let(:fallback_proc) { described_class::DISPLAY_NAME_FALLBACK }

    it "sets the proc to be inspectable" do
      expect(fallback_proc.inspect).to eq "DISPLAY_NAME_FALLBACK"
    end

    it "returns a primary key only if class has no model name" do
      resource_class = Class.new do
        def self.primary_key
          :id
        end

        def id
          123
        end
      end

      expect(helper.render_in_context(resource_class.new, fallback_proc)).to eq " #123"
    end
  end

  describe "#display_name" do
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
            define_method(m) { "<script>alert(1)</script>" }
          end
        end

        it "should sanitize the result of #{m}" do
          expect(displayed_name).to eq "&lt;script&gt;alert(1)&lt;/script&gt;"
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
        allow(resource).to receive(:email).and_return "foo@bar.baz"

        expect(displayed_name).to eq "foo@bar.baz"
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

        expect(displayed_name).to eq ERB::Util.html_escape(result)
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
          with_translation %i[activerecord models tagging one], "Different" do
            expect(displayed_name).to eq "Different #1"
          end
        end
      end
    end
  end

  describe "#format_attribute" do
    it "calls the provided block to format the value" do
      value = helper.format_attribute double(foo: 2), ->r { r.foo + 1 }

      expect(value).to eq "3"
    end

    it "finds values as methods" do
      value = helper.format_attribute double(name: "Joe"), :name

      expect(value).to eq "Joe"
    end

    it "finds values from hashes" do
      value = helper.format_attribute({ id: 100 }, :id)

      expect(value).to eq "100"
    end

    [1, 1.2, :a_symbol].each do |val|
      it "calls to_s to format the value of type #{val.class}" do
        value = helper.format_attribute double(foo: val), :foo

        expect(value).to eq val.to_s
      end
    end

    it "localizes dates" do
      date = Date.parse "2016/02/28"

      value = helper.format_attribute double(date: date), :date

      expect(value).to eq "February 28, 2016"
    end

    it "localizes times" do
      time = Time.parse "2016/02/28 9:34 PM"

      value = helper.format_attribute double(time: time), :time

      expect(value).to eq "February 28, 2016 21:34"
    end

    it "uses a display_name method for arbitrary objects" do
      object = double to_s: :wrong, display_name: :right

      value = helper.format_attribute double(object: object), :object

      expect(value).to eq "right"
    end

    it "auto-links ActiveRecord records by association with display name fallback" do
      post = Post.create! author: User.new(first_name: "", last_name: "")

      value = helper.format_attribute post, :author

      expect(value).to match(/<a href="\/admin\/users\/\d+">User \#\d+<\/a>/)
    end

    it "auto-links ActiveRecord records & uses a display_name method" do
      post = Post.create! author: User.new(first_name: "A", last_name: "B")

      value = helper.format_attribute post, :author

      expect(value).to match(/<a href="\/admin\/users\/\d+">A B<\/a>/)
    end

    it "calls status_tag for boolean values" do
      post = Post.new starred: true

      value = helper.format_attribute post, :starred

      expect(value.to_s).to eq "<span class=\"status-tag\" data-status=\"yes\">Yes</span>\n"
    end

    context "with non-database boolean attribute" do
      let(:model_class) do
        Class.new(Post) do
          attribute :a_virtual_attribute, :boolean
        end
      end

      it "calls status_tag even when attribute is nil" do
        post = model_class.new a_virtual_attribute: nil

        value = helper.format_attribute post, :a_virtual_attribute

        expect(value.to_s).to eq "<span class=\"status-tag\" data-status=\"unset\">Unknown</span>\n"
      end
    end

    it "calls status_tag for boolean non-database values" do
      post = Post.new
      post.define_singleton_method(:true_method) do
        true
      end
      post.define_singleton_method(:false_method) do
        false
      end
      true_value = helper.format_attribute post, :true_method
      expect(true_value.to_s).to eq "<span class=\"status-tag\" data-status=\"yes\">Yes</span>\n"
      false_value = helper.format_attribute post, :false_method
      expect(false_value.to_s).to eq "<span class=\"status-tag\" data-status=\"no\">No</span>\n"
    end

    it "renders ActiveRecord relations as a list" do
      tags = (1..3).map do |i|
        Tag.create!(name: "abc#{i}")
      end
      post = Post.create!(tags: tags)

      value = helper.format_attribute post, :tags

      expect(value.to_s).to eq "abc1, abc2, abc3"
    end

    it "renders arrays as a list" do
      items = (1..3).map { |i| "abc#{i}" }
      post = Post.create!
      allow(post).to receive(:items).and_return(items)

      value = helper.format_attribute post, :items

      expect(value.to_s).to eq "abc1, abc2, abc3"
    end
  end

  describe "#pretty_format" do
    let(:formatted_obj) { helper.pretty_format(obj) }

    shared_examples_for "an object convertible to string" do
      it "should call `to_s` on the given object" do
        expect(formatted_obj).to eq obj.to_s
      end
    end

    context "when given a string" do
      let(:obj) { "hello" }

      it_behaves_like "an object convertible to string"
    end

    context "when given an integer" do
      let(:obj) { 23 }

      it_behaves_like "an object convertible to string"
    end

    context "when given a float" do
      let(:obj) { 5.67 }

      it_behaves_like "an object convertible to string"
    end

    context "when given an exponential" do
      let(:obj) { 10**30 }

      it_behaves_like "an object convertible to string"
    end

    context "when given a symbol" do
      let(:obj) { :foo }

      it_behaves_like "an object convertible to string"
    end

    context "when given an arbre element" do
      let(:obj) { Arbre::Element.new.br }

      it_behaves_like "an object convertible to string"
    end

    shared_examples_for "a time-ish object" do
      it "formats it with the default long format" do
        expect(formatted_obj).to eq "February 28, 1985 20:15"
      end

      it "formats it with a customized long format" do
        with_translation %i[time formats long], "%B %d, %Y, %l:%M%P" do
          expect(formatted_obj).to eq "February 28, 1985,  8:15pm"
        end
      end

      context "with a custom localize format" do
        around do |example|
          previous_localize_format = ActiveAdmin.application.localize_format
          ActiveAdmin.application.localize_format = :short
          example.call
          ActiveAdmin.application.localize_format = previous_localize_format
        end

        it "formats it with the default custom format" do
          expect(formatted_obj).to eq "28 Feb 20:15"
        end

        it "formats it with i18n custom format" do
          with_translation %i[time formats short], "%-m %d %Y" do
            expect(formatted_obj).to eq "2 28 1985"
          end
        end
      end

      context "with non-English locale" do
        around do |example|
          I18n.with_locale(:es, &example)
        end

        it "formats it with the default long format" do
          expect(formatted_obj).to eq "28 de febrero de 1985 20:15"
        end

        it "formats it with a customized long format" do
          with_translation %i[time formats long], "El %d de %B de %Y a las %H horas y %M minutos" do
            expect(formatted_obj).to eq "El 28 de febrero de 1985 a las 20 horas y 15 minutos"
          end
        end
      end
    end

    context "when given a Time in utc" do
      let(:obj) { Time.utc(1985, "feb", 28, 20, 15, 1) }

      it_behaves_like "a time-ish object"
    end

    context "when given a DateTime" do
      let(:obj) { DateTime.new(1985, 2, 28, 20, 15, 1) }

      it_behaves_like "a time-ish object"
    end

    context "given an ActiveRecord object" do
      let(:obj) { Post.new }

      it "should delegate to auto_link" do
        expect(view).to receive(:auto_link).with(obj).and_return("model name")
        expect(formatted_obj).to eq "model name"
      end
    end

    context "given an arbitrary object" do
      let(:obj) { Class.new.new }

      it "should delegate to `display_name`" do
        expect(view).to receive(:display_name).with(obj) { "I'm not famous" }
        expect(formatted_obj).to eq "I'm not famous"
      end
    end
  end
end
