require 'curses'
require './Campus' 

class EditWin
	def init(wind,filepath)
		@window = wind.subwin(wind.maxy - 3,wind.maxx - 11,0,11)
		@window.box("|","-")
		@dispWin = @window.subwin(@window.maxy - 2,@window.maxx - 2,1,12)
		@window.scrollok(true);
		@campus = Campus::Campus.new
		@campus.load(filepath)
		@color_list = [[false,false,false,false,false,false,false,false,],[false,false,false,false,false,false,false,false,],[false,false,false,false,false,false,false,false,],[false,false,false,false,false,false,false,false,],[false,false,false,false,false,false,false,false,],[false,false,false,false,false,false,false,false,],[false,false,false,false,false,false,false,false,],[false,false,false,false,false,false,false,false,]] 
		@corsor_y = 0
		@corsor_x = 0
	end
	
	def display()
		@dispWin.clear
		@dispWin.setpos(0,0)
		@dispWin.maxy.times.with_index{|idx|
			@campus.getLine(idx + @corsor_y).each{|char|
				if char['x']  >= @corsor_x && char['x']  <= @corsor_x + @dispWin.maxx then				
					@dispWin.setpos(idx,char['x'] - @corsor_x )
					back = char["back"]
					font = char["font"]
					if @color_list[back][font] == false then
						Curses.init_pair(back*8 + font,font,back)
						@color_list[back][font] = true
					end
					@dispWin.attron(Curses::color_pair(back * 8 + font)){
						@dispWin.addstr(char["char"])
					}
				end
			}
		}
		@dispWin.refresh
	end
	
	def scrollUp(num)
		if @corsor_y - num <= 1 then
			@corsor_y = 0
		else
			@corsor_y -= num
		end
		display()
	end

	def scrollDown(num)
		@corsor_y += num
		display()
	end
	
	def scrollLeft(num)
		if @corsor_x - num <= 1 then
			@corsor_x = 0
		else
			@corsor_x -= num
		end
		display()
	end

	def scrollRight(num)
		@corsor_x += num
		display()
	end

	
end
