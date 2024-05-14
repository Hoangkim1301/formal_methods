active proctype fns()
{	/*
	 * don't call this rand()...
	 * to avoid a clash with the C library routine
	 */
	byte n ;	/* Start with 3 */
	do
	    :: n = 3; 
	    :: n = 4;
        :: n = 5;
        :: n = 6;
        :: n = 7;
        :: n = 8;
        :: n = 9;
        :: n = 10; 
	    :: break	/* or stop            */
	od;

    printf("n = %d\n", n);

    int result = 0;
    int temp = 0;
    if
    :: n == 3 -> 
        do 
        :: result = n * n + temp;
                temp = result;
                n = n - 1;
            if
            :: n > 0 -> skip;
            :: else -> break;  
            fi;
        od
    :: n != 3 -> result = ( n * ( n + 1) * ( 2 * n + 1 ) ) / 6;
    fi;
    printf("result = %d\n", result);
}