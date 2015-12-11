# encoding: utf-8

require 'ffaker/lorem'

module FFaker
  # Thanks to Snoop Dogg
  module DizzleIpsum
    extend Lorem

    extend ModuleUtils
    extend self

    def word
      DIZZLE_WORDS.sample
    end

    def words(num = 3)
      DIZZLE_WORDS.sample(num)
    end
  end
end
