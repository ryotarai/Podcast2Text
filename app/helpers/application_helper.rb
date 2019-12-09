module ApplicationHelper
  def format_seconds(s)
    t = ""
    h = s / (60*60)
    if h > 0
      t << "#{h}h"
    end
    s = s % (60*60)
    m = s / 60
    if m > 0
      t << "#{m}m"
    end
    s = s % 60
    t << "#{s}s"

    return t
  end
end
