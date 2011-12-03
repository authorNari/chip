require "uri"
require "net/https"

module Chip
  class Command
    attr_writer :force

    def install(url)
      puts "Installing..."
      code = ::Chip.fetcher.fetch(url)
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
      if @force or ask == "yes"
        puts "Running..."
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
    def install_dir(dir=nil)
      dir = File.expand_path("~/.chip.d") if dir.nil?
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
