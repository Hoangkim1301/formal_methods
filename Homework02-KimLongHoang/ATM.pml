mtype = { Welcome, CardIn, PinEntered, PinAccepted, PrepareMoney, CardReturned, 
            Check, Abort, Passed, Failed, DBIdle, DBEntry};

active proctype InsertCard() {
    mtype state = Welcome;
    do
    :: state == Welcome -> printf("Welcome to ATM\n");              
        atomic{
            printf("Please insert Card\n");
            state = CardIn;
        }
    :: state == CardIn -> printf("Card inserted\n");
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

active proctype EnterPIN() {
    mtype state = Check;

    do
    :: state == Check ->
        if
        :: true -> atomic {
            state = Passed;
        }
        :: true -> atomic {
            state = Failed;
        }
        fi
    od
}

active proctype Database() {
    mtype state = DBIdle;

    do
    :: state == DBIdle ->
        atomic {
            state = DBEntry;
        }
    od


}

init {
    run InsertCard();
    run EnterPIN();
    run Database();
}

