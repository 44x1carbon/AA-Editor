require 'curses'

class ComandWin

  def init(parent)
    @MainWin = parent
    @parentWin = @MainWin.thisWin
    @thisWin = @parentWin.subwin(2,@parentWin.maxx, @parentWin.maxy - 2, 0)

    @EditWin = @MainWin.EditWin
    @ColorPicker = @MainWin.ColorPicker


    @comand = ""
  end

  def display()
    @thisWin.clear
    @thisWin.setpos(0,0)
    @thisWin.attron(Curses::A_REVERSE)
    @thisWin.addstr(" " * @parentWin.maxx  )
    @thisWin.attroff(Curses::A_REVERSE)
    @thisWin.setpos(0,0)
    @thisWin.setpos(0,(@parentWin.maxx/2)-(@filename.length/2))
    @thisWin.addstr(@filename)
    @thisWin.refresh


  end

  def getKey()
    display
    Curses::curs_set(1)
    @parentWin.setpos(@parentWin.maxy - 1,0)
    @comand = @parentWin.getstr
    checkCMD()
    display
  end

  def checkCMD()
    case @comand
      when "a","i"
        KeyManager.instance.setTarget(@EditWin)
      when "c"
        KeyManager.instance.setTarget(@ColorPicker)
      when ":w"
        @EditWin.Campus.write(true)
      when ":wq"
        @EditWin.Campus.write(true)
        exit
      when ":q"
        exit
    end
  end

  def setFileName(filename)
    @filename = " " + filename + " "
  end
  attr_accessor :thisWin
end
