module SimpleHL7
  # Generic building block of a HL7 message. The parts of the message
  # subclass this, and this class does most of the work.
  class Composite
    # Constructor
    #
    # @param value [String] a value that is passed down to the subclass
    #   constructor. This allows us to set values on top level components that
    #   are passed down to the lowest component. Default nil.
    def initialize(value = nil)
      @subcomposites = {}
      cls = self.class
      unless value.nil?
        @subcomposites[cls.start_index] = cls.subcomposite_class.new(value)
      end
    end

    # Set the value of the specified subcomposite.
    # The value is actually passed down to the first subcomposite of the
    # specified subcomposite and so on until it reaches a Subcomponent
    # composite.
    #
    # @param index [Integer] the subcomposite index.
    # @param value [String] the value to set.
    def []=(index, value)
      set_subcomposite(index, self.class.subcomposite_class.new(value))
    end

    # Get a specific subcomposite.
    #
    # @param index [Integer] The index of the subcomposite.
    # @return [Subcomposite] The subcomposite at index or a new subcomposite
    #   if none exists. Note that this returns the Subcomposite object and not
    #   the string value. This differs from how []= works, but it seems to make
    #   the most sense when dealing with HL7 messages.
    def [](index)
      get_subcomposite(index)
    end

    # Alias for []
    def get_subcomposite(index)
      subcomposite = @subcomposites[index]
      if subcomposite.nil?
        subcomposite = self.class.subcomposite_class.new
        set_subcomposite(index, subcomposite)
      end
      subcomposite
    end

    # Sets a specific subcomposite
    #
    # @param index [Integer] the indexs of the subcomposite, if there is an
    #   existing compsite at the location it is replaced.
    # @param value [Subcomposite] the new subcomposite object for the
    #   specified location.
    def set_subcomposite(index, value)
      @subcomposites[index] = value
    end

    # Calls the specified block once for each index between the start index
    # and the max specified subcomposite index.
    #
    # @yeild [subcomposite] Gives the subcomposite at the current index to the
    #   block. If there isn't a subcomposite specified for the index then nil
    #   is passed.
    def each
      start = self.class.start_index
      (start..max_index).each { |i| yield @subcomposites[i] } if max_index
    end

    # Calls the specified block once for each index between the start index
    # and the max specified subcomposite index and returns an array resulting
    # from the return values of each block.
    #
    # @yeild [subcomposite] Gives the subcomposite at the current index to the
    #   block. If there isn't a subcomposite specified for the index then nil
    #   is passed.
    def map
      start = self.class.start_index
      (start..max_index).map { |i| yield @subcomposites[i] } if max_index
    end

    # Get a HL7 string representation of this Composite.
    #
    # @separator_chars [SeparatorChars] The separator characters to be used
    #   when converting this Composite to a string of HL7.
    def to_hl7(separator_chars)
      sep_char = self.class.current_separator_char(separator_chars)
      map { |subc| subc.to_hl7(separator_chars) if subc }.join(sep_char)
    end

    # Get the value stored at the first Subcomponent below this Composite
    def to_s
      @subcomposites[self.class.start_index].to_s
    end

    # Get all the subcomposites as an array. Note that this array has the
    # actual subcomposite object and not clones, so any changes will affect
    # this class as well.
    def to_a
      a = []
      each {|subc| a << subc}
      a
    end

    # The index where the first subcomposite is located. This is usually either
    # 1 or 0 depending on the specific Composite.
    def self.start_index
      1
    end

    # @abstract The character that is used to separate the subcomposites when
    # generating a HL7 string.
    #
    # @param separator_chars [SeparatorChars] The separator characters in use
    #   during the HL7 string conversion.
    def self.current_separator_char(separator_chars)
      raise Exception.new("Subclass Responsibility")
    end

    # @abstract The class that is used for subcomposites.
    def self.subcomposite_class
      raise Exception.new("Subclass Responsibility")
    end

    # Create a composite from a HL7 string.
    #
    # @param str [String] The string of HL7.
    # @param separator_chars [SeparatorChars] The separator characters used
    #   in the HL7 string.
    # @return [Composite] The parsed composite.
    def self.parse(str, separator_chars)
      composite = new
      parse_subcomposite_hash(str, separator_chars).each do |index, subc|
        composite.set_subcomposite(start_index + index, subc)
      end
      composite
    end

    private

    def max_index
      @subcomposites.keys.max
    end

    class << self
      private

      # Parses the subcomposites of a HL7 string into a hash
      #
      # @param str [String] The HL7 string to parse.
      # @param separator_chars [SeparatorChars] The separator characters used in
      #   the HL7 string.
      # @return A hash of composites, one for each subcomposite in the string
      #   that actually had a value. Empty subcomposites are left out of the
      #   hash.
      def parse_subcomposite_hash(str, separator_chars)
        subc_strs = str.split(current_separator_char(separator_chars))
        subc_h = {}
        subc_strs.each_with_index do |subc_str, index|
          unless subc_str.empty?
            subc_h[index] = subcomposite_class.parse(subc_str, separator_chars)
          end
        end
        subc_h
      end
    end

  end
end
