#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

  if [[ $YEAR != "year" ]] 
  then

    #INSERT DATA INTO TEAMS

    #get winner name from the teams table
    WINNER_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")

    #if winner does not exist, insert the team
    if [[ -z $WINNER_NAME ]]
    then 
      INSERT_WINNER_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    fi

    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    #get opponent name from the teams table
    OPP_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")

    #if opponent does not exist, insert the team
    if [[ -z $OPP_NAME ]]
    then 
      INSERT_OPP_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    fi

    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    #INSERT DATA INTO GAMES

    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, opponent_goals, winner_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $OPPONENT_GOALS, $WINNER_GOALS)")

  fi


done
