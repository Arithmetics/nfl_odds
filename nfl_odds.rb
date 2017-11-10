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
  attr_accessor :teamid, :pts, :team_name, :remaining_schedule, :wins

  def initialize(team_id, team_name, pts, remaining_schedule, wins)
    @teamid = teamid
    @team_name = team_name
    @pts = pts
    @remaining_schedule = remaining_schedule
    @wins = wins
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

    away_teams = [18,27,36,45,54,63].map{|i| name_to_id(arr[i][0])}
    #away_teams = [18,27,36,45,54,63].map{|i| arr[i][0]}
    home_teams = [22,31,40,49,58,67].map{|i| name_to_id(arr[i][0])}
    #home_teams = [22,31,40,49,58,67].map{|i| arr[i][0]}
    away_scores = [21,30,39,48,57,66].map{|i| arr[i][0][0..4].to_f}
    home_scores = [25,34,43,52,61,70].map{|i| arr[i][0][0..4].to_f}

    (0..5).each do |x|
      @matchups[x] = {away_team: away_teams[x],
                      away_score: away_scores[x],
                      home_team: home_teams[x],
                      home_score: home_scores[x]
                      }
    end
  end

  def print_week
    puts "\n"
    puts "Week: #{@week_num}"
    @matchups.each do |game|
      puts "away: #{game[:away_team]}, #{game[:away_score]} || home: #{game[:home_team]}, #{game[:home_score]}"
    end
  end

end

class FutureWeek
  attr_accessor :week_num, :matchups
  def initialize(arr)
    @week_num = arr[0][0].scan(/\d+/)[0].to_i
    @matchups = []

    away_teams = [18,27,36,45,54,63].map{|i| name_to_id(arr[i][0])}
    #away_teams = [18,27,36,45,54,63].map{|i| arr[i][0]}
    home_teams = [22,31,40,49,58,67].map{|i| name_to_id(arr[i][0])}
    #home_teams = [22,31,40,49,58,67].map{|i| arr[i][0]}


    (0..5).each do |x|
      @matchups[x] = {away_team: away_teams[x],
                      home_team: home_teams[x]
                     }
    end
  end
end


def name_to_id(name)
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

def id_to_name(id)
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
  x.key(id)
end

def csv_to_array(file)
  CSV.read(file)
end

last_played_week = 9
played_weeks = []
future_weeks = []
teams = []


def generate_weeks(played_weeks,future_weeks,last_played_week)

  (1..last_played_week).each do |x|
    arr = csv_to_array("week#{x}.csv")
    played_weeks.push(PlayedWeek.new(arr))
  end

  ((last_played_week+1)..13).each do |x|
    arr = csv_to_array("week#{x}.csv")
    future_weeks.push(FutureWeek.new(arr))
  end

end


def generate_teams(teams,played_weeks,future_weeks,last_played_week)
  #for ids 1-12
    #get team name
    #search all played_weeks for pts scored and wins
    #search all future weeks for opponent ids

  (1..12).each do |x|

    team_id = x
    team_name = id_to_name(x)
    pts = []
    wins = 0
    remaining_schedule = []

    played_weeks.each do |week|
      week.matchups.each do |matchup|
        if matchup[:away_team] == x
          pts.push(matchup[:away_score])
          if matchup[:away_score] > matchup[:home_score]
            wins += 1
          end
        elsif matchup[:home_team] == x
          pts.push(matchup[:home_score])
          if matchup[:home_score] > matchup[:away_score]
            wins += 1
          end
        end
      end
    end

   future_weeks.each do |week|
     week.matchups.each do |matchup|
       if matchup[:away_team] == x
         remaining_schedule.push(matchup[:home_team])
       elsif matchup[:home_team] == x
         remaining_schedule.push(matchup[:away_team])
       end
    end
  end

  teams.push(Team.new(team_id, team_name, pts, remaining_schedule, wins))

  end #1-12
end #gen


def simulate_week


end 
