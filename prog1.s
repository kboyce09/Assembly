*----------------------------------------------------------------------
* Programmer: Kyle Boyce
* Class Account: masc1370
* Assignment or Title: Program #1
* Filename: prog1.s
* Date completed: 10/14/2012
*----------------------------------------------------------------------
* Problem statement: Find someone's age in 2012.
* Input: User date of birth
* Output: Their age in 2012
* Error conditions tested: None
* Included files: None
* Method and/or pseudocode: None
* References: None
*----------------------------------------------------------------------
*
        ORG     $0
        DC.L    $3000           * Stack pointer value after a reset
        DC.L    start           * Program counter value after a reset
        ORG     $3000           * Start at location 3000 Hex
*
*----------------------------------------------------------------------
*
#minclude /home/ma/cs237/bsvc/iomacs.s
#minclude /home/ma/cs237/bsvc/evtmacs.s
*
*----------------------------------------------------------------------
*
* Register use
* D0 macro usage and holds 2012 for calculation
* D1 holds user's date of birth year
* A0 holds the address age
* A1 holds address of stars+35
*
*----------------------------------------------------------------------
*
start:  initIO                          * Initialize (required for I/O)
        setEVT                          * Error handling routines
*       initF                           * For floating point macros only

        lineout         title           * Prints contents at the address
        lineout         skipln
        lineout         prompt
        linein          buffer          * Stores user input from keyboard at this address
        cvta2           buffer+6,#4     * Takes first 4 bytes at address and converts to two's complement
        move.l          D0,D1
        move.l          #2012,D0
        sub.l           D1,D0           * Subtracts 2012 - (User Entered Year)
        cvt2a           age,#3
        stripp          age,#3
        lea             age,A0
        adda.l          D0,A0           * Increments A0 by amount in D0
        move.b          #' ',(A0)+      * Increments the address register to complete the string
        move.b          #'y',(A0)+
        move.b          #'e',(A0)+
        move.b          #'a',(A0)+
        move.b          #'r',(A0)+
        move.b          #'s',(A0)+
        move.b          #' ',(A0)+
        move.b          #'o',(A0)+
        move.b          #'l',(A0)+
        move.b          #'d',(A0)+
        move.b          #'.',(A0)+
        move.b          #' ',(A0)+
        move.b          #'*',(A0)+
        clr.b           (A0)            * Null terminates the string
        lea             stars+35,A1
        adda.l          D0,A1
        clr.b           (A1)
        lineout         stars
        lineout         answer
        lineout         stars
        move.b          #'*',(A1)       * Replaces '*' that gets null terminated


        break                   * Terminate execution
*
*----------------------------------------------------------------------
*       Storage declarations

buffer:         ds.b            80
title:          dc.b            'Program #1, Kyle Boyce, masc1370',0
skipln:         dc.b            0
prompt:         dc.b            'Enter your date of birth (MM/DD/YYYY):',0
answer:         dc.b            '* In 2012 you will be '
age:            ds.b            20
stars:          dcb.b           40,'*'
        end