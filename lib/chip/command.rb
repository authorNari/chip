require "uri"
require "net/https"
require "fileutils"

module Chip
  class Command
    attr_accessor :config
    attr_writer :force

    class InstallError < StandardError; end
    class HTTPFetchError < InstallError; end

    def initialize
      @config = nil
    end

    def install(url)
      puts "Installing..."
      code = fetch(url)
      fn = install_filepath(url)

      unless @force
        puts "#{fn}"
        puts "---"
        puts code
        puts "---"
        print "Do you install above a program? [yes/no] > "
      end
      
      if @force or ask == "yes"
        File.open(fn, "w"){|f| f.write(code) }
        return
      end
      raise InstallError, "#{url} is not installed."
    end

    def run(url)
      install(url)
      unless @force
        print "Do you run it? [yes/no] > "
      end
      puts "Running..."
      if @force or ask == "yes"
        eval(File.read(install_filepath(url)))
      end
    end

    def list
      puts Dir.entries(install_dir).select{|f| File.extname(f) == ".rb"}
    end

    def help
      puts <<-EOF
chip gem version #{Chip::VERSION}

[commands]
chip help    - show this message

chip install <URL> - install a micro program on Wep page
chip run <URL>     - run a micro program on Wep page

[options]
-h, --help    : show this message
EOF
    end

    def version
      puts Chip::VERSION
    end

    private
    def fetch(url)
      code = ""
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == "https")
      http.start do |h|
        res = http.get(uri.path)
        if res.code != "200"
          raise HTTPFetchError, "#{url} response code is #{res.code}"
        end
        code = res.body
      end
      return code
    end

    def install_dir(dir=nil)
      dir = File.expand_path("~/.chip") if dir.nil?
      if not File.exist?(dir)
        FileUtils.mkdir_p(dir)
        File.chmod(0700, dir)
      end
      return dir
    end

    def install_filepath(url)
      File.join(install_dir, Chip.escape_to_rbfile(url))
    end

    def ask
      line = $stdin.gets
      if line 
        line.strip
      else
        ""
      end
    end
  end
end
