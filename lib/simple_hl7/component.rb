module SimpleHL7
  class Component < Composite
    def self.current_separator_char(separator_chars)
      separator_chars.subcomponent
    end

    def self.subcomposite_class
      Subcomponent
    end
  end
end
