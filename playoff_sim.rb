load 'nfl_odds.rb'
require 'colorize'

def print_champ(championship_team, file)
  CSV.open(file, "a") do |csv|
      csv << [championship_team.team_name]
    end
end

def generate_seeds(teams,seeding,order)
  order = teams.sort{ |a,b| (a.wins == b.wins) ? a.pts.sum <=> b.pts.sum : a.wins <=> b.wins }

  seeding[:one] = order[11]
  seeding[:two] = order[10]
  seeding[:three] = order[9]
  seeding[:four] = order[8]
  seeding[:five] = order[7]
  seeding[:six] = order[6]
end

1000.times do

  #setup teams and fill arrays with teams played through 13
  played_weeks = []
  future_weeks = []
  teams = []
  generate_weeks(played_weeks,future_weeks,13)
  generate_teams(teams,played_weeks,future_weeks,13)

  seeding = {one: nil,
             two: nil,
             three: nil,
             four: nil,
             five: nil,
             six: nil}
  order = []

  #fill seeding hash with team objects
  generate_seeds(teams,seeding,order)

  #play first round matchups
  if seeding[:four].generate_random_score > seeding[:five].generate_random_score
    winner_game_one = seeding[:four]
    puts "#{seeding[:four].team_name} beat #{seeding[:five].team_name} in first round"
  else
    winner_game_one = seeding[:five]
    puts "#{seeding[:five].team_name} beat #{seeding[:four].team_name} in first round"
  end

  if seeding[:three].generate_random_score > seeding[:six].generate_random_score
    winner_game_two = seeding[:three]
    puts "#{seeding[:three].team_name} beat #{seeding[:six].team_name} in first round"
  else
    winner_game_two = seeding[:six]
    puts "#{seeding[:six].team_name} beat #{seeding[:three].team_name} in first round"
  end

  #play second round matchups
  if seeding[:one].generate_random_score > winner_game_one.generate_random_score
    winner_game_three = seeding[:one]
    puts "#{seeding[:one].team_name} beat #{winner_game_one.team_name} in the semifinals"
  else
    winner_game_three = winner_game_one
    puts "#{winner_game_one.team_name} beat #{seeding[:one].team_name} in the semifinals"
  end

  if seeding[:two].generate_random_score > winner_game_two.generate_random_score
    winner_game_four = seeding[:two]
    puts "#{seeding[:two].team_name} beat #{winner_game_two.team_name} in the semifinals"
  else
    winner_game_four = winner_game_two
    puts "#{winner_game_two.team_name} beat #{seeding[:two].team_name} in the semifinals"
  end

  #play final matchup
  if winner_game_three.generate_random_score > winner_game_four.generate_random_score
    winner_championship = winner_game_three
    puts "#{winner_game_three.team_name} beat #{winner_game_four.team_name} in the final"
  else
    winner_championship = winner_game_four
    puts "#{winner_game_four.team_name} beat #{winner_game_three.team_name} in the final"
  end


  puts "#{winner_championship.team_name} won the championship"
  puts "\n \n \n"
  puts "                 #{seeding[:one].team_name[0..10]}"
  puts "                ---------------|"
  puts "#{seeding[:four].team_name[0..10]}                    |#{winner_game_three.team_name[0..10]}"
  puts "---------------                |-----------|"
  puts "               |#{winner_game_one.team_name[0..10]}    |           |"
  puts "               |---------------            |"
  puts "               |                           |"
  puts "#{seeding[:five].team_name[0..10]}                                |"
  puts "---------------                            |#{winner_championship.team_name[0..10]}"
  puts "                                           ----------"
  puts "#{seeding[:three].team_name[0..10]}                                |"
  puts "---------------                            |"
  puts "               |#{winner_game_two.team_name[0..10]}                |"
  puts "               |---------------            |"
  puts "               |               |           |"
  puts "#{seeding[:six].team_name[0..10]}                    |#{winner_game_four.team_name[0..10]}|"
  puts "---------------                |----------"
  puts "                 #{seeding[:two].team_name[0..10]}   |"
  puts "                ---------------"

  print_champ(winner_championship, "champ.csv")
end


champ_teams = CSV.read('champ.csv')
team_per = {}

champ_teams.each do |x|
  if team_per[x[0]]
    team_per[x[0]] += 1
  else
    team_per[x[0]] = 1
  end
end


team_per.map do |key, value|
  puts "#{key.colorize(:magenta)} won the championshiop #{(100*value.to_f/(champ_teams.length/1)).round(2).to_s.colorize(:blue)}% of the simulated seasons"
end

puts "we simulated #{champ_teams.length/1} seasons"
