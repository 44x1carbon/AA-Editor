require './Campus'
include Campus
require './Draw' 
require 'curses'


#a = Campus::Campus.new
#a.load('./hello.AE')
#a.write('./out',true)
#p a.campus
#p a.input('a',0,0,0,0)
#p a.campus
Curses::init_screen
win = Curses::Window.new(10,10,10,10)
Draw.drawAA(0,0,"./hello.AE",win)
win.refresh
win.getch
Curses::close_screen

