require 'singleton'


class KeyManager
  include Singleton
  def getKey()
    @target.getKey()
  end

  def setTarget(target)
    @target = target
  end
end
