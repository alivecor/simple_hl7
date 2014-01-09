module SimpleHL7
  class Segment < Composite
    attr_reader :name

    def initialize(name)
      super()
      @name = name.upcase
    end

    def subcomposite_class
      Field
    end

    def current_separator_char(separator_chars)
      separator_chars.field
    end

    def to_a
      super.insert(0, name)
    end

    def to_hl7(separator_chars)
      sep_char = current_separator_char(separator_chars)
      [@name, super].join(sep_char)
    end
  end
end
