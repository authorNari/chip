# -*- coding: utf-8 -*-
require "fakeweb"

class TestCodeFetcher < Test::Unit::TestCase
  def setup
    @fetcher = Chip::CodeFetcher.new
  end

  def test_fetch_with_plain
    FakeWeb.register_uri(:get, "http://test.com/a.rb",
                         body: "puts 'Hi'", content_type: "text/plain")

    assert_equal "puts 'Hi'", @fetcher.fetch("http://test.com/a.rb")
  end

  def test_fetch_with_html
    FakeWeb.register_uri(:get, "http://test.com/a.rb",
                         body: "<pre>\n\n#chip\nputs 'Hi'</pre>",
                         content_type: "text/html")

    assert_equal "\n\n#chip\nputs 'Hi'", @fetcher.fetch("http://test.com/a.rb")
  end

  def test_add
    assert_equal 2, @fetcher.fetchers.size
    @fetcher.add("test_url", "text/plain"){}

    assert_equal 3, @fetcher.fetchers.size
    assert_equal "test_url", @fetcher.fetchers.first.first
  end
end
