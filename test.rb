require './AAmodule'
include AA

a = AA::Campus.new
a.load('./hello.AE')
#a.write('./out',true)
p a.campus
