mtype = { Welcome, CardIn, PinEntered, PinAccepted, PrepareMoney, CardReturned, 
            Check, Abort, Passed, Failed, DBIdle, DBEntry};

//Pin enterd by user is true or false
bool pin_check = false;

//chanel 
chan ch_pinCheck = [0] of {byte}; // Channel for simulating PIN check communication
chan ch_log = [0] of {byte}; // Channel for logging

proctype InsertCard() {
    mtype state = Welcome;
    do
    :: state == Welcome -> 
        printf("Welcome to ATM\n");              
        printf("Please insert Card\n");
        state = CardIn;
    
    :: state == CardIn -> 
        printf("Card inserted\n");
        atomic{
            state = PinEntered;
        }
         
    :: state == PinEntered -> printf("Pin Entered\n");
        if
        ::ch_pinCheck ? 1 -> atomic{
            state = PinAccepted;
        }    
        ::ch_pinCheck ? 0 -> atomic{
            state = Abort;
        }
        fi
    :: state == PinAccepted -> 
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
    
    do
    :: state == Check ->
        printf("Please Enter Pin\n");
        //Read PIN input
        if
        :: pin_check -> 
            printf("Pin Accepted\n");
            state = Passed;
        :: pin_check == false -> 
            printf("Pin Rejected\n");
            state = Failed;
        fi

    :: state == Passed -> 
        printf("Card eject\n");
        atomic{
            ch_pinCheck ! 1;
        }
        break

    :: state == Failed ->
        printf("Card eject\n");
        atomic{
            ch_log ! 1;
            ch_pinCheck ! 0;
            break;
        }
    od
}

proctype Database() {
    mtype state = DBIdle;
    printf("Database is in Idle\n");
    do
    :: ch_log ? 1->
        atomic {
            printf("Reject\n");
            state = DBEntry;
            printf("Data stored\n");
        }
    :: state == DBEntry ->
        printf("Reject Card\n");
        ch_log ! 0;
        atomic {
            state = DBIdle;
            break;
        }
    od


}

init {
    run InsertCard();
    run EnterPIN();
    run Database();
}

