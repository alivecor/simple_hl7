module SimpleHL7
  class MSHSegment < Segment
    def initialize
      super('MSH')
      self[1] = '|'
      self[2] = '^~\&'
    end

    def separator_chars
      enc_chars = @subcomposites[2].to_s
      SeparatorCharacters.new(@subcomposites[1].to_s,
                              enc_chars[0],
                              enc_chars[1],
                              enc_chars[2],
                              enc_chars[3])
    end

    def self.parse(str)
      msh = new
      msh[1] = str[3]
      msh[2] = str[4..7]

      fields = parse_subcomposite_hash(str[9, str.length], msh.separator_chars)
      fields.each { |index, subc| msh.set_subcomposite(index + 3, subc) }
      msh
    end

    def to_hl7(separator_chars)
      sep_char = self.class.current_separator_char(separator_chars)
      base_msh = "#{name}#{self[1]}#{self[2]}"
      max_index = @subcomposites.keys.max
      rest_msh = (3..max_index).map { |i|
        @subcomposites[i].to_hl7(separator_chars) if @subcomposites[i]
      }.join(sep_char)
      [base_msh, rest_msh].join(sep_char)
    end
  end
end
