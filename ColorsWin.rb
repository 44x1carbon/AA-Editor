require 'curses'

PICKNUM = 70

class ColorsWin
  def init(parent)
    @ColorSelectWin = parent
    @ColorPicker = @ColorSelectWin.ColorPicker
    @parentWin = @ColorSelectWin.thisWin
    @thisWin = @parentWin.subwin(10,6,@y,@x)
    initColorSet
    @select = PICKNUM
    @corsor_pos = 1
  end


  def display()

    @thisWin.clear
    @thisWin.box('|','-')
    colorBar = "   "
    @colors.length.times.with_index{|idx|
      @thisWin.setpos(1 + idx,1)

      @thisWin.attron(Curses::color_pair(PICKNUM + @colors[idx])){
        @thisWin.addstr(colorBar)
      }
      @thisWin.attroff(Curses::color_pair(PICKNUM + @colors[idx]))
      @thisWin.addstr(" ")
    }
    @thisWin.setpos(1 + @corsor_pos,colorBar.length + 1)
    @thisWin.addstr("<")
    @thisWin.refresh
  end

  def setYX(y,x)
    @y = y
    @x = x
  end

  def initColorSet()
    @colors = [1,0,2,3,4,5,6,7]
		@colors.length.times.with_index{|idx|
			Curses::init_pair(PICKNUM + @colors[idx],@colors[idx],@colors[idx])
		}
  end

  def getSelectColor()
      @select = PICKNUM + @colors[@corsor_pos]
      return @select
  end

  def getKey()
    Curses::curs_set(0)
    key = @ColorSelectWin.ColorPicker.parentWin.getch
    case key
      when Curses::Key::UP
        if @corsor_pos > 0 then
          @corsor_pos -= 1
        else
          @corsor_pos = 7
        end
        display
      when Curses::Key::DOWN
        if @corsor_pos < 7 then
          @corsor_pos += 1
        else
          @corsor_pos = 0
        end
        display
      when 10
        @ColorSelectWin.thisWin.clear
        @ColorSelectWin.display
        @ColorPicker.display
        KeyManager.instance.setTarget(@ColorPicker)

    end
  end
end
