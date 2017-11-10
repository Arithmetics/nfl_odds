load 'nfl_odds.rb'
require 'colorize'

puts "please enter team_id to simulate a win"
entered_team_id = gets.chomp.to_i

1000.times do
  played_weeks = []
  future_weeks = []
  teams = []
  generate_weeks(played_weeks,future_weeks,9)
  generate_teams(teams,played_weeks,future_weeks,9)
  weeks_to_play = [10,11,12,13]
  simulate_win(entered_team_id, teams, future_weeks)
  weeks_to_play.each do |week|
    simulate_week(week, teams, future_weeks)
  end
  print_playoff_teams(teams,'with_team_win.csv')
end


play_teams = CSV.read('with_team_win.csv')
team_per = {}

play_teams.each do |x|
  if team_per[x[0]]
    team_per[x[0]] += 1
  else
    team_per[x[0]] = 1
  end
end

puts "this standing was simulated with giving team #{id_to_name(entered_team_id)} a win".colorize(:green)
team_per.map do |key, value|
  puts "#{key.colorize(:magenta)} makes it #{(100*value.to_f/(play_teams.length/6)).round(2).to_s.colorize(:blue)}% of the simulated seasons"
end

puts "we simulated #{play_teams.length/6} seasons"
