class TestCommand < Test::Unit::TestCase
  TEST_URL = "http://test.com"
  INSTALL_DIR = File.expand_path("~/.chip.d/")

  def setup
    @command = Chip::Command.new

    # Capture outputs by stubbing puts
    @stdout_values = []
    stub(@command).puts{|s| @stdout_values << s }
    stub(@command).print{|s| @stdout_values << s }
  end

  def test_install
    any_instance_of(Chip::CodeFetcher) do |cf|
      mock(cf).fetch(TEST_URL){ "puts 'Hi'"}
    end
    any_instance_of(File) do |f|
      mock(f).write("puts 'Hi'")
    end
    mock(@command).ask{ "yes"}

    @command.install(TEST_URL)

    assert_not_empty @stdout_values
  end

  def test_install_with_force
    any_instance_of(Chip::CodeFetcher) do |cf|
      mock(cf).fetch(TEST_URL){ "puts 'Hi'"}
    end
    any_instance_of(File) do |f|
      mock(f).write("puts 'Hi'")
    end
    dont_allow(@command).ask{ "yes"}

    @command.force = true
    @command.install(TEST_URL)

    assert_equal ["Installing..."], @stdout_values
  end

  def test_run
    mock(@command).install(TEST_URL)
    mock(@command).ask{ "yes"}
    mock(File).read("#{INSTALL_DIR}/http:__test.com.rb"){ "puts 'Hi'"}

    @command.run(TEST_URL)

    assert_equal "Hi", @stdout_values.last
  end

  def test_run_with_force
    mock(@command).install(TEST_URL)
    dont_allow(@command).ask{ "yes"}
    mock(File).read("#{INSTALL_DIR}/http:__test.com.rb"){ "puts 'Hi'"}

    @command.force = true
    @command.run(TEST_URL)

    assert_equal ["Running...", "Hi"], @stdout_values
  end

  def test_list
    mock(Dir).entries(INSTALL_DIR){ [".", "..", "test.rb"] }

    @command.list

    assert_equal [["test.rb"]], @stdout_values
  end
end
