load 'nfl_odds.rb'
require 'colorize'

10000.times do
  played_weeks = []
  future_weeks = []
  teams = []
  generate_weeks(played_weeks,future_weeks,13)
  generate_teams(teams,played_weeks,future_weeks,13)
  weeks_to_play = []
  weeks_to_play.each do |week|
    simulate_week(week, teams, future_weeks)
  end
  print_playoff_teams(teams,"playoffs.csv")
end


play_teams = CSV.read('playoffs.csv')
team_per = {}

play_teams.each do |x|
  if team_per[x[0]]
    team_per[x[0]] += 1
  else
    team_per[x[0]] = 1
  end
end


team_per.map do |key, value|
  puts "#{key.colorize(:magenta)} makes it #{(100*value.to_f/(play_teams.length/6)).round(2).to_s.colorize(:blue)}% of the simulated seasons"
end

puts "we simulated #{play_teams.length/6} seasons"
