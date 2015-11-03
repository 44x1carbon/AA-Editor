require 'curses'
require './Campus'

class EditWin
	def init(wind,filepath)
		@window = wind.subwin(wind.maxy - 3,wind.maxx - 15,0,15)
		@dispWin = @window.subwin(@window.maxy - 2,@window.maxx - 2,1,15)
		@window.scrollok(true);
		@campus = Campus::Campus.new
		@campus.load(filepath)
		@disp_y = 0
		@disp_x = 0
	end

	def display()
		@dispWin.clear
		@dispWin.setpos(0,0)
		@dispWin.maxy.times.with_index{|idx|
			@campus.getLine(idx + @disp_y).each{|char|
				if char['x']  >= @disp_x && char['x']  <= @disp_x + @dispWin.maxx then
					@dispWin.setpos(idx,char['x'] - @disp_x + 1)
					back = char["back"]
					font = char["font"]
					@dispWin.attron(Curses::color_pair(back * 8 + font)){
						@dispWin.addstr(char["char"])
					}
				end
			}
		}
		@window.box("|","-")
		@dispWin.refresh
	end

	def scrollUp(num)
		if @disp_y - num <= 1 then
			@disp_y = 0
		else
			@disp_y -= num
		end
		display()
	end

	def scrollDown(num)
		@disp_y += num
		display()
	end

	def scrollLeft(num)
		if @disp_x - num <= 1 then
			@disp_x = 0
		else
			@disp_x -= num
		end
		display()
	end

	def scrollRight(num)
		@disp_x += num
		display()
	end


end
