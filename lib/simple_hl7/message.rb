module SimpleHL7
  class Message
    # Constructor
    # @param options [Hash] Options for the Message, keys are symbols, accepted
    #   values are:
    #   default_msh [boolean] True to create a default MSH segment, false
    #     to create the message with no segments. Defaults to true.
    #   segment_separator [String] The string to place between segments when
    #     generating HL7, defaults to "\r".
    def initialize(options = nil)
      default_opts = {default_msh: true, segment_separator: "\r"}
      opts = default_opts.merge(options || {})
      @segment_separator = opts[:segment_separator]
      @segments = []
      @segments << MSHSegment.new if opts[:default_msh]
    end

    def method_missing(meth, *args, &block)
      if meth.to_s =~ /^[a-zA-Z][a-zA-Z0-9]{2}$/
        get_named_segment(meth)
      elsif meth.to_s =~ /^[a-zA-Z][a-zA-Z0-9]{2}_all$/
        seg_name = meth[0..3]
        all_segments(seg_name)
      else
        super
      end
    end

    # Generate a HL7 string from this message
    #
    # @return [String] The generated HL7 string
    def to_hl7
      separator_chars = get_named_segment('MSH').separator_chars
      @segments.map {|s| s.to_hl7(separator_chars)}.join(@segment_separator)
    end

    # Generate a LLP string from this message
    # Commonly used for transmitting HL7 messages via TCP/IP
    #
    # @return [String] The generated LLP string
    def to_llp
      "\x0b#{to_hl7}\x1c\r"
    end

    # Get an array representation of the HL7 message. This can be useful
    # to help debug problems.
    #
    # @return [Array] The HL7 message as an array where each subcomposites is
    #   also represented as an array.
    def to_a
      @segments.reduce([]) {|a, s| a << s.to_a}
    end

    # Get the specified segment
    #
    # @param name [String] The 3 letter segment name, case insensitive
    # @param index [Integer] The segment number to get if there are multiple
    #   in the message. This index starts at 1 because that's what most HL7
    #   specs do.
    def segment(name, index=1)
      all = all_segments(name)
      seg = nil
      seg = all[index - 1] if all.size >= index
      seg
    end

    # Add a segment to the message
    #
    # @param name [String] The 3 letter segment name, case insensitive.
    # @return [Segment] The segment that was just created
    def add_segment(name)
      segment = Segment.new(name)
      @segments << segment
      segment
    end

    # Appends a segment to the message
    #
    # @param segment [Segment] The segment to append.
    # @return [Segment] The segment just appended
    def append_segment(segment)
      @segments << segment
      segment
    end

    private

    def all_segments(name)
      @segments.select {|seg| seg.name == name}
    end


    def get_named_segment(name)
      name_str = name.to_s.upcase
      segment = @segments.select {|seg| seg.name == name_str}.first
      unless segment
        segment = Segment.new(name_str)
        @segments << segment
      end
      segment
    end

    # Parses a HL7 string into a Message
    #
    # @param str [String] The string to parse.
    # @param options [Hash] Options for parsing, keys are symbols, accepted
    #   values:
    #   segment_separator [String] The string to place between segments when
    #     generating HL7, defaults to "\r".
    # @return [Message] The parsed HL7 Message
    def self.parse(str, options = nil)
      str.strip!
      default_opts = {default_msh: true, segment_separator: "\r"}
      opts = default_opts.merge(options || {})
      msg = new(default_msh: false)
      segment_strs = str.split(opts[:segment_separator])
      msh = MSHSegment.parse(segment_strs[0])
      msg.append_segment(msh)
      segment_strs[1, segment_strs.length].each do |seg_str|
        msg.append_segment(Segment.parse(seg_str, msh.separator_chars))
      end
      msg
    end

    # Parses a HL7 LLP (Lower Layer Protocol) string into a Message
    #
    # @param str [String] The llp string to parse.
    # @param options [Hash] Options for parsing, keys are symbols, accepted
    #   values:
    #   segment_separator [String] The string to place between segments when
    #     generating HL7, defaults to "\r".
    # @return [Message] The parsed HL7 Message
    def self.parse_llp(str, options = nil)
      if llp = str.match(/\x0b(.*)\x1c\r/)
        parse(llp.captures.first, options)
      else
        raise ArgumentError, "Invalid LLP message, header and trailer were expected."
      end
    end
  end
end
