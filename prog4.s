*----------------------------------------------------------------------
* Programmer: Kyle Boyce
* Class Account: masc1370
* Assignment or Title: Program #4
* Filename: prog4.s
* Date completed: 12/9/2012
*----------------------------------------------------------------------
* Problem statement: Take a string inputted by the user and reverse the string.
* Input: A string
* Output: The string reversed
* Error conditions tested: None
* Included files: None
* Method and/or pseudocode:
*  Load Point:
*  $7000
*
*  Parameters:
*
*  char &in      The starting address of the string entered by the user.
*  char &out     The starting address of the memory location where the reversed string is to be written.
*  int count     The number of characters in the string to be reversed.
*
*
*  Print the heading and the prompt.
*  Store the user input in memory.
*
*  Place parameters on stack for subroutine and call the subroutine.
*  Upon return from the subroutine pop off original parameters.
*  Null terminate the string.
*
*  Print the string reversed.
* References: http://pindar.sdsu.edu/cs237/prog4.php
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
* D0 ---> length of string(count)
* A0 ---> Uses address of revstring to null terminate the reversed string
*
*----------------------------------------------------------------------
*
reverse: EQU            $7000
start:  initIO                          * Initialize (required for I/O)
        setEVT                          * Error handling routines
*       initF                           * For floating point macros only

        lineout         title
        lineout         prompt
        linein          buffer

*** Places parameters on the stack and moves the stack pointer
        move.w          D0,-(SP)        * count
        pea             revstr          * out
        pea             buffer          * in

*** Jumps to the reverse subroutine
        JSR             reverse

*** "Pops" the starting parameters(10 bytes) off the stack
        adda.l          #10,SP

        movea.l         #revstr,A0
        adda.l          D0,A0           * Sets A0 to the end of the reversed string
        clr.b           (A0)            * Null terminates string
        lineout         answer
        lineout         revstr


        break                           * Terminate execution
*
*----------------------------------------------------------------------
*       Storage declarations

title:          dc.b    'Program #4, Kyle Boyce, masc1370',0
prompt:         dc.b    'Enter a string:',0
buffer:         ds.b    82
answer:         dc.b    'Here is the string backwards:',0
revstr:         ds.b    82

        end