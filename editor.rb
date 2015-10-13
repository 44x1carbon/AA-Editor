require "curses"

class ColorPicker
	
end

class  NCObj
	def initialize(filepath)
		File.open(filepath) do |file|
			@body = file.read
		end
		@z_index = 0
		@index = nil
		@x = 0
		@y = 0
	end

	def pos()
		{"x" => @x,"y" => @y}
	end
		
	def display()
		lines = @body.split("\n")
		lines.each_index { |idx|
			lines[idx].split(/\S\s/).each { |str|
				num = str.count(" ")
				Curses.setpos(@y + idx,@x + num)
				Curses.addstr(lines[idx].gsub(" ", ""))
			}
		}
	end 
	
 	attr_accessor :body,:z_index,:index,:x,:y
end


class SelectList < NCObj
	def initialize(x,y)
		#表示位置(x,y)
		@x = x
		@y = y
		@select = 1
		@items = []
		@max_len = 0
		@inline = 4 #縦方向の表示感覚
	end
	def add(list_item)
		if list_item.is_a?(ListItem) then
			#リストに追加されたアイテムの最大表示文字数を更新する
			nlen =  list_item.get["name"].length
			if nlen > @max_len
				@max_len = nlen
			end
			@items.push(list_item)
		else
			STDERR.puts "error: addItem is not listitem."
			exit(true)
		end
		
	end

	def display()
		Curses.setpos(@y,@x)
		#枠の上を表示
		Curses.addstr("+--")
		
		@max_len.times do
			Curses.addstr("-")
		end
		Curses.addstr("--+")
		
		#リスト部分を表示する
		y = 0 		#表示している行を格納する
		
		@items.length.times do |i|
			idx = i + 1
			Curses.setpos(@y + idx , @x)
			Curses.addstr("|")
			Curses.setpos(@y + idx , @x + 3)
			#選択された行の場合色を変える
			if i == @select	then
				Curses.attron(Curses::A_REVERSE)	#反転属性を追加
				Curses.addstr(@items[i].get["name"])
				Curses.attroff(Curses::A_REVERSE)	#反転属性を除外
			else
				Curses.addstr(@items[i].get["name"])
			end
			Curses.setpos(@y + idx, @x + @max_len + 5)
			Curses.addstr("|")
			y += 1 
		end
		
		Curses.setpos(y + 1,@x)
		#枠の上を表示
		Curses.addstr("+--")
		
		@max_len.times do
			Curses.addstr("-")
		end
		Curses.addstr("--+")
	end
end

class ListItem
	def initialize(name,value)
		@name = name
		@value = value
	end

	def get()
		{"name" => @name,"value" => @value}
	end
end 


class NCScreen
	def initialize()
		@objs = []
	end

	def addObj(object)
		if object.instance_of? NCObj then
			@objs.push(object)
		end
	end

	def display()
		@objs.each {|obj| obj.body.split("\n").each {|line| }}
	end

	attr_accessor :objs,:min
end 

Curses.init_screen

begin
	s = SelectList.new(0,0)
	s.add(ListItem.new("hoge",3))
	s.add(ListItem.new("hogehogeaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",3)) #リストに追加する
	s.display
	Curses.refresh
	Curses.getch()

ensure
	Curses.close_screen
end
