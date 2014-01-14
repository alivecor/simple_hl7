module SimpleHL7
  class Field < Composite
    def self.current_separator_char(separator_chars)
      separator_chars.repetition
    end

    def self.subcomposite_class
      ComponentContainer
    end

    def []=(index, value)
      get_subcomposite(1)[index] = value
    end

    def [](index)
      get_subcomposite(1)[index]
    end

    def r(index)
      get_subcomposite(index)
    end
  end
end
