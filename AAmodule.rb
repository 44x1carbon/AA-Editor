module AA
	def loadAA(filepath) 
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
		return objs
	end
end

