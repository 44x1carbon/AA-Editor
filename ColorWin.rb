require 'curses'

class CPickWin
	def init(wind)
		init_color
		@window = wind.subwin(wind.maxy - 3, 15,0,0)
		@window.keypad(true)
		@select = "back"

		@back = {}
		@back[:entity] = ColorWin.new
		@back[:pos] = {:y => 5,:x => 2}
		@back[:entity].setPos(@back[:pos][:y],@back[:pos][:x])
		@back[:entity].setText("Back")
		@back[:entity].init(@window)

		@font = {}
		@font[:entity] = ColorWin.new
		@font[:pos] = {:y => 8,:x => 2}
		@font[:entity].setPos(@font[:pos][:y],@font[:pos][:x])
		@font[:entity].setText("Font")
		@font[:entity].init(@window)

		@sample = {}
		@sample[:entity] = SampleWin.new
		@sample[:pos] = {:y => 1,:x => 2}
		@sample[:entity].setPos(@sample[:pos][:y],@sample[:pos][:x])
		@sample[:entity].init(@window)

	end

	def display()
		@window.clear
		@sample[:entity].display(@back[:entity].getSelect,@font[:entity].getSelect)
		@font[:entity].display
		@back[:entity].display
		@window.box("|","-")
		if @select != "none" then
			if @select == "back" then
				target = @back
			elsif @select == "font" then
				target = @font
			end
			@window.setpos(target[:pos][:y] + 1,target[:pos][:x] - 1)
			@window.addstr(">")
		end
		@window.refresh
	end

	def selectItem()
		while key = @window.getch do
			case key
			when 259,258
						if @select == "none" then
							@select = "back"
						elsif @select == "back" then
							@select = "font"
						elsif @select == "font" then
							@select = "back"
						end
						display()
				when 10
					if @select == "back" then
					 	@back[:entity].openColors
					elsif @select == "font" then
						@font[:entity].openColors
					end
					display
				when 27
					@select = "none"
					display
					break
			end
		end
	end

	def getColor()
		return {:back => @back[:entity].getSelect,:font => @font[:entity].getSelect,}
	end

	def init_color()
		8.times.with_index{|i|
			8.times.with_index{|j|
				Curses::init_pair(i * 8 + j,j,i)
			}
		}
	end
end

#---------------------BaseWin--------------------------------------------------------
class BaseWin
	def init(wind)
		@parent = wind
		@window = wind.subwin(@height,@width,@y,@x)
		@window.keypad(true)
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

#---------------------SampleWin--------------------------------------------------------
class SampleWin < BaseWin
	def init(wind)
			setHW(4,11)
			super
	end

	def display(back,font)
			@window.clear
			@window.setpos(1,2)
			@window.addstr("Sample")
			@window.setpos(2,1 + "Sample".length / 2)
			@window.attron(Curses.color_pair(back * 8 + font)){
				@window.addstr("A")
			}
			@window.refresh
			refresh
	end
end

#---------------------ColorWin--------------------------------------------------------
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
		@window.addstr(": ")
		@window.attron(Curses::color_pair(@colors.getSelect)){
			@window.addstr("   ")
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

	def getSelect()
			return @colors.getSelect - 70
	end
end

#---------------------Colors--------------------------------------------------------
class Colors < BaseWin
	def init(wind)
		@colors = [1,0,2,3,4,5,6,7]
		8.times.with_index{|idx|
			Curses::init_pair(70 + @colors[idx],@colors[idx],@colors[idx])
		}
		setHW(10,5)
		super
		@select = 70
		@corsor_pos = 0
	end

	def display()
		8.times.with_index{|idx|
			@window.setpos(1 + idx,1)
			@window.attron(Curses::color_pair(70 + @colors[idx])){
				@window.addstr("  ")
			}
			@window.attroff(Curses::color_pair(70 + @colors[idx]))
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
			when 258
					if @corsor_pos < 7 then
						@corsor_pos += 1
						display()
					end
				when 259
					if @corsor_pos > 0 then
						@corsor_pos -=1
						display()
					end
				when 10
					@select = 70 + @colors[@corsor_pos]
					@window.clear
					break
			end
		end
	end

	def getSelect()
		return @select
	end
end
