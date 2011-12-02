module Chip
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
require_relative "chip/version"
require_relative "chip/command"
require_relative "chip/cli"
require_relative "chip/core_ext_kernel"
