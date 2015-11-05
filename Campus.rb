
	class Campus
		def load(filepath)
			@data = {}
			@data[1] = []
			@filepath = filepath
			keylist = ["char","back","font","y","x"]
			if !File.exist?(@filepath)
				f = File.open(@filepath,mode = "w+")
			else
				f = File.open(@filepath)
			end
			f.each{|line|
				obj = {}
				line.scan(/.{1,#{4}}/).each_with_index{|a,idx|
					if idx == 0 then
						str = []
						str.push(a.hex)
						obj[keylist[idx]] = str.pack("U*")
					else
						obj[keylist[idx]] = a.hex
					end
				}
				if @data[obj["y"]] == nil then
					@data[obj["y"]] = []
					@data[obj["y"]].push(obj)
				else
					@data[obj["y"]].push(obj)
				end
			}
			f.close
		end

		def write(overwrite)
			if File.exist?(@filepath) && !overwrite then
				return -1
			end

			if @data.nil? then
				#エラーを起こす
				return -1
			end

			f = File.open(@filepath,'w')
			@data.each{|line|
				line[1].each{|char|
					out = {}
					if char['char'].match(/^[ -~｡-ﾟ]+$/) == nil then
						out['char'] = String.new
					else
						out['char'] = '00'
					end
					out['char']  << char['char'].unpack('U*')[0].to_s(16)

					out['back']  = String.new
					out['back'] << '000' << char['back'].to_s(16)

					out['font']  = String.new
					out['font'] << '000' << char['font'].to_s(16)

					out['y'] = String.new
					(4 - char['y'].to_s(16).length).times do
						out['y'] << '0'
					end
					out['y'] << char['y'].to_s(16)

					out['x'] = String.new
					(4 - char['x'].to_s(16).length).times do
						out['x'] << '0'
					end
					out['x'] << char['x'].to_s(16)

					f.puts out['char'] << out['back'] << out['font'] << out['y'] << out['x']

				}
			}
		end
		def hoge()
			p "hoge"
		end
		def getLine(idx)
			if @data[idx] == nil then
				return []
			else
				return @data[idx]
			end
		end
		#以下要修正
		def input(char,back,font,y,x)
			target = search(y,x)
			if target == -1 then
				obj = {'char'=>char,'back'=>back,'font'=>font,'y'=>y,'x'=>x}
				if @data[y].nil? then
					@data[obj['y']] = []
				end
				@data[obj['y']].push(obj)
				#sort()
			else
				target['char'] = char
				target['back'] = back
				target['font'] = font
			end
		end

		def search(y,x)
			if @data[y].nil? then
				return -1
			end
			@data[y].each_with_index{|char,idx|
				if char['x'] == x then
					return @data[y][idx]
				end
			}
			return -1
		end

		def pop(y,x)
			@data[y].each_with_index{|char,idx|
				if char['x'] == x then
					 @data[y].delete_at(idx)
				end
			}
		end



		attr_accessor :data
	end
