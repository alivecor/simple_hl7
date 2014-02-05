module SimpleHL7
  class Subcomponent
    attr_accessor :value

    def initialize(value)
      @value = value.nil? ? '' : value
    end

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

    def self.parse(str, separator_chars)
      value = str
      value.gsub!("\\E\\", separator_chars.escape)
      value.gsub!("\\F\\", separator_chars.field)
      value.gsub!("\\R\\", separator_chars.repetition)
      value.gsub!("\\S\\", separator_chars.component)
      value.gsub!("\\T\\", separator_chars.subcomponent)
      Subcomponent.new(value)
    end
  end
end
