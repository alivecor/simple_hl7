module SimpleHL7
  class ComponentContainer < Composite
    def current_separator_char(separator_chars)
      separator_chars.component
    end

    def subcomposite_class
      Component
    end
  end
end
