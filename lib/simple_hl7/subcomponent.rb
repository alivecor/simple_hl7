module SimpleHL7
  class Subcomponent < Struct.new(:value)
    def to_hl7(separator_chars)
      value
    end

    def to_s
      value
    end
  end
end
