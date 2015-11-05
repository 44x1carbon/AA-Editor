require 'curses'
require_relative './Campus'




class EditWin
  def init(parent,filepath)
    @MainWin = parent
    @parentWin = @MainWin.thisWin

    @HEIGHT =  @parentWin.maxy - 2
    @WIDTH = @parentWin.maxx - 15
    @X = 15
    @Y = 0

    @thisWin = @parentWin.subwin(@HEIGHT,@WIDTH,@Y,@X)
    @dispWin = @thisWin.subwin(@HEIGHT - 2,@WIDTH - 2,@Y + 1,@X + 1)
    @disp_y = 0
    @disp_x = 0
    @corsor_y = 1
    @corsor_x = 0
    @Campus = Campus.new
    @Campus.load(filepath)
  end

  def display()
    @thisWin.clear
    @dispWin.setpos(0,0)
    setCorsor
		@dispWin.maxy.times.with_index{|idx|
      if @Campus.getLine(idx + @disp_y) != nil then
			  @Campus.getLine(idx + @disp_y).each{|char|
				  if char['x']  >= @disp_x && char['x']  <= @disp_x + @dispWin.maxx then
					  @dispWin.setpos(idx,char['x'] - @disp_x )
					  back = char["back"]
					  font = char["font"]
					  @dispWin.attron(Curses::color_pair(back * 8 + font)){
						  @dispWin.addstr(char["char"])
					  }
				  end
			  }
      end
		}
    @thisWin.box('|','-')
    @thisWin.refresh
  end

  def getKey()
    setCorsor
    key = @parentWin.getch()
    case key
      when Curses::Key::UP
        moveCorsor("UP")
      when Curses::Key::DOWN
        moveCorsor("DOWN")
      when Curses::Key::LEFT
        moveCorsor("LEFT")
      when Curses::Key::RIGHT
        moveCorsor("RIGHT")
      when Curses::Key::ENTER
        @corsor_y += 1
        @corsor_x = 0
        setCorsor
      when Curses::Key::BACKSPACE
        delete
      when 27
        display
        KeyManager.instance.setTarget(@MainWin.ComandWin)
      else
        input(key)
    end
  end

  def setCorsor()
    @parentWin.setpos(@corsor_y,@corsor_x + @X + 1)
  end

  def moveCorsor(direction)
    case direction
      when "UP"
        if isScroll("UP") then
          @corsor_y = 1
          scroll(direction,1)
        else
          @corsor_y -= 1
        end
        setCorsor
      when "DOWN"
        if isScroll("DOWN") then
          @corsor_y = @HEIGHT - 2
          scroll(direction,1)
        else
          @corsor_y += 1
        end
        setCorsor
      when "LEFT"
        if isScroll("LEFT") then
          @corsor_x = 0
          scroll(direction,1)
        else
          @corsor_x -= 1
        end
        setCorsor
      when "RIGHT"
        if isScroll("RIGHT") then
          @corsor_x = @WIDTH - 3
          scroll(direction,1)
        else
          @corsor_x += 1
        end
        setCorsor
    end
  end

  def scroll(direction,num)
    case direction
      when "UP"
        if @disp_y - num > 0 then
          @disp_y -= num
        else
          @disp_y = 0
        end
      when "DOWN"
        @disp_y += num
      when "LEFT"
        if @disp_x - num > 0 then
          @disp_x -= num
        else
          @disp_x = 0
        end
      when "RIGHT"
        @disp_x += num
    end
    display
  end

  def isScroll(direction)
      case direction
        when "UP"
            if @corsor_y > 1 then
              return false
            else
              return true
            end
        when "DOWN"
          if @corsor_y < @HEIGHT - 2 then
            return false
          else
            return true
          end
        when "LEFT"
          if @corsor_x > 0 then
            return false
          else
            return true
          end
        when  "RIGHT"
          if @corsor_x < @WIDTH - 3 then
            return false
          else
            return true
          end
      end
  end

  def delete()
    y = @disp_y + @corsor_y - 1
    x = @disp_x + @corsor_x - 1
    @Campus.pop(y,x)
    if isScroll("LEFT") then
      scroll("LEFT",1)
    else
      @corsor_x -= 1
    end
    setCorsor
    display
  end

  def input(key)
    colors = @MainWin.ColorPicker.getColor
    y = @disp_y + @corsor_y - 1
    x = @disp_x + @corsor_x
    @Campus.input(key.chr,colors[:back],colors[:font],y,x)
    if isScroll("RIGHT") then
      scroll("RIGHT",1)
    else
      @corsor_x += 1
    end
    setCorsor
    display
  end

  attr_accessor :thisWin,:Campus
end
