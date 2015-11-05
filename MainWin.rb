require 'curses'
require_relative './ColorPicker'
require_relative './EditWin'
require_relative './ComandWin'
require_relative './KeyManager'
require 'singleton'

class MainWin
  def init()
      @filepath = File.absolute_path(ARGV[0])
      @filename = File.basename(@filepath)


      Curses.start_color
      Curses.crmode
      @parentWin = Curses.stdscr
      @thisWin = @parentWin.subwin(@parentWin.maxy,@parentWin.maxx,0,0)
      @thisWin.keypad(true)

      @ColorPicker = ColorPicker.new
      @ColorPicker.init(self)

      @EditWin = EditWin.new
      @EditWin.init(self,@filepath)

      @ComandWin = ComandWin.new
      @ComandWin.setFileName(@filename)
      @ComandWin.init(self)

      KeyManager.instance.setTarget(@ComandWin)
  end

  def getKey()
    KeyManager.instance.getKey()
  end

  def display()
    @ComandWin.display()
    @EditWin.display
    @ColorPicker.display
    @thisWin.refresh
  end



  attr_accessor :thisWin,:ColorPicker,:ComandWin,:EditWin
end
