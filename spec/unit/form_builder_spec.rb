require 'spec_helper'

describe ActiveAdmin::FormBuilder do

  # Setup an ActionView::Base object which can be used for
  # generating the form for.
  let(:helpers) do
    view = action_view
    def view.posts_path
      "/posts"
    end

    def view.protect_against_forgery?
      false
    end

    def view.url_for(*args)
      if args.first == {action: "index"}
        posts_path
      else
        super
      end
    end

    def view.a_helper_method
      "A Helper Method"
    end

    view
  end

  def build_form(options = {}, form_object = Post.new, &block)
    options = {url: helpers.posts_path}.merge(options)

    render_arbre_component({form_object: form_object, form_options: options, form_block: block}, helpers) do
      text_node active_admin_form_for(assigns[:form_object], assigns[:form_options], &assigns[:form_block])
    end.to_s
  end

  context "in general with actions" do
    let :body do
      build_form do |f|
        f.inputs do
          f.input :title
          f.input :body
        end
        f.actions do
          f.action :submit, label: "Submit Me"
          f.action :submit, label: "Another Button"
        end
      end
    end

   it "should generate a text input" do
      expect(body).to have_tag("input", attributes: { type: "text",
                                                     name: "post[title]" })
    end
    it "should generate a textarea" do
      expect(body).to have_tag("textarea", attributes: { name: "post[body]" })
    end
    it "should only generate the form once" do
      expect(body.scan(/Title/).size).to eq(1)
    end
    it "should generate actions" do
      expect(body).to have_tag("input", attributes: {  type: "submit",
                                                          value: "Submit Me" })
      expect(body).to have_tag("input", attributes: {  type: "submit",
                                                          value: "Another Button" })
    end
  end

  context "when polymorphic relationship" do
    it "should raise error" do
      expect {
        comment = ActiveAdmin::Comment.new
        build_form({url: "admins/comments"}, comment) do |f|
          f.inputs :resource
        end
      }.to raise_error(Formtastic::PolymorphicInputWithoutCollectionError)
    end
  end

  describe "passing in options with actions" do
    let :body do
      build_form html: { multipart: true } do |f|
        f.inputs :title
        f.actions
      end
    end
    it "should pass the options on to the form" do
      expect(body).to have_tag("form", attributes: { enctype: "multipart/form-data" })
    end
  end

  context "with actions" do
    it "should generate the form once" do
      body = build_form do |f|
        f.inputs do
          f.input :title
        end
        f.actions
      end
      expect(body.scan(/id="post_title"/).size).to eq(1)
    end
    it "should generate one button and a cancel link" do
      body = build_form do |f|
        f.actions
      end
      expect(body.scan(/type="submit"/).size).to eq(1)
      expect(body.scan(/class="cancel"/).size).to eq(1)
    end
    it "should generate multiple actions" do
      body = build_form do |f|
        f.actions do
          f.action :submit, label: "Create & Continue"
          f.action :submit, label: "Create & Edit"
        end
      end
      expect(body.scan(/type="submit"/).size).to eq(2)
      expect(body.scan(/class="cancel"/).size).to eq(0)
    end

  end

  context "with actions" do
    it "should generate the form once" do
      body = build_form do |f|
        f.inputs do
          f.input :title
        end
        f.actions
      end
      expect(body.scan(/id="post_title"/).size).to eq(1)
    end
    it "should generate one button and a cancel link" do
      body = build_form do |f|
        f.actions
      end
      expect(body.scan(/type="submit"/).size).to eq(1)
      expect(body.scan(/class="cancel"/).size).to eq(1)
    end
    it "should generate multiple actions" do
      body = build_form do |f|
        f.actions do
          f.action :submit, label: "Create & Continue"
          f.action :submit, label: "Create & Edit"
        end
      end
      expect(body.scan(/type="submit"/).size).to eq(2)
      expect(body.scan(/class="cancel"/).size).to eq(0)
    end
  end

  context "without passing a block to inputs" do
    let :body do
      build_form do |f|
        f.inputs :title, :body
      end
    end
    it "should have a title input" do
      expect(body).to have_tag("input", attributes: { type: "text",
                                                          name: "post[title]" })
    end
    it "should have a body textarea" do
      expect(body).to have_tag("textarea", attributes: { name: "post[body]" })
    end
  end

  context "with semantic fields for" do
    let :body do
      build_form do |f|
        f.inputs do
          f.input :title
          f.input :body
        end
        f.instance_eval do
          @object.author = User.new
        end
        f.semantic_fields_for :author do |author|
          author.inputs :first_name, :last_name
        end
      end
    end
    it "should generate a nested text input once" do
      expect(body.scan("post_author_attributes_first_name_input").size).to eq(1)
    end
  end

  context "with collection inputs" do
    before do
      User.create first_name: "John", last_name: "Doe"
      User.create first_name: "Jane", last_name: "Doe"
    end

    describe "as select" do
      let :body do
        build_form do |f|
          f.input :author
        end
      end
      it "should create 2 options" do
        expect(body.scan(/<option/).size).to eq(3)
      end
    end

    describe "as radio buttons" do
      let :body do
        build_form do |f|
          f.input :author, as: :radio
        end
      end
      it "should create 2 radio buttons" do
        expect(body.scan(/type="radio"/).size).to eq(2)
      end
    end

  end

  context "with inputs 'for'" do
    let :body do
      build_form do |f|
        f.inputs do
          f.input :title
          f.input :body
        end
        f.instance_eval do
          @object.author = User.new
        end
        f.inputs name: 'Author', for: :author do |author|
          author.inputs :first_name, :last_name
        end
      end
    end
    it "should generate a nested text input once" do
      expect(body.scan("post_author_attributes_first_name_input").size).to eq(1)
    end
    it "should add an author first name field" do
      expect(body).to have_tag("input", attributes: { name: "post[author_attributes][first_name]"})
    end
  end

  context "with wrapper html" do
    it "should set a class" do
      body = build_form do |f|
        f.input :title, wrapper_html: { class: "important" }
      end
      expect(body).to have_tag("li", attributes: {class: "important string input optional stringish"})
    end
  end

  context "with has many inputs" do
    describe "with simple block" do
      let :body do
        build_form({url: '/categories'}, Category.new) do |f|
          f.object.posts.build
          f.has_many :posts do |p|
            p.input :title
          end
        end
      end

      it "should translate the association name in header" do
        with_translation activerecord: {models: {post: {one: 'Blog Post', other: 'Blog Posts'}}} do
          expect(body).to have_tag('h3', 'Blog Posts')
        end
      end

      it "should use model name when there is no translation for given model in header" do
        expect(body).to have_tag('h3', 'Post')
      end

      it "should translate the association name in has many new button" do
        with_translation activerecord: {models: {post: {one: 'Blog Post', other: 'Blog Posts'}}} do
          expect(body).to have_tag('a', 'Add New Blog Post')
        end
      end

      it "should translate the attribute name" do
        with_translation activerecord: {attributes: {post: {title: 'A very nice title'}}} do
          expect(body).to have_tag 'label', 'A very nice title'
        end
      end

      it "should use model name when there is no translation for given model in has many new button" do
        expect(body).to have_tag('a', 'Add New Post')
      end

      it "should render the nested form" do
        expect(body).to have_tag("input", attributes: {name: "category[posts_attributes][0][title]"})
      end

      it "should add a link to remove new nested records" do
        expect(Capybara.string(body)).to have_css '.has_many_container > fieldset > ol > li > a', href: '#',
          content: 'Remove', class: 'button has_many_remove', data: {placeholder: 'NEW_POST_RECORD'}
      end

      it "should add a link to add new nested records" do
        expect(Capybara.string(body)).to have_css(".has_many_container > fieldset > ol > li > a", class: "button", href: "#", content: "Add New Post")
      end
    end

    describe "with complex block" do
      let :body do
        build_form({url: '/categories'}, Category.new) do |f|
          f.object.posts.build
          f.has_many :posts do |p,i|
            p.input :title, label: "Title #{i}"
          end
        end
      end

      it "should accept a block with a second argument" do
        expect(body).to have_tag("label", "Title 1")
      end

      it "should add a custom header" do
        expect(body).to have_tag('h3', 'Post')
      end

    end

    describe "without heading and new record link" do
      let :body do
        build_form({url: '/categories'}, Category.new) do |f|
          f.object.posts.build
          f.has_many :posts, heading: false, new_record: false do |p|
            p.input :title
          end
        end
      end

      it "should not add a header" do
        expect(body).not_to have_tag('h3', 'Post')
      end

      it "should not add link to new nested records" do
        expect(body).not_to have_tag('a', 'Add New Post')
      end

      it "should render the nested form" do
        expect(body).to have_tag("input", attributes: {name: "category[posts_attributes][0][title]"})
      end
    end

    describe "with custom heading" do
      let :body do
        build_form({url: '/categories'}, Category.new) do |f|
          f.object.posts.build
          f.has_many :posts, heading: "Test heading" do |p|
            p.input :title
          end
        end
      end

      it "should add a custom header" do
        expect(body).to have_tag('h3', 'Test heading')
      end

    end

    describe "with custom new record link" do
      let :body do
        build_form({url: '/categories'}, Category.new) do |f|
          f.object.posts.build
          f.has_many :posts, new_record: 'My Custom New Post' do |p|
            p.input :title
          end
        end
      end

      it "should add a custom new record link" do
        expect(body).to have_tag('a', 'My Custom New Post')
      end

    end

    describe "with allow destroy" do
      context "with an existing post" do
        let :body do
          build_form({url: '/categories'}, Category.new) do |f|
            f.object.posts.build.stub(:new_record? => false)
            f.has_many :posts, allow_destroy: true do |p|
              p.input :title
            end
          end
        end

        it "should include a boolean field for _destroy" do
          expect(body).to have_tag("input", attributes: {name: "category[posts_attributes][0][_destroy]"})
        end

        it "should have a check box with 'Remove' as its label" do
          expect(body).to have_tag("label", attributes: {for: "category_posts_attributes_0__destroy"}, content: "Delete")
        end

        it "should wrap the destroy field in an li with class 'has_many_delete'" do
          expect(Capybara.string(body)).to have_css(".has_many_container > fieldset > ol > li.has_many_delete > input")
        end
      end

      context "with a new post" do
        let :body do
          build_form({url: '/categories'}, Category.new) do |f|
            f.object.posts.build
            f.has_many :posts, allow_destroy: true do |p|
              p.input :title
            end
          end
        end

        it "should not have a boolean field for _destroy" do
          expect(body).not_to have_tag("input", attributes: {name: "category[posts_attributes][0][_destroy]"})
        end

        it "should not have a check box with 'Remove' as its label" do
          expect(body).not_to have_tag("label", attributes: {for: "category_posts_attributes_0__destroy"}, content: "Remove")
        end
      end
    end

    describe "sortable" do
      # TODO: it doesn't make any sense to use your foreign key as something that's sortable (and therefore editable)
      context "with a new post" do
        let :body do
          build_form({url: '/categories'}, Category.new) do |f|
            f.object.posts.build
            f.has_many :posts, sortable: :position do |p|
              p.input :title
            end
          end
        end

        it "shows the nested fields for unsaved records" do
          expect(body).to have_tag("fieldset", attributes: {class: "inputs has_many_fields"})
        end

      end

      context "with post returning nil for the sortable attribute" do
        let :body do
          build_form({url: '/categories'}, Category.new) do |f|
            f.object.posts.build position: 3
            f.object.posts.build
            f.has_many :posts, sortable: :position do |p|
              p.input :title
            end
          end
        end

        it "shows the nested fields for unsaved records" do
          expect(body).to have_tag("fieldset", attributes: {class: "inputs has_many_fields"})
        end

      end

      context "with existing and new posts" do
        let! :category do
          Category.create name: 'Name'
        end
        let! :post do
          category.posts.create
        end
        let :body do
          build_form({url: '/categories'}, category) do |f|
            f.object.posts.build
            f.has_many :posts, sortable: :position do |p|
              p.input :title
            end
          end
        end

        it "shows the nested fields for saved and unsaved records" do
          expect(body).to have_tag("fieldset", attributes: {class: "inputs has_many_fields"})
        end

      end
    end

    describe "with nesting" do
      context "in an inputs block" do
        let :body do
          build_form({url: '/categories'}, Category.new) do |f|
            f.inputs "Field Wrapper" do
              f.object.posts.build
              f.has_many :posts do |p|
                p.input :title
              end
            end
          end
        end

        it "should wrap the has_many fieldset in an li" do
          expect(Capybara.string(body)).to have_css("ol > li.has_many_container")
        end

        it "should have a direct fieldset child" do
          expect(Capybara.string(body)).to have_css("li.has_many_container > fieldset")
        end

        it "should not contain invalid li children" do
          expect(Capybara.string(body)).not_to have_css("div.has_many_container > li")
        end
      end

      context "in another has_many block" do
        let :body do
          build_form({url: '/categories'}, Category.new) do |f|
            f.object.posts.build
            f.has_many :posts do |p|
              p.object.taggings.build
              p.has_many :taggings do |t|
                t.input :tag
              end
            end
          end
        end

        it "should wrap the inner has_many fieldset in an ol > li" do
          expect(Capybara.string(body)).to have_css(".has_many_container ol > li.has_many_container > fieldset")
        end

        it "should not contain invalid li children" do
          expect(Capybara.string(body)).not_to have_css(".has_many_container div.has_many_container > li")
        end
      end
    end

    pending "should render the block if it returns nil" do
      body = build_form({url: '/categories'}, Category.new) do |f|
        f.object.posts.build
        f.has_many :posts do |p|
          p.input :title
          nil
        end
      end

      expect(body).to have_tag("input", attributes: {name: "category[posts_attributes][0][title]"})
    end
  end

  { # Testing that the same input can be used multiple times
    "f.input :title, as: :string"               => /id="post_title"/,
    "f.input :title, as: :text"                 => /id="post_title"/,
    "f.input :created_at, as: :time_select"     => /id="post_created_at_2i"/,
    "f.input :created_at, as: :datetime_select" => /id="post_created_at_2i"/,
    "f.input :created_at, as: :date_select"     => /id="post_created_at_2i"/,
    # Testing that return values don't screw up the form
    "f.input :title; nil"                          => /id="post_title"/,
    "f.input :title; []"                           => /id="post_title"/,
    "[:title].each{ |r| f.input r }"               => /id="post_title"/,
    "[:title].map { |r| f.input r }"               => /id="post_title"/,
  }.each do |source, regex|
   it "should properly buffer `#{source}`" do
     body = build_form do |f|
       f.inputs do
         eval source
         eval source
       end
     end
     expect(body.scan(regex).size).to eq(2)
   end
  end

  describe "datepicker input" do
    context 'with default options' do
      let :body do
        build_form do |f|
          f.inputs do
            f.input :created_at, as: :datepicker
          end
        end
      end
      it "should generate a text input with the class of datepicker" do
        expect(body).to have_tag("input", attributes: {  type: "text",
                                                            class: "datepicker",
                                                            name: "post[created_at]" })
      end
    end

    context 'with date range options' do
      let :body do
        build_form do |f|
          f.inputs do
            f.input :created_at, as: :datepicker,
                                  datepicker_options: {
                                    min_date: Date.new(2013, 10, 18),
                                    max_date: "2013-12-31" }
          end
        end
        it 'should generate a datepicker text input with data min and max dates' do
          expect(body).to have_tag("input", attributes: { type: "text",
                                                            class: "datepicker",
                                                            name: "post[created_at]",
                                                            data: { datepicker_options: {
                                                              minDate: "2013-10-18",
                                                              maxDate: "2013-12-31" }.to_json }})
        end
      end
    end
  end

end
