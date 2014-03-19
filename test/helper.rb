require 'minitest/autorun'
require_relative '../lib/i2c/drivers/ss1602'

class MiniTest::Test
  def initialize(name = nil)
    @test_name = name
    super(name) unless name.nil?
  end

  def fixture(name = @test_name)
    File.join(File.dirname(__FILE__), 'fixtures', name)
  end
end
