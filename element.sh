#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
  exit
fi

# atomic number name symbol type atomic mass melting point boiling point

if [[ $1 =~ ^[1-9]+$ ]]
then
  ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties FULL JOIN elements USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $1")
  # echo $ELEMENT
else
  ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties FULL JOIN elements USING(atomic_number) FULL JOIN types USING(type_id) WHERE symbol = '$1' OR name = '$1'")
  # echo $ELEMENT
fi

if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
  exit
fi

echo "$ELEMENT" | while IFS=" |" read ATOMIC_NUM NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
do
  echo "The element with atomic number $ATOMIC_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
done
