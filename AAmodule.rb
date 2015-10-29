module AAEditer
	class Campus
		def load(filepath) 
			objs = []
			keylist = ["char","back","font","y","x"]
			f = File.open(filepath,mode = "r")
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
				objs.push(obj)
			}
			f.close
			@campus = objs
		end
	
		def write(filepath,overwrite)
			filepath << '.AE'
			if File.exist?(filepath) && !overwrite then
				return -1
			end

			if @campus.nil? then
				#エラーを起こす
				return -1
			end
			
			f = File.open(filepath,'w')
			@campus.each{|char|
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
		end
		
		def input(obj)
			search(obj[y],obj[x])
		end
		
		def search(y,x)
			@campus.each_with_index{|char,idx|
				if char['y'] == y && char['x'] == x then
					return @campus[idx]
				end
			}
			return -1
		end

		def pop(y,x)
			@campus.each_with_index{|char,idx|
				if char['y'] == y && char['x'] == x then
					@campus.delete_at(idx)
				end
			}
		end

		def sort() #y,xの値の小さい順にソートする
			@campus.sort{|a,b|
				a['y'] <=> b['y']
			}
			@campus.each_index{|idx|
				a = @campus[idx]
				if a == @campus.last then 
					break
				end
				b = @campus[idx + 1]
				if a['y'] >= b['y'] && a['x'] < b['x'] then
					work = a
					a = b
					b = work
				end
			}
		end
		
		attr_accessor :campus	
	end
end
