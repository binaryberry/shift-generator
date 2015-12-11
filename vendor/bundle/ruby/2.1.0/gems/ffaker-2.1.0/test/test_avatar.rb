require 'helper'

class TestAvatar < Test::Unit::TestCase
  def setup
    @tester = FFaker::Avatar
  end

  def test_avatar
    assert_match(/\Ahttp:\/\/robohash\.org\/.+\.png\?size=300x300\z/,
                 @tester.image)
  end

  def test_avatar_with_param
    assert_equal('http://robohash.org/faker.png?size=300x300',
                 @tester.image('faker'))
  end

  def test_avatar_with_correct_size
    assert_equal('http://robohash.org/faker.png?size=150x320',
                 @tester.image('faker', '150x320'))
  end

  def test_avatar_with_incorrect_size
    assert_raise ArgumentError do
      @tester.image(nil, '150x320z')
    end
  end

  def test_avatar_with_supported_format
    assert_equal('http://robohash.org/faker.jpg?size=300x300',
                 @tester.image('faker', '300x300', 'jpg'))
  end

  def test_avatar_with_incorrect_format
    assert_raise ArgumentError do
      @tester.image(nil, '300x300', 'wrong_format')
    end
  end

  def test_avatar_with_correct_background
    assert_equal('http://robohash.org/faker.png?size=300x300&bgset=bg1',
                 @tester.image('faker', '300x300', 'png', '1'))
  end

  def test_avatar_with_incorrect_background
    assert_raise ArgumentError do
      @tester.image('faker', '300x300', 'png', 'not_a_number')
    end
  end
end
