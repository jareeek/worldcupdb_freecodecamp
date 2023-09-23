#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS=',' read year game winner loser wgoals lgoals
do 
  if [[ $winner != 'winner' ]] && [[ $loser != 'loser' ]]
    then
    # iterate through winners
    W_TEAM_ID=$($PSQL "select team_id from teams where name='$winner';")
    # if team not exists
    if [[ -z $W_TEAM_ID ]]
    # insert new team
      then 
        W_INSERT_RESULT=$($PSQL "insert into teams(name) values('$winner');")
      if [[ $W_INSERT_RESULT == 'INSERT 0 1' ]]
        then echo "Inserted team: $winner"
        W_TEAM_ID=$($PSQL "select team_id from teams where name='$winner';")
      fi
    fi
    # iterate through opponents
    L_TEAM_ID=$($PSQL "select team_id from teams where name='$loser';")
    # if team not exists
    if [[ -z $L_TEAM_ID ]]
    # insert new team
      then 
        W_INSERT_RESULT=$($PSQL "insert into teams(name) values('$loser');")
      if [[ $W_INSERT_RESULT == 'INSERT 0 1' ]]
        then 
          echo "Inserted team: $loser"
          L_TEAM_ID=$($PSQL "select team_id from teams where name='$loser';")
      fi
    fi
    GAME_INSERT_RESULT=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($year, '$game', $W_TEAM_ID, $L_TEAM_ID, $wgoals, $lgoals);")
    if [[ $GAME_INSERT_RESULT == 'INSERT 0 1' ]]
      then
        echo Inserted game: $year, $game
    fi
  fi
done
