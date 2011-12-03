class TestCli < Test::Unit::TestCase
  def setup
    @cli = Chip::CLI.new
    @command = @cli.command
  end

  def test_run
    mock(@command).install("http://test.com/")

    @cli.run(["install", "http://test.com/"])
  end

  def test_run_no_args
    mock(@command).help

    @cli.run([])
  end
end
