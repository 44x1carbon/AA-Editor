require 'curses'

class CmdWin
  def init(wind)
    @window = wind.subwin(3,wind.maxx,wind.maxy - 3,0)
  end

  def display()
    Curses::curs_set(1)
    Curses.echo
    @window.box('|','-')
    @window.refresh
  end

  def getstr()
    @window.setpos(1,1)
    display
    while cmd = Curses.getstr do
        case cmd
        when ":e"
        when ":c"
        when ":w"
        when ":wq"
        end
    end
  end

end
