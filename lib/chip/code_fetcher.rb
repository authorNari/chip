require "nokogiri"

module Chip
  class CodeFetcher
    def initialize
      @fetchers = []
      # text/plain
      @fetchers << [/.*/,
                    "text/plain",
                    ->(opts){ opts[:response].body }]
      # text/html <pre>#chip\n puts 'hello, world!'</pre>
      @fetchers << [/.*/,
                    "text/html",
                    ->(opts){ 
                      doc = Nokogiri::HTML::Document.parse(opts[:response].body)
                      doc.xpath('//pre').map do |pre|
                        t = pre.text
                        lines = t.split("\n")
                        lines.each do |l|
                          if l != nil
                            l = l.gsub(" ", "")
                            if !l.empty?
                              return t if l.include?("#chip")
                              break
                            end
                          end
                        end
                      end
                      return false
                    }]
    end
    attr_reader :fetchers

    def add(url, content_type, &inspector)
      @fetchers.unshift([url, content_type, inspector])
    end

    def fetch(target_url)
      response = http_get(target_url)
      @fetchers.each do |url, content_type, inspector|
        if target_url.match(url) && response.content_type.match(content_type)
          if res = inspector.call(response: response,
                                  url: target_url)
            return res
          end
        end
      end
      raise FetchError, "chip don't have a code fetcher for #{target_url}."
    end

    private
    def http_get(url, limit=10)
      raise FetchError, 'http redirect too deep' if limit == 0
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == "https")
      res = http.start{|h| h.get(uri.path)}
      case res
      when Net::HTTPSuccess
        return res
      when Net::HTTPRedirection
        return http_get(res['Location'], limit - 1)
      else
        raise FetchError, "#{url} response code is #{res.code}"
      end
    end
  end
end
