# encoding: utf-8

require 'helper'

class TestColor < Test::Unit::TestCase
  def test_name
    assert_match /\A[a-z]+\z/, FFaker::Color.name
  end
end
