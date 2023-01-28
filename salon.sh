#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n\n~~~~~ NY SALON ~~~~~"
echo -e "\nWelcome to my Salon, how can I help you?\n"

LIST_SERVICES() {
  SERVICES=$($PSQL "SELECT * FROM services")
  echo -e "$SERVICES" | while  read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done
}

LIST_SERVICES
read SERVICE_ID_SELECTED

SERVICE_SELECTED=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
if [[ -z $SERVICE_SELECTED ]]
then
  LIST_SERVICES
else
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER=$($PSQL "SELECT * FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER ]] 
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER=$($PSQL "INSERT INTO customers (phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi
  echo -e "\nWhat time would you like your $SERVICE_SELECTED, $CUSTOMER_NAME?"
  read SERVICE_TIME
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments (service_id, customer_id, time) VALUES ($SERVICE_ID_SELECTED, $CUSTOMER_ID, '$SERVICE_TIME')")
  echo -e "\nI have put you down for a $SERVICE_SELECTED at $SERVICE_TIME, $CUSTOMER_NAME."
fi
