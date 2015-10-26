require 'nkf'

module AA
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
			#テストコード
			#chars = loadAA('./hello.AE')
			filepath << '.AE'
			if File.exist?(filepath) && !overwrite then
				#ファイルが存在している時
				#上書きするかの確認をする
				return -1
			end

			if @campus.nil? then
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

	end
end

