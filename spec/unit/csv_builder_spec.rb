require 'rails_helper'

describe ActiveAdmin::CSVBuilder do

  describe '.default_for_resource using Post' do
    let(:csv_builder) { ActiveAdmin::CSVBuilder.default_for_resource(Post).tap(&:exec_columns) }

    it 'returns a default csv_builder for Post' do
      expect(csv_builder).to be_a(ActiveAdmin::CSVBuilder)
    end

    it 'defines Id as the first column' do
      expect(csv_builder.columns.first.name).to eq 'Id'
      expect(csv_builder.columns.first.data).to eq :id
    end

    it "has Post's content_columns" do
      csv_builder.columns[1..-1].each_with_index do |column, index|
        expect(column.name).to eq Post.content_columns[index].name.humanize
        expect(column.data).to eq Post.content_columns[index].name.to_sym
      end
    end

    context 'when column has a localized name' do
      let(:localized_name) { 'Titulo' }

      before do
        allow(Post).to receive(:human_attribute_name).and_call_original
        allow(Post).to receive(:human_attribute_name).with(:title){ localized_name }
      end

      it 'gets name from I18n' do
        title_index = Post.content_columns.map(&:name).index('title') + 1 # First col is always id
        expect(csv_builder.columns[title_index].name).to eq localized_name
      end
    end
  end

  context 'when empty' do
    let(:builder){ ActiveAdmin::CSVBuilder.new.tap(&:exec_columns) }

    it "should have no columns" do
      expect(builder.columns).to eq []
    end
  end

  context "with a symbol column (:title)" do
    let(:builder) do
      ActiveAdmin::CSVBuilder.new do
        column :title
      end.tap(&:exec_columns)
    end

    it "should have one column" do
      expect(builder.columns.size).to eq 1
    end

    describe "the column" do
      let(:column){ builder.columns.first }

      it "should have a name of 'Title'" do
        expect(column.name).to eq "Title"
      end

      it "should have the data :title" do
        expect(column.data).to eq :title
      end
    end
  end

  context "with a block and title" do
    let(:builder) do
      ActiveAdmin::CSVBuilder.new do
        column "My title" do
          # nothing
        end
      end.tap(&:exec_columns)
    end

    it "should have one column" do
      expect(builder.columns.size).to eq 1
    end

    describe "the column" do
      let(:column){ builder.columns.first }

      it "should have a name of 'My title'" do
        expect(column.name).to eq "My title"
      end

      it "should have the data :title" do
        expect(column.data).to be_an_instance_of(Proc)
      end
    end
  end

  context "with a humanize_name column option" do
    context "with symbol column name" do
      let(:builder) do
        ActiveAdmin::CSVBuilder.new do
          column :my_title, humanize_name: false
        end.tap(&:exec_columns)
      end

      describe "the column" do
        let(:column){ builder.columns.first }

        it "should have a name of 'my_title'" do
          expect(column.name).to eq "my_title"
        end
      end
    end

    context "with string column name" do
      let(:builder) do
        ActiveAdmin::CSVBuilder.new do
          column "my_title", humanize_name: false
        end.tap(&:exec_columns)
      end

      describe "the column" do
        let(:column){ builder.columns.first }

        it "should have a name of 'my_title'" do
          expect(column.name).to eq "my_title"
        end
      end
    end
  end

  context "with a separator" do
    let(:builder) do
      ActiveAdmin::CSVBuilder.new(col_sep: ";").tap(&:exec_columns)
    end

    it "should have proper separator" do
      expect(builder.options).to eq({col_sep: ";"})
    end
  end

  context "with humanize_name option" do
    let(:builder) do
      ActiveAdmin::CSVBuilder.new(humanize_name: false) do
        column :my_title
      end.tap(&:exec_columns)
    end

    describe "the column" do
      let(:column){ builder.columns.first }

      it "should have humanize_name option set" do
        expect(column.options).to eq humanize_name: false
      end

      it "should have a name of 'my_title'" do
        expect(column.name).to eq "my_title"
      end
    end
  end

  context "with csv_options" do
    let(:builder) do
      ActiveAdmin::CSVBuilder.new(force_quotes: true).tap(&:exec_columns)
    end

    it "should have proper separator" do
      expect(builder.options).to eq({force_quotes: true})
    end
  end

  context "with access to the controller" do
    let(:dummy_view_context) { double(controller: dummy_controller) }
    let(:dummy_controller) { double(names: %w(title summary updated_at created_at))}
    let(:builder) do
      ActiveAdmin::CSVBuilder.new do
        column "id"
        controller.names.each do |name|
          column(name)
        end
      end.tap{ |b| b.exec_columns(dummy_view_context) }
    end

    it "should build columns provided by the controller" do
      expect(builder.columns.map(&:data)).to match_array([:id, :title, :summary, :updated_at, :created_at])
    end
  end

  context "build csv using the supplied order" do
    before do
      @post1 = Post.create!(title: "Hello1", published_at: Date.today - 2.day )
      @post2 = Post.create!(title: "Hello2", published_at: Date.today - 1.day )
    end
    let(:dummy_controller) {
      class DummyController
        def find_collection(*)
          collection
        end

        def collection
          Post.order('published_at DESC')
        end

        def apply_decorator(resource)
          resource
        end

        def view_context
        end
      end
      DummyController.new
    }
    let(:builder) do
      ActiveAdmin::CSVBuilder.new do
        column "id"
        column "title"
        column "published_at"
      end
    end

    it "should generate data with the supplied order" do
      expect(builder).to receive(:build_row).and_return([]).once.ordered { |post| expect(post.id).to eq @post2.id }
      expect(builder).to receive(:build_row).and_return([]).once.ordered { |post| expect(post.id).to eq @post1.id }
      builder.build dummy_controller, []
    end

    it "should generate data ignoring pagination" do
      expect(dummy_controller).to receive(:find_collection).
        with(except: :pagination).once.
        and_call_original
      expect(builder).to receive(:build_row).and_return([]).twice
      builder.build dummy_controller, []
    end

  end

  skip '#exec_columns'

  skip '#build_row' do
    it 'renders non-strings'
    it 'encodes values correctly'
    it 'passes custom encoding options to String#encode!'
  end

end
