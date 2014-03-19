require 'helper'
require 'fakefs/safe'
require_relative '../extensions/fakefs'
require 'fileutils'

class TestDisplay < MiniTest::Test
  def setup
    FakeFS.activate!

    @io = fixture
    FileUtils.mkdir_p(File.dirname(@io))
    FileUtils.touch(@io)

    @display = I2C::Drivers::SS1602::Display.new(@io, 0x42)
  end

  def teardown
    FakeFS.deactivate!
  end

  def test_clear
    @display.clear
    s = File.read(@io).unpack('B*')

    # Not sure why assert_equal chokes if FakeFs is still active
    FakeFS.deactivate!
    assert_equal('42', s)
  end

  def test_text_0
    @display.text('FOOBAR', 0)
    s = File.read(@io).unpack('B*')

    FakeFS.deactivate!
    assert_equal('42', s)
  end
end
