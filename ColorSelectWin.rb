require 'curses'
require_relative './ColorsWin'


class ColorSelectWin
  def init(parent,text)
    @text = text + ':'
    @ColorPicker = parent
    @parentWin = @ColorPicker.thisWin
    @thisWin = @parentWin.subwin(10,12,@y,@x)
    @ColorViewWin = @thisWin.subwin(3,10,@y,@x)
    @ColorsWin = ColorsWin.new
    @ColorsWin.setYX(@y,@x + @text.length + 1)
    @ColorsWin.init(self)

  end

  def display()
    Curses::curs_set(0)
    @thisWin.clear
    @ColorViewWin.box('|','-')
    @ColorViewWin.setpos(1,1)
    @ColorViewWin.addstr(@text)
    color = @ColorsWin.getSelectColor
    @ColorViewWin.attron(Curses::color_pair(color)){
      @ColorViewWin.addstr("AAA")
    }
    @ColorViewWin.attroff(Curses::color_pair(color))
    #@ColorsWin.display
    @thisWin.refresh
  end

  def setYX(y,x)
    @y = y
    @x = x
  end

  def getColor()
    return @ColorsWin.getSelectColor - PICKNUM
  end



  attr_accessor :thisWin ,:ColorPicker,:ColorsWin
end
