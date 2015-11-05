require_relative './MainWin'
require_relative './Campus'


a = MainWin.new
a.init()
a.display
loop {
  a.getKey()
}
