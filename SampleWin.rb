require 'curses'

ColorsNum = 8

class SampleWin
  def init(parent)
    @ColorPicker = parent
    @parentWin = @ColorPicker.thisWin
    @thisWin = @parentWin.subwin(4,10,@y,@x)
  end

  def display()
    @thisWin.clear

    @thisWin.box('|','-')
    text = "Sample"
    @thisWin.setpos(1,@thisWin.maxx/2 - text.length/2)
    @thisWin.addstr(text)
    @thisWin.setpos(2,@thisWin.maxx/2 - 1)
    pairNum = @ColorPicker.BackWin.getColor * ColorsNum + @ColorPicker.FontWin.getColor
    @thisWin.attron(Curses::color_pair(pairNum)){
      @thisWin.addstr("A")
    }
    @thisWin.attroff(Curses::color_pair(pairNum))
    @thisWin.refresh
  end

  def setYX(y,x)
    @y = y
    @x = x
  end

end
