module SimpleHL7
  class ComponentContainer < Composite
    def self.current_separator_char(separator_chars)
      separator_chars.component
    end

    def self.subcomposite_class
      Component
    end
  end
end
