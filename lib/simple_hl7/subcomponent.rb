module SimpleHL7
  class Subcomponent
    attr_accessor :value

    def initialize(value)
      @value = value.nil? ? '' : value
    end

    def to_hl7(separator_chars)
      hl7 = value
      if hl7.respond_to? :gsub!
        hl7.gsub!(separator_chars.escape, "\\E\\")
        hl7.gsub!(separator_chars.field, "\\F\\")
        hl7.gsub!(separator_chars.repetition, "\\R\\")
        hl7.gsub!(separator_chars.component, "\\S\\")
        hl7.gsub!(separator_chars.subcomponent, "\\T\\")
      end
      hl7
    rescue => e
      raise e, "Encountered exception building message: #{e}", e.backtrace
    end

    def to_s
      value
    end

    def self.parse(str, separator_chars)
      value = str
      if value.respond_to? :gsub!
        value.gsub!("\\E\\", separator_chars.escape)
        value.gsub!("\\F\\", separator_chars.field)
        value.gsub!("\\R\\", separator_chars.repetition)
        value.gsub!("\\S\\", separator_chars.component)
        value.gsub!("\\T\\", separator_chars.subcomponent)
      end
      Subcomponent.new(value)
    rescue => e
      raise e, "Encountered exception parsing message: #{e}", e.backtrace
    end
  end
end
