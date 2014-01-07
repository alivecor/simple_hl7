module SimpleHL7
  class SeparatorCharacters < Struct.new(:field, :component, :repetition,
                                         :escape, :subcomponent)
    def self.defaults
      SeparatorCharacters.new('|', '^', '~', '\\', '&')
    end
  end
end
