module SimpleHL7
  class Field < Composite
    def self.current_separator_char(separator_chars)
      separator_chars.repetition
    end

    def self.subcomposite_class
      ComponentContainer
    end
  end
end
