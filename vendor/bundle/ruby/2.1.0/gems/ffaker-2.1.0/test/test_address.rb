# encoding: utf-8

require 'helper'

class TestAddress < Test::Unit::TestCase
  def test_building_number
    assert_match /\A\d{3,5}\z/, FFaker::Address.building_number
  end

  def test_city
    assert_match /[ a-z]+/, FFaker::Address.city
  end

  def test_city_prefix
    assert_match /[ a-z]/, FFaker::Address.city_prefix
  end

  def test_city_suffix
    assert_match /[ a-z]/, FFaker::Address.city_suffix
  end

  def test_secondary_address
    assert_match /[ a-z]/, FFaker::Address.secondary_address
  end

  def test_street_address
    assert_match /[ a-z]/, FFaker::Address.street_address
  end

  def test_street_name
    assert_match /[ a-z]/, FFaker::Address.street_name
  end

  def test_street_suffix
    assert_match /[ a-z]/, FFaker::Address.street_suffix
  end

  def test_uk_country
    assert_match /[ a-z]/, FFaker::AddressUK.country
  end

  def test_uk_county
    assert_match /[ a-z]/, FFaker::AddressUK.county
  end

  def test_uk_postcode
    assert_match /[ a-z]/, FFaker::AddressUK.postcode
  end

  def test_us_state
    assert_match /[ a-z]/, FFaker::AddressUS.state
  end

  def test_us_state_abbr
    assert_match /[A-Z]/, FFaker::AddressUS.state_abbr
  end

  def test_zip_code
    assert_match /[0-9]/, FFaker::AddressUS.zip_code
  end

  def test_zip_code_frozen
    assert FFaker::AddressUS.zip_code.frozen? == false
  end

  def test_neighborhood
    assert_match /[ a-z]+/, FFaker::Address::neighborhood
  end

  def test_country
    assert_match /[ a-z]+/, FFaker::Address::country
  end

  def test_country_by_county_code
    assert_match 'Ukraine', FFaker::Address::country('UA')
  end

  def test_country_code
    assert_match /[A-Z]{2}/, FFaker::Address::country_code
  end

  def test_country_code_of_particular_country
    assert_match 'UA', FFaker::Address::country_code('Ukraine')
    assert_match /[A-Z]{2}/, FFaker::Address::country_code('Foo')
  end
end
