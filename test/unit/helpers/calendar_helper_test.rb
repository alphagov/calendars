require 'test_helper'

class CalendarHelperTest < ActionView::TestCase

  context "yn_yng_variant" do
    
    should "return the correct variant for a welsh string" do
      assert_equal "yng Nghymru a Lloegr", yn_yng_variant("Cymru a Lloegr")
      assert_equal "yn yr Alban", yn_yng_variant("Yr Alban")
    end

    should "return the string where no variant exists" do
      assert_equal "England and Wales", yn_yng_variant("England and Wales")
    end

  end

end
