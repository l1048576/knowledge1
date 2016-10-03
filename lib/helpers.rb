include Nanoc::Helpers::Rendering
include Nanoc::Helpers::LinkTo
#include Nanoc::Helpers::HTMLEscape


module Larry
  module Util
    # https://github.com/nanoc/nanoc/blob/682066c0d31a45ef55dd5804a61d088c29254883/lib/nanoc/helpers/blogging.rb#L239-L253
    def attr_to_time(arg)
      case arg
      when DateTime
        arg.to_time
      when Date
        Time.local(arg.year, arg.month, arg.day)
      when String
        Time.parse(arg)
      else
        arg
      end
    end

    def updated_time(item)
      if attr = item[:updated_at] || item[:created_at]
        attr_to_time(attr)
      else
        0
      end
    end
  end
end

include Larry::Util
