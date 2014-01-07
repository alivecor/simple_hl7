module SimpleHL7
  class Component < Composite
    def current_separator_char(separator_chars)
      separator_chars.subcomponent
    end

    def subcomposite_class
      Subcomponent
    end
  end
end
