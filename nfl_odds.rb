require 'rubygems'
require 'csv'

module Enumerable

    def sum
      self.inject(0){|accum, i| accum + i }
    end

    def mean
      self.sum/self.length.to_f
    end

    def sample_variance
      m = self.mean
      sum = self.inject(0){|accum, i| accum +(i-m)**2 }
      sum/(self.length - 1).to_f
    end

    def standard_deviation
      return Math.sqrt(self.sample_variance)
    end

end

class RandomGaussian
  def initialize(mean, stddev, rand_helper = lambda { Kernel.rand })
    @rand_helper = rand_helper
    @mean = mean
    @stddev = stddev
    @valid = false
    @next = 0
  end

  def rand
    if @valid then
      @valid = false
      return @next
    else
      @valid = true
      x, y = self.class.gaussian(@mean, @stddev, @rand_helper)
      @next = y
      return x
    end
  end

  private
  def self.gaussian(mean, stddev, rand)
    theta = 2 * Math::PI * rand.call
    rho = Math.sqrt(-2 * Math.log(1 - rand.call))
    scale = stddev * rho
    x = mean + scale * Math.cos(theta)
    y = mean + scale * Math.sin(theta)
    return x, y
  end
end

class Team
  attr_accessor :teamid, :pts, :remaining_schedule

  def initialize(teamid, team_name, pts, remaining_schedule)
    @teamid = teamid
    @team_name = team_name
    @pts = pts
    @remaining_schedule = remaining_schedule
  end

  def generate_random_score
    avg = @pts.mean
    std = @pts.standard_deviation
    gen = RandomGaussian.new(avg, std)
    score = gen.rand
  end

end

class PlayedWeek
  attr_accessor :week_num, :matchups
  def initialize(arr)
    @week_num = arr[0][0].scan(/\d+/)[0].to_i
    @matchups = []

    away_teams = [17,26,35,44,53,62].map{|i| team_id_con(arr[i][0])}
    home_teams = [21,30,39,48,57,66].map{|i| team_id_con(arr[i][0])}
    away_scores = [20,29,38,47,56,65].map{|i| arr[i][0][0..4].to_f}
    home_scores = [24,33,42,51,60,69].map{|i| arr[i][0][0..4].to_f}

    (0..5).each do |x|
      @matchups[x] = {away_team: away_teams[x],
                   away_score: away_scores[x],
                   home_team: home_teams[x],
                   home_score: home_scores[x]}
    end

  end

end


def team_id_con(name)
  x = {"In Zeke We Trust" => 1,
       "Hurricane Ajayi" => 2,
       "JEFFERY" => 3,
       "Inglorious Staffords" => 4,
       "Still Cookin'" => 5,
       "Yippee Kai A Justin Tucker" => 6,
       "Hyde ya Kids Hyde ya Wife" => 7,
       "Water under the Bridgewater" => 8,
       "Jaboo Coming Thru" => 9,
       "Mayfield's Bakery" => 10,
       "Got my Siemian on Kelce" => 11,
       "Get Your Tyreek On" => 12
     }
  x[name]
end
