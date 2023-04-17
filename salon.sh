#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n ~~~~~ MY SALON ~~~~~ \n"
echo -e "Welcome to My Salon, how can I help you?\n"
MENU() {
SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
do 
echo "$SERVICE_ID) $SERVICE_NAME" 
done
read SERVICE_ID_SELECTED
if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then 
  MENU
  else
  SERVICE_NAME_SELECTED=$($PSQL --username=freecodecamp --dbname=salon -c "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")
  if [[ -z $SERVICE_NAME_SELECTED ]]
    then
    echo -e "\nI could not find that service. What would you like today?"
    MENU
    else 
    #promt for phone
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    #get name
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    if [[ -z $CUSTOMER_NAME ]]
      then
      #add customer
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME
      NAME_ADD=$($PSQL "INSERT INTO customers(phone, name) VALUES ('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
    fi
      #get time
      echo -e "\nWhat time would you like your$SERVICE_NAME_SELECTED, $CUSTOMER_NAME"
      read SERVICE_TIME
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE' ")
      APPOINTMENT_RECORD=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
      echo -e "\nI have put you down for a$SERVICE_NAME_SELECTED at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
fi

}

MENU
