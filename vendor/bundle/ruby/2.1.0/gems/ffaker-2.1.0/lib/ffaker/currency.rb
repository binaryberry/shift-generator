# encoding: utf-8

module FFaker
  module Currency
    extend ModuleUtils
    extend self

    def code
      CURRENCY_CODE.sample
    end

    def name
      CURRENCY_NAME.sample
    end
  end
end
