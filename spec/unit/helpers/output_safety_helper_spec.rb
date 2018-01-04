require 'rails_helper'

# Adapted from Rails 5 to support Rails 4.
# https://github.com/rails/rails/blob/9c35bf2a6a27431c6aa283db781c19f61c5155be/actionview/test/template/output_safety_helper_test.rb
RSpec.describe ActiveAdmin::OutputSafetyHelper, type: :view do
  include described_class

  before do
    @string = "hello"
  end

  describe "to_sentence" do
    it "escapes non-html_safe values" do
      actual = to_sentence(%w(< > & ' "))
      assert actual.html_safe?
      assert_equal("&lt;, &gt;, &amp;, &#39;, and &quot;", actual)

      actual = to_sentence(%w(<script>))
      assert actual.html_safe?
      assert_equal("&lt;script&gt;", actual)
    end

    it "does not double escape if single value is html_safe" do
      assert_equal("&lt;script&gt;", to_sentence([ERB::Util.html_escape("<script>")]))
      assert_equal("&lt;script&gt;", to_sentence(["&lt;script&gt;".html_safe]))
      assert_equal("&amp;lt;script&amp;gt;", to_sentence(["&lt;script&gt;"]))
    end

    it "checks connector words for html safety" do
      assert_equal "one & two, and three", to_sentence(["one", "two", "three"], words_connector: " & ".html_safe)
      assert_equal "one & two", to_sentence(["one", "two"], two_words_connector: " & ".html_safe)
      assert_equal "one, two &lt;script&gt;alert(1)&lt;/script&gt; three", to_sentence(["one", "two", "three"], last_word_connector: " <script>alert(1)</script> ")
    end

    it "does not escape html_safe values" do
      ptag = content_tag("p") do
        safe_join(["<marquee>shady stuff</marquee>", tag("br")])
      end
      url = "https://example.com"
      expected = %(<a href="#{url}">#{url}</a> and <p>&lt;marquee&gt;shady stuff&lt;/marquee&gt;<br /></p>)
      actual = to_sentence([link_to(url, url), ptag])
      assert actual.html_safe?
      assert_equal(expected, actual)
    end

    it "handles blank strings" do
      actual = to_sentence(["", "two", "three"])
      assert actual.html_safe?
      assert_equal ", two, and three", actual
    end

    it "handles nil values" do
      actual = to_sentence([nil, "two", "three"])
      assert actual.html_safe?
      assert_equal ", two, and three", actual
    end

    it "still supports ActiveSupports Array#to_sentence arguments" do
      assert_equal "one two, and three", to_sentence(["one", "two", "three"], words_connector: " ")
      assert_equal "one & two, and three", to_sentence(["one", "two", "three"], words_connector: " & ".html_safe)
      assert_equal "onetwo, and three", to_sentence(["one", "two", "three"], words_connector: nil)
      assert_equal "one, two, and also three", to_sentence(["one", "two", "three"], last_word_connector: ", and also ")
      assert_equal "one, twothree", to_sentence(["one", "two", "three"], last_word_connector: nil)
      assert_equal "one, two three", to_sentence(["one", "two", "three"], last_word_connector: " ")
      assert_equal "one, two and three", to_sentence(["one", "two", "three"], last_word_connector: " and ")
    end

    it "is not affected by $," do
      separator_was = $,
      $, = "|"
      begin
        assert_equal "one and two", to_sentence(["one", "two"])
        assert_equal "one, two, and three", to_sentence(["one", "two", "three"])
      ensure
        $, = separator_was
      end
    end
  end
end
