# encoding: utf-8

module FFaker
  module Identification
    extend ModuleUtils
    extend self

    ETHNICITIES = ['African American', 'Asian/Pacific Islander', 'Caucasian', 'Hispanic', 'Native American', 'Multiracial', 'Other', 'Prefer not to respond']
    GENDERS = %w(Male Female)

    def drivers_license
      FFaker.bothify('?###-###-##-###-#').upcase
    end

    def ssn
      FFaker.numerify('###-##-####')
    end

    def ethnicity
      ETHNICITIES.sample
    end

    def gender
      GENDERS.sample
    end
  end
end
