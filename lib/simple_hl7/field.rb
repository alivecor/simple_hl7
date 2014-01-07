module SimpleHL7
  class Field < Composite
    def current_separator_char(separator_chars)
      separator_chars.repetition
    end

    def subcomposite_class
      ComponentContainer
    end
  end
end
