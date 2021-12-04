module SimpleHL7
  class Segment < Composite
    def self.start_index
      0
    end

    def self.subcomposite_class
      Field
    end

    def self.current_separator_char(separator_chars)
      separator_chars.field
    end

    def initialize(name = nil)
      if name
        super(name.upcase)
      else
        super
      end
    end

    def name
      self[0].to_s
    end

    def to_a
      super.insert(0, name)
    end

    def empty?
      @subcomposites.keys.size == 1
    end
  end
end
