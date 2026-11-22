# frozen_string_literal: true
require "rails_helper"
require "csv"

RSpec.describe "Index as CSV", type: :request do
  let(:byte_order_mark) { "\xEF\xBB\xBF".b }

  def register_post(**options, &block)
    register_resources { ActiveAdmin.register(Post, **options, &block) }
  end

  # Requests the CSV, checks it's served as a CSV download named after the
  # resource, and returns its rows.
  def download_csv(path: admin_posts_path(format: :csv), filename: "posts", col_sep: ",")
    get path

    expect(response).to have_http_status(:ok)
    expect(response.headers["Content-Type"]).to eq "text/csv; charset=utf-8"
    expect(response.headers["Content-Disposition"]).to match(/\Aattachment; filename="#{filename}-\d{4}-\d{2}-\d{2}\.csv"\z/)
    expect(Time.httpdate(response.headers["Last-Modified"])).to be_a(Time)

    CSV.parse(response.body.b.delete_prefix(byte_order_mark).force_encoding(response.body.encoding), col_sep: col_sep)
  end

  default_header = ["Id", "Title", "Body", "Published date", "Position", "Starred", "Foo", "Created at", "Updated at"]
  timestamp = /\A\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} UTC\z/

  describe "default columns" do
    before { Post.create!(title: "Hello World") }

    it "includes every attribute, humanized" do
      register_post

      expect(download_csv).to match [
        default_header,
        [/\A\d+\z/, "Hello World", nil, nil, nil, nil, nil, timestamp, timestamp]
      ]
    end

    it "is the same with streaming disabled" do
      set_application_setting(:disable_streaming_in, ["test"])
      register_post

      expect(download_csv).to match [
        default_header,
        [/\A\d+\z/, "Hello World", nil, nil, nil, nil, nil, timestamp, timestamp]
      ]
    end

    it "is named after a resource's alias" do
      register_post(as: "MyArticle")

      rows = download_csv(path: admin_my_articles_path(format: :csv), filename: "my-articles")

      expect(rows.first).to eq default_header
    end

    it "starts with a byte order mark" do
      register_post

      get admin_posts_path(format: :csv)

      expect(response.body.b).to start_with(byte_order_mark)
    end
  end

  describe "csv block" do
    it "uses the columns it defines" do
      register_post do
        csv do
          column :title
          column("Last update") { |post| post.updated_at }
          column("Copyright") { "Greg Bell" }
        end
      end
      Post.create!(title: "Hello, World")

      expect(download_csv).to match [
        ["Title", "Last update", "Copyright"],
        ["Hello, World", timestamp, "Greg Bell"]
      ]
    end

    it "uses a custom separator" do
      register_post do
        csv(col_sep: ";") do
          column :title
          column :body
        end
      end
      Post.create!(title: "Hello, World")

      expect(download_csv(col_sep: ";")).to eq [["Title", "Body"], ["Hello, World", nil]]
    end

    it "doesn't humanize column names with humanize_name: false" do
      register_post do
        csv(humanize_name: false) do
          column :title
          column :body
        end
      end
      Post.create!(title: "Hello, World")

      expect(download_csv).to eq [["title", "body"], ["Hello, World", nil]]
    end

    it "quotes every value with force_quotes" do
      register_post do
        csv(force_quotes: true, byte_order_mark: "") do
          column :title
          column :body
        end
      end
      Post.create!(title: "012345")

      # force_quotes writes a blank body as "", which parses as an empty string.
      expect(download_csv).to eq [["Title", "Body"], ["012345", ""]]
      expect(response.body).to include('"012345"')
      expect(response.body.b).not_to start_with(byte_order_mark)
    end

    it "adds a byte order mark on every request, not just the first" do
      register_post do
        csv(byte_order_mark: "\xEF\xBB\xBF") { column :title }
      end

      2.times do
        get admin_posts_path(format: :csv)
        expect(response.body.b).to start_with(byte_order_mark)
        expect(response.body.b.delete_prefix(byte_order_mark)).not_to start_with(byte_order_mark)
      end
    end

    it "includes column names with column_names: true" do
      set_application_setting(:csv_options, { col_sep: ",", force_quotes: true })
      register_post do
        csv(column_names: true) do
          column :title
          column :body
        end
      end
      Post.create!(title: "012345")

      expect(download_csv).to eq [["Title", "Body"], ["012345", ""]]
    end

    it "leaves out column names with column_names: false" do
      set_application_setting(:csv_options, { col_sep: ",", force_quotes: true })
      register_post do
        csv(column_names: false) do
          column :title
          column :body
        end
      end
      Post.create!(title: "012345")

      expect(download_csv).to eq [["012345", ""]]
    end

    it "uses a decorator's methods" do
      register_post do
        decorate_with PostDecorator

        csv do
          column :id
          column :title
          column :decorator_method
        end
      end
      Post.create!(title: "Hello World")

      expect(download_csv).to match [
        ["Id", "Title", "Decorator method"],
        [/\A\d+\z/, "Hello World", "A method only available on the decorator"]
      ]
    end
  end

  describe "application-wide csv_options" do
    before { Post.create!(title: "012345") }

    it "applies humanize_name: false to the default columns" do
      set_application_setting(:csv_options, { humanize_name: false })
      register_post

      # The raw column names. "Foo" humanizes the foo_id column.
      expect(download_csv.first).to eq ["id", "title", "body", "published_date", "position", "starred", "foo_id", "created_at", "updated_at"]
    end

    it "lets a resource turn humanize_name back on" do
      set_application_setting(:csv_options, { humanize_name: false })
      register_post do
        csv(humanize_name: true) do
          column :title
          column :body
        end
      end

      expect(download_csv.first).to eq ["Title", "Body"]
    end

    it "applies a separator" do
      set_application_setting(:csv_options, { col_sep: ";" })
      register_post do
        csv do
          column :title
          column :body
        end
      end

      expect(download_csv(col_sep: ";")).to eq [["Title", "Body"], ["012345", nil]]
    end

    it "applies force_quotes" do
      set_application_setting(:csv_options, { col_sep: ",", force_quotes: true })
      register_post do
        csv do
          column :title
          column :body
        end
      end

      expect(download_csv).to eq [["Title", "Body"], ["012345", ""]]
      expect(response.body).to include('"012345"')
    end
  end

  describe "encoding" do
    before { Post.create!(title: "あいうえお") }

    it "uses the encoding a resource sets" do
      # A non-UTF-8 encoding combined with the default byte order mark fails
      # with an incompatible encoding error, so this clears the default
      # options.
      set_application_setting(:csv_options, {})
      register_post do
        csv(encoding: "SJIS") do
          column :title
          column :body
        end
      end

      get admin_posts_path(format: :csv)

      expect(response.body.encoding).to eq Encoding.find("SJIS")
      expect(response.body.encode("UTF-8")).to include("あいうえお")
    end

    it "uses the encoding set application-wide" do
      set_application_setting(:csv_options, { encoding: "SJIS" })
      register_post do
        csv do
          column :title
          column :body
        end
      end

      get admin_posts_path(format: :csv)

      expect(response.body.encoding).to eq Encoding.find("SJIS")
      expect(response.body.encode("UTF-8")).to include("あいうえお")
    end
  end
end
