require './Campus'
include Campus
require 'curses'

module Draw
	class << self
		def drawAA(y,x,filepath,window)
			campus = Campus::Campus.new
			campus.load(filepath)
			color_list = [[false,false,false,false,false,false,false,false,],[false,false,false,false,false,false,false,false,],[false,false,false,false,false,false,false,false,],[false,false,false,false,false,false,false,false,],[false,false,false,false,false,false,false,false,],[false,false,false,false,false,false,false,false,],[false,false,false,false,false,false,false,false,],[false,false,false,false,false,false,false,false,]]
			if window.nil? then
				#エラー処理
			end
				Curses::start_color
				width = window.maxx()
				height = window.maxy()
				height.times.with_index{|hidx|
					width.times.with_index{|widx|
						charobj = campus.search(hidx,widx)
						if charobj != -1 then
							window.setpos(hidx,widx)
							back = charobj["back"]
							font = charobj["font"]
							if color_list[back][font] == false then
								Curses.init_pair(back*8 + font,font,back)
								color_list[back][font] = true
							end
							window.attron(Curses::color_pair(back * 8 + font)){
								window.addstr(charobj["char"])
							}
						end
					}
				}
		end
	end
end
