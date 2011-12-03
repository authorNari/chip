require "nokogiri"

module Chip
  class CodeFetcher
    def initialize
      @fetchers = []
      # text/plain
      @fetchers << [/.*/,
                    "text/plain",
                    ->(r){ r.body }]
      # text/html <pre>#chip\n puts 'hello, world!'</pre>
      @fetchers << [/.*/,
                    "text/html",
                    ->(r){ 
                      doc = Nokogiri::HTML::Document.parse(r.body)
                      doc.xpath('//pre').map do |pre|
                        t = pre.text
                        lines = t.split("\n")
                        if lines.first.include?("chip")
                          return t
                        end
                        return false
                      end
                    }]
    end

    def add(url, content_type, &inspector)
      @fetchers.unshift([url, content_type, inspector])
    end

    def fetch(target_url)
      http_get(target_url) do |response|
        @fetchers.each do |url, content_type, inspector|
          if target_url.match(url) && response.content_type.match(content_type)
            if res = inspector.call(response)
              return res
            end
          end
        end
      end
      raise FetchError, "chip don't have a code fetcher for #{target_url}."
    end

    private
    def http_get(url)
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == "https")
      http.start do |h|
        res = http.get(uri.path)
        if res.code != "200"
          raise FetchError, "#{url} response code is #{res.code}"
        end
        return yield res
      end
    end
  end
end
