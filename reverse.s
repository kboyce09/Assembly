*----------------------------------------------------------------------
* Programmer: Kyle Boyce
* Class Account: masc1370
* Filename: reverse.s
* Date completed: 12/9/2012
*----------------------------------------------------------------------
* Method and/or pseudocode:
*  void reverse(char *in, char *out, int count) {
*    if(count == 0)
*        return;
*    reverse(in+1,out,--count);
*    *(out+count) = *in;
*    }
*----------------------------------------------------------------------
          ORG     $7000           * Start at location 7000 Hex

reverse:  link      A6,#0               * Places Old A6 onto the stack
          movem.l   A0-A2/D1,-(SP)      * Places saved registers on stack

*** Retrieves parameters from the system stack and places them in registers
          move.l    8(A6),A1            * in ---> A1
          move.l    12(A6),A2           * out ---> A2
          move.w    16(A6),D1           * count ---> D1

*** Checks if (count==0), and branches if true(return;)
          tst.w     D1
          BMI       done

          movea.l   A1,A0               * Places copy of A1 ---> A0
          addq.l    #1,A0               * (in+1)
          subq.w    #1,D1               * (--count)

*** Places new parameters onto the stack
          move.w    D1,-(SP)
          pea       (A2)
          pea       (A0)

*** Recursive subroutine call to jump to reverse
          JSR       reverse

*** "Pops" parameters(10 bytes) off the stack
          adda.l    #10,SP

          ext.l     D1                  * Extends the word in D1(count) to a longword
          adda.l    D1,A2
          move.b    (A1),(A2)           * Places the byte now in A1 into the byte at A2
done:     movem.l   (SP)+,A0-A2/D1      * Removes saved registers from the stack
          unlk      A6                  * Removes Old A6 from the stack
          rts                           * Removes return address from stack after returning from subroutine
          end
*----------------------------------------------------------------------