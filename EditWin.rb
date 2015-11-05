require 'curses'
require './Campus'

class EditWin
	def init(wind,cpickWin,filepath)
		@CPickWin = cpickWin
		@window = wind.subwin(wind.maxy - 3,wind.maxx - 15,0,15)
		@window.keypad(true)
		@dispWin = @window.subwin(@window.maxy - 2,@window.maxx - 2,1,15)
		@window.scrollok(true);
		@campus = Campus::Campus.new
		@campus.load(filepath)
		@disp_y = 0
		@disp_x = 0
		@corsor_x = 0
		@corsor_y = 0
	end

	def display()
		Curses::curs_set(1)
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

	def write()
		@campus.write(true)
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

	def getch()
		display
		while key = @window.getch do
				case key
					when 258,259,260,261
						moveCorsor(key)
					when 263
						@campus.pop(@corsor_y + @disp_y ,@corsor_x - 1 + @disp_x	)
						@corsor_x -= 1
						@window.setpos(1+@corsor_y,1+@corsor_x)
						display
					when 27
						return
					when 10
					else
						@campus.input(key.chr,@CPickWin.getColor()[:back],@CPickWin.getColor()[:font],@corsor_y + @disp_y,@corsor_x + @disp_x)
						@corsor_x += 1
						@window.setpos(1+@corsor_y,1+@corsor_x)
						display
				end
		end
	end

	def moveCorsor(keycode)
		case keycode
		when 259
				@corsor_y -= 1
				if @corsor_y < 0 then
					scrollUp(1)
					@corsor_y = 0
				end
				@window.setpos(1+@corsor_y,1+@corsor_x)
			when 258
				@corsor_y += 1
				if @corsor_y >= @dispWin.maxy then
					scrollDown(1)
					@corsor_y = @dispWin.maxy - 1
				end
				@window.setpos(1+@corsor_y,1+@corsor_x)
			when 260
				@corsor_x -= 1
				if @corsor_x < 0 then
					scrollLeft(1)
					@corsor_x = 0
				end
				@window.setpos(1+@corsor_y,1+@corsor_x)
			when 261
				@corsor_x += 1
				if @corsor_x >= @dispWin.maxx then
					scrollRight(1)
					@corsor_x = @dispWin.maxx - 1
				end
				@window.setpos(1+@corsor_y,1+@corsor_x)
		end
	end
end
