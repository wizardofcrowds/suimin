require 'securerandom'

class Suimin::Sleeper

  attr_reader :name, :distribution

  # _config[:name]:i         The name of the sleeper instance.
  # _config[:distribution]: An array of arrays whose element is [_probablility_, _sleep_duration_in_second_]
  #                         For example [0.5, 1] means the probablity of sleeping for 1 second is 0.5
  #                         If sum of the probability isn't 1.0, the probablities are normalized automatically.
  #                         For example, [[1.0, 1], [1.0, 3]] => [[0.5, 1], [0.5, 3]]
  def initialize(_config)
    @distribution = normalize_distribution(_config[:distribution]).sort{|a,b| a[0] <=> b[0]}
    @name = _config[:name]
  end

  # converts the distribution to cdf
  def rule
    @rule || @distribution.inject([]){|result, elm| result << [(result.empty? ? 0.0 : result.last[0]) + elm[0], elm[1]]}\
                          .tap{|array| array.last[0] = 1.0 } # make sure the last element's cdf is 1.0
  end

  def sleep
    Kernel.sleep sleep_duration
  end

  def sleep_duration
    return 0 if rule.empty?

    _rand = SecureRandom.random_number
    rule.find{|elm| elm[0] >= _rand}[1]
  end

  private
  def normalize_distribution(_distribution)
    if _distribution.nil? || _distribution.empty?
      raise InvalidRuleException.new("distribution should be an array of [probability, sleep_time_in_sec]")
    end
    _sum = _distribution.inject(0.0){|result, elm| result += elm[0] }
    return _distribution.collect{|elm| [elm[0]/_sum, elm[1]]}
  end

  class InvalidRuleException < StandardError; end
end
