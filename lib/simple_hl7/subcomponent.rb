module SimpleHL7
  class Subcomponent < Struct.new(:value)
    def to_hl7(separator_chars)
      hl7 = value
      hl7.gsub!(separator_chars.escape, "\\E\\")
      hl7.gsub!(separator_chars.field, "\\F\\")
      hl7.gsub!(separator_chars.repetition, "\\R\\")
      hl7.gsub!(separator_chars.component, "\\S\\")
      hl7.gsub!(separator_chars.subcomponent, "\\T\\")
      hl7
    end

    def to_s
      value
    end
  end
end
