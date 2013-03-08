module EmailAddress
  unless defined?(VALID_PATTERN)
    # RFC 2822 token definitions for valid email
    SP = "\\!\\#\\$\\%\\&\\'\\*\\+\\-\\/\\=\\?\\^\\_\\`\\{\\|\\}\\~";
    ATEXT = "[a-zA-Z0-9" + SP + "]"
    ATOM = ATEXT + "+" #one or more atext chars
    DOTATOM = "\\." + ATOM
    LOCALPART = ATOM + "(" + DOTATOM + ")*" #one atom followed by 0 or more dotAtoms.

    #RFC 1035 tokens for domain names:
    LETTER = "[a-zA-Z]"
    LETDIG = "[a-zA-Z0-9]"
    LETDIGHYP = "[a-zA-Z0-9-]"
    RFCLABEL = LETDIG + "(" + LETDIGHYP + "{0,61}" + LETDIG + ")?";
    DOMAIN = RFCLABEL + "(\\." + RFCLABEL + ")*\\." + LETTER + "{2,6}";
    #Combined together, these form the allowed email regexp allowed by RFC 2822:
    ADDRSPEC = "^" + LOCALPART + "@" + DOMAIN + "$"
    VALID_PATTERN = Regexp.new(ADDRSPEC)
  end
end
