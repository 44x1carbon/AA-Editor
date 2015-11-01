require 'curses'
require 'io/console'
class CPickWin
	def init(wind)
		@window = wind.subwin(wind.maxy - 3, 14,0,0)
		@window.box("|","-")
		@backWin = ColorWin.new
		@backWin.setPos(5,2)
		@backWin.init(@window)
		@backWin.refresh
		@window.refresh
	end
	
	
end

class BaseWin
	def init(wind)
		@parent = wind
		@window = wind.subwin(@height,@width,@y,@x)
		end
	
	def refresh()
		@window.box("|","-")
		@window.refresh
	end
	
	def setHW(h,w)
		@height = h
		@width = w
	end

	def setPos(y,x)
		@y = y
		@x = x
	end	
end

class ColorWin < BaseWin
	def init(wind)
		setHW(3,11)
		super	
		@colors = Colors.new
		@colors.setPos(@y,6 + @x)
		@colors.init(wind)
	end 
	
	def display()
		@window.clear
		@window.setpos(1,1)
		@window.addstr(@text)
		@window.addstr(":")
		@window.attron(Curses::color_pair(@colors.getSelect)){
			@window.addstr("  ")
		}
		refresh
	end

	def openColors()
		@colors.display
		@colors.getch
		@parent.clear
		display
	end

	def setText(text)
		@text = text
	end
end

class Colors < BaseWin
	def init(wind)
		@colors = [1,0,2,3,4,5,6,7]
		8.times.with_index{|idx|
			Curses::init_pair(70 + idx,@colors[idx],@colors[idx])
		}
		setHW(10,5)
		super
		@select = 71
		@corsor_pos = 0
	end
	
	def display()
		8.times.with_index{|idx|
			@window.setpos(1 + idx,1)
			@window.attron(Curses::color_pair(70 + idx)){
				@window.addstr("  ")
			}
			@window.attroff(Curses::color_pair(70 + idx))
				@window.addstr(" ")
		}
		@window.setpos(1 + @corsor_pos,3)
		@window.addstr("<")
		@window.refresh
		refresh
	end
	
	def getch()

		while key = @window.getch do
			case key
				when "j"
					if @corsor_pos < 7 then
						@corsor_pos += 1
						display()
					end
				when "k"
					if @corsor_pos > 0 then
						@corsor_pos -=1
						display()
					end
				when 10
					@select = 70 + @corsor_pos
					@window.clear
					break
			end
		end					
	end	
	
	def getSelect()
		return @select
	end
end
