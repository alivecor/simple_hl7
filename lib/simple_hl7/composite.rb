module SimpleHL7
  class Composite
    def initialize(value = nil)
      @subcomposites = {}
      cls = self.class
      unless value.nil?
        @subcomposites[cls.start_index] = cls.subcomposite_class.new(value)
      end
    end

    def []=(index, value)
      @subcomposites[index] = self.class.subcomposite_class.new(value)
    end

    def [](index)
      subcomposite = @subcomposites[index]
      if subcomposite.nil?
        subcomposite = self.class.subcomposite_class.new
        set_subcomposite(index, subcomposite)
      end
      subcomposite
    end

    def set_subcomposite(index, value)
      @subcomposites[index] = value
    end

    def each
      start = self.class.start_index
      (start..max_index).each { |i| yield @subcomposites[i] } if max_index
    end

    def map
      start = self.class.start_index
      (start..max_index).map { |i| yield @subcomposites[i] } if max_index
    end

    def to_hl7(separator_chars)
      sep_char = self.class.current_separator_char(separator_chars)
      map { |subc| subc.to_hl7(separator_chars) if subc }.join(sep_char)
    end

    def to_s
      @subcomposites[self.class.start_index].to_s
    end

    def to_a
      a = []
      each {|subc| a << subc}
      a
    end

    def self.start_index
      1
    end

    def self.current_separator_char(separator_chars)
      raise Exception.new("Subclass Responsibility")
    end

    def self.subcomposite_class
      raise Exception.new("Subclass Responsibility")
    end

    def self.parse(str, separator_chars)
      composite = new
      parse_subcomposite_hash(str, separator_chars).each do |index, subc|
        composite.set_subcomposite(start_index + index, subc)
      end
      composite
    end

    def self.parse_subcomposite_hash(str, separator_chars)
      subc_strs = str.split(current_separator_char(separator_chars))
      subc_h = {}
      subc_strs.each_with_index do |subc_str, index|
        unless subc_str.empty?
          subc_h[index] = subcomposite_class.parse(subc_str, separator_chars)
        end
      end
      subc_h
    end

    private

    def max_index
      @subcomposites.keys.max
    end

  end
end
