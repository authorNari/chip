module Kernel
  def require_chip(url)
    c = Chip::Command.new
    fname = c.send(:install_filepath, url)
    c.install(url) if not File.exist?(fname)
    require fname
  end
end
