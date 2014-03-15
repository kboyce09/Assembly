*----------------------------------------------------------------------
* Programmer: Kyle Boyce
* Class Account: masc1370
* Assignment or Title: project 2
* Filename: prog2.s
* Date completed: 10/31/2012
*----------------------------------------------------------------------
* Problem statement: Find the day of the week given any date from years 1800-9999
* Input: A date (mm/dd/yyyy)
* Output: The day of the week for that exact date
* Error conditions tested: None
* Included files: None
* Method and/or pseudocode:
*
* Display title heading and prompt user input.
*
* VARIABLES:
* Read from the keyboard:
* month
* day
* year
*
* Calculated:
* a = (14-month)/12
* y = year - a
* m = month + 12a - 2
* d = (day + y + y/4 - y/100 + y/400 + 31m/12) mod 7
*
* Display day of the week to user.
*
*
* References: http://pindar.sdsu.edu/cs237/prog2.php
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
* D0 holds copies of y
* D1 Stores two's complement value of year
* D2 Stores two's complement value of day
* D3 Stores two's complement value of month
* D4 Stores the value of a
* D5 Stores the value of y
* D6 Stores the value of m
* D7 Stores the value of d
* A1 Contains the correct day of the week
*
*----------------------------------------------------------------------
*
start:  initIO                  * Initialize (required for I/O)
        setEVT                  * Error handling routines
*       initF                   * For floating point macros only

*** Outputs content at title, skipln, and prompt
        lineout     title
        lineout     skipln
        lineout     prompt
        linein      buffer      * Places the user input in memory starting at buffer

*** Converts the year into a two's complement number and puts it in D1
        cvta2       buffer+6,#4
        move.l      D0,D1

*** Converts the day into a two's complement number and puts it in D2
        cvta2       buffer+3,#2
        move.l      D0,D2

*** Converts the month into a two's complement number and puts it in D3
        cvta2       buffer,#2
        move.l      D0,D3

*** a = (14 - month) / 12 ---> D4
        move.l      #14,D4
        sub.l       D3,D4       * (14 - month)
        ext.l       D4          * Extends the word portion in register into long
        divs        #12,D4      * a ---> D4 with size word

*** y = year - a ---> D5
        move.w      D1,D5       * Makes a copy of the year into D5
        sub.w       D4,D5       * y ---> D5

*** m = month + 12a - 2 ---> D6
        move.w      D4,D6       * Makes a copy of a into D6
        muls        #12,D6      * Multiplies 12 by the copy of a in D6
        add.w       D3,D6       * adds the month to D6
        subq.w      #2,D6       * m ---> D6

*** d = (day + y + y/4 - y/100 + y/400 + 31m/12) mod 7
        move.l      D5,D7       * Makes a copy of y into D7
        ext.l       D7
        divs        #4,D7       * D7 ---> (y/4)
        add.w       D5,D7       * Adds y to D7
        add.w       D2,D7       * Adds day to D7
        move.l      D5,D0       * Makes a copy of y into D0
        ext.l       D0
        divs        #100,D0     * D0 ---> (y/100)
        sub.w       D0,D7       * D7 - D0 or (day + y + y/4) - (y/100)
        move.l      D5,D0       * Copies y back again into D0
        ext.l       D0
        divs        #400,D0     * D0 ---> (y/400)
        add.w       D0,D7       * D7 + D0 or (day + y + y/4 - y/100) + (y/400)
        muls        #31,D6      * Multiply m by 31
        ext.l       D6
        divs        #12,D6      * D6 ---> ((31m)/12)
        add.w       D6,D7
        ext.l       D7
        divs        #7,D7
        swap        D7          * Swaps the remainder and quotient parts of D7

        lea         days,A1     * Loads the address of days into A1

*** Moves the pointer to the address in A1 that contains the correct day of the week
        muls        #12,D7      * Multiplies 12 by the remainder in D7
        adda.l      D7,A1       * A1 = The starting address of the correct day

*** Copies the contents at A1 in chunks of size word into day,day+4,day+8
        move.l      (A1)+,day
        move.l      (A1)+,day+4
        move.l      (A1),day+8

        lineout     answer      * Outputs the answer line with the correct day



        break                   * Terminate execution
*
*----------------------------------------------------------------------
*       Storage declarations
skip:   dc.b        0           * Needed to make addresses even
title:  dc.b        'Program #2, Kyle Boyce, masc1370',0
skipln: dc.b        0
prompt: dc.b        'Please enter a date (mm/dd/yyyy):',0
buffer: ds.b        80                  * Mandatory amount for input
answer: dc.b        'The day of the week is '
day:    ds.b        12
days:   dc.b        'Sunday.    ',0     * Array containing the days of the week
        dc.b        'Monday.    ',0
        dc.b        'Tuesday.   ',0
        dc.b        'Wednesday. ',0
        dc.b        'Thursday.  ',0
        dc.b        'Friday.    ',0
        dc.b        'Saturday.  ',0

        end