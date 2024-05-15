mtype = { Welcome, CardIn, PinEntered, PinAccepted, PrepareMoney, CardReturned, 
            Check, Abort, Passed, Failed, DBIdle, DBEntry};
byte entered_pin = 123;
byte store_pin = 1234;

proctype InsertCard() {
    mtype state = Welcome;
    do
    :: state == Welcome -> 
        printf("Welcome to ATM\n");              
        atomic{
            printf("Please insert Card\n");
            state = CardIn;
        }
    :: state == CardIn -> 
        printf("Card inserted\n");
        atomic{
            printf("Please Enter pin\n");
            state = PinEntered;
        }
         
    :: state == PinEntered -> printf("Pin Entered\n");
        if
        ::true -> atomic{
            printf("Pin Accepted\n");
            state = PinAccepted;
        }    
        ::false -> atomic{
            printf("Pin Rejected\n");
            state = Abort;
        }
        fi
    :: state == PinAccepted -> printf("Pin Accepted\n");
        atomic{
            printf("Please take your money\n");
            state = PrepareMoney; 
        } 

    :: state == Abort -> printf("Transaction Aborted\n");
        atomic{
            printf("Please take your card\n");
            state = CardReturned; 
        }    

    :: state == PrepareMoney -> printf("Prepare Money: Money prepared\n");
        atomic{
            printf("Card eject, Please take your card\n");
            state = CardReturned; 
        }
    :: state == CardReturned -> printf("Card Returned\n");
        break;
    od

}

proctype EnterPIN() {
    mtype state = Check;
    bool pin_check = false;

    do
    :: state == Check ->
        printf("Please Enter Pin\n");

        //Read PIN input
        //Check pin
        //pin_check = (entered_pin == store_pin);
        
        if
        :: pin_check -> state = Passed;
        :: !pin_check -> state = Failed;
        fi

    :: state == Passed -> 
        printf("Pin Accepted\n");
        atomic {
            printf("Card eject\n");
            //state = Check;
            break;
        }

    :: state == Failed ->
        printf("Pin Rejected\n");
        atomic {
            printf("Card eject\n");
            //state = Check;
            break;
        }

    od
}

proctype Database() {
    mtype state = DBIdle;

    do
    :: state == DBIdle ->
        atomic {
            state = DBEntry;
        }
    :: state == DBEntry ->
        atomic {
            state = DBIdle;
        }
    od


}

init {
    //run InsertCard();
    run EnterPIN();
    //run Database();
}

