module Chip
  class InstallError < StandardError; end
  class FetchError < InstallError; end

  def self.setup
    config = File.expand_path("~/.chip")
    if not File.exist?(config)
      FileUtils.touch(config)
      File.chmod(0600, config)
    end
    eval(File.read(config))
  end

  def self.fetcher
    @fetcher ||= CodeFetcher.new
  end

  def self.escape_to_rbfile(url)
    n = url.gsub("/", "_")
    if not File.extname(n) == ".rb"
      n << ".rb"
    end
    return n
  end

  def self.chip_filepath(url)
    escape_to_rbfile(url)
  end
end

require 'optparse'
require "fileutils"
require_relative "chip/version"
require_relative "chip/code_fetcher"
require_relative "chip/command"
require_relative "chip/cli"
require_relative "chip/core_ext_kernel"

Chip.setup
