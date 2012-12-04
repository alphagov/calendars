module CalendarHelper

  # Welsh translation may vary depending on the combination of article and noun.
  # This particular method deals with words combining the words 'in' and country names.
  #
  def yn_yng_variant(str)
    case str
    when "Cymru a Lloegr" then "yng Nghymru a Lloegr"
    when "Yr Alban" then "yn yr Alban"
    when "Gogledd Iwerddon" then "yng Ngogledd Iwerddon"
    else str
    end
  end
  
end
