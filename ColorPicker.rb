require 'curses'
require_relative './SampleWin'
require_relative './ColorSelectWin'

class ColorPicker
  def init(parent)
    initColor
    @MainWin = parent
    @parentWin = @MainWin.thisWin
    @thisWin = @parentWin.subwin(@parentWin.maxy - 2,15,0,0)

    @SampleWin = SampleWin.new
    @SampleWin.setYX(1,2)
    @SampleWin.init(self)

    @BackWin = ColorSelectWin.new
    @BackWin.setYX(5,2)
    @BackWin.init(self,"Back")

    @FontWin = ColorSelectWin.new
    @FontWin.setYX(8,2)
    @FontWin.init(self,"Font")

    @select = nil
  end

  def display()
    @thisWin.clear
    @thisWin.box('|','-')
    @SampleWin.display
    @BackWin.display
    @FontWin.display
    dispArrow
    @thisWin.refresh
  end

  def select()
    case @select
      when @BackWin
        @select = @FontWin

      when @FontWin,nil
        @select = @BackWin
    end
  end

  def dispArrow()
    case @select
    when @BackWin
        @thisWin.setpos(6,1)
        @thisWin.addstr(">")
      when @FontWin
        @thisWin.setpos(9,1)
        @thisWin.addstr(">")
      when nil
    end
  end

  def initColor()
    colorsNum = 8
		colorsNum.times.with_index{|i|
			colorsNum.times.with_index{|j|
				Curses::init_pair(i * colorsNum + j,j,i)
			}
		}
	end

  def getKey()
    if @select == nil then
      select
      display
    end
    Curses::curs_set(0)
    key = @parentWin.getch
    case key
      when Curses::Key::UP,Curses::Key::DOWN
        select()
        display
      when 10
        @select.ColorsWin.display
        KeyManager.instance.setTarget(@select.ColorsWin)
      when 27
        @thisWin.clear
        display
        KeyManager.instance.setTarget(@MainWin.ComandWin)

    end
  end

  def getColor()
    return {:back => @BackWin.getColor,:font => @FontWin.getColor}
  end

  attr_accessor :thisWin,:BackWin,:FontWin,:parentWin
end
