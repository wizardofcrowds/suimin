require "suimin/version"

module Suimin

  autoload :Sleeper, 'suimin/sleeper'

  class TypeError       < Exception; end
  class SleeperNotFound < StandardError; end

  # a hash whose key is the sleeper's name, and the value is the sleeper
  @@sleepers = {}

  class << self
    def sleepers
      @@sleepers
    end

    def add_sleeper(_sleeper)
      raise TypeError.new("sleeper should be Suimin::Sleeper instance") unless _sleeper.is_a?(Suimin::Sleeper)

      sleepers[_sleeper.name] = _sleeper
    end

    def let_sleeper_sleep(_sleeper_name)
      if (sleeper = sleepers[_sleeper_name])
        sleeper.sleep
      else
        raise SleeperNotFound.new("Sleeper #{_sleeper_name} cannot be found")
      end
    end

  end

  def self.config
    yield self
  end

end
