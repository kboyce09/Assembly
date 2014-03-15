*----------------------------------------------------------------------
* Programmer: Kyle Boyce
* Class Account: masc1370
* Assignment or Title: Program 3
* Filename: prog3.s
* Date completed:  November 19,2012
*----------------------------------------------------------------------
* Problem statement: Determine the optimum dimensions of a closed cylindrical can
* Input: The cost of the end material in dollars/cm^2, The cost of the side material
* in dollars/cm^2, and the volume of the can in mililiters
* Output: can cost, diameter of the can, and height of the can using both a brute
* force and calculus method
* Error conditions tested: None
* Included files: None
* Method and/or pseudocode:
* Take in User input
*
* Use radius = (((volume*side_cost)/(2*PI*end_cost))^(1/3) for the calculus method
* Then use these formulas and values provided on site to find diameter, height, and
* end cost
*
* Print those results and move on to the Brute Force Method
*
* Set radius to 0.01
* Calculate to the end cost and store that value, then create a loop that calculates
* to the end cost and compares the New_Cost to the Old_Cost and if the New_Cost is
* greater branch out of loop, otherwise set New_Cost as Old_Cost and loop.
*
* After the correct radius is found calculate the height, diameter, and can cost and print them.
* References: http://pindar.sdsu.edu/cs237/prog3.php
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

********** CONSTANTS **********
TWO:           EQU    $40000000
PI:            EQU    $40490FDA
ONE_THIRD:     EQU    $3EAAAAAb
ONE_HUNDRETH:  EQU    $3C23D70A
*******************************

start:  initIO                  * Initialize (required for I/O)
        initF
        setEVT
        lineout  title
        lineout  skipln
        lineout  p1
        floatin  buffer
        cvtaf    buffer,D5   * END cost
        lineout  p2
        floatin  buffer
        cvtaf    buffer,D6   * SIDE cost
        lineout  p3
        floatin  buffer
        cvtaf    buffer,D7   * VOLUME

**********************************************************************
** Calculus Answer
** Formula for the radius of the optimum can:
** radius = (((volume*side_cost)/(2*PI*end_cost))^(1/3)

** numerator, volume*side_cost:
        move.l      D7,D1       * VOLUME
        fmul        D6,D1       * VOLUME*SIDE_COST

** denominator, 2*PI*end_cost
        move.l      D5,D2       * END_COST
        fmul        #TWO,D2     * END_COST * 2.0
        fmul        #PI,D2      * END_COST * 2.0 * PI

** now take result to 1/3 power
        fdiv        D2,D1        * numerator/denominator
        move.l      #ONE_THIRD,D0
        fpow        D1,D0 *(numerator/denominator) ^ (1/3)

** Calulus answer done, now calculate diameter, height, cost
        move.l      D0,D1       * D1 has radius
        fmul        #TWO,D0     * D0 has diameter
        cvtfa       diameter,#2

** calculate height = (volume / PI*r^2)
        move.l      D1,D2       * radius
        fmul        D2,D2       * radius^2
        fmul        #PI,D2      * radius^2*PI
        move.l      D7,D3       * copy of volume
        fdiv        D2,D3       * vol / PI*radius^2  HEIGHT --> D3
        move.l      D3,D0
        cvtfa       height,#2

** calculate cost = SIDE_COST*SIDE_SURFACE + 2*END_COST*END_SURFACE
        *** side cost:
        move.l      #PI,D2
        fmul        #TWO,D2     * 2*PI
        fmul        D1,D2       * 2*PI*radius
        fmul        D3,D2       * 2*PI*radius*height  = side surface area
        fmul        D6,D2       * side surface area * SIDE_COST

        *** end cost:
        move.l      #PI,D0
        fmul        #TWO,D0     * 2*PI
        fmul        D1,D0       * 2*PI*radius
        fmul        D1,D0       * 2*PI*radius*radius
        fmul        D5,D0       * 2*PI*radius*radius*END_COST
        fadd        D2,D0
        cvtfa       cost,#2

** DONE, print the  calculus answer
        lineout     skipln
        lineout     calculus
        lineout     ans1
        lineout     ans2
        lineout     ans3

**********************************************************************
*** ADD YOUR CODE HERE FOR THE BRUTE FORCE ANSWER
*** Register usage:
*** D0 ->  Stores PI and is used to store temporary values for conversion
*** D1 ->  radius
*** D2 ->  New_Cost
*** D3 ->  HEIGHT
*** D4 ->  Old_Cost
*** D5 ->  END_COST
*** D6 ->  SIDE_COST
*** D7 ->  VOLUME

** Set starting radius
        move.l      #ONE_HUNDRETH,D1

** calculate height = (volume / PI*r^2)
        move.l      D1,D2       * radius
        fmul        D2,D2       * radius^2
        fmul        #PI,D2      * radius^2*PI
        move.l      D7,D3       * copy of volume
        fdiv        D2,D3       * vol / PI*radius^2  HEIGHT --> D3


** calculate cost = SIDE_COST*SIDE_SURFACE + 2*END_COST*END_SURFACE
        *** side cost:
        move.l      #PI,D2
        fmul        #TWO,D2     * 2*PI
        fmul        D1,D2       * 2*PI*radius
        fmul        D3,D2       * 2*PI*radius*height  = side surface area
        fmul        D6,D2       * side surface area * SIDE_COST

        *** end cost:
        move.l      #PI,D0
        fmul        #TWO,D0     * 2*PI
        fmul        D1,D0       * 2*PI*radius
        fmul        D1,D0       * 2*PI*radius*radius
        fmul        D5,D0       * 2*PI*radius*radius*END_COST
        fadd        D2,D0
        move.l      D0,D4

do:
        fadd        #ONE_HUNDRETH,D1 * increment radius by 0.01

** calculate height = (volume / PI*r^2)
        move.l      D1,D2       * radius
        fmul        D2,D2       * radius^2
        fmul        #PI,D2      * radius^2*PI
        move.l      D7,D3       * copy of volume
        fdiv        D2,D3       * vol / PI*radius^2  HEIGHT --> D3

** calculate cost = SIDE_COST*SIDE_SURFACE + 2*END_COST*END_SURFACE
        *** side cost:
        move.l      #PI,D2
        fmul        #TWO,D2     * 2*PI
        fmul        D1,D2       * 2*PI*radius
        fmul        D3,D2       * 2*PI*radius*height  = side surface area
        fmul        D6,D2       * side surface area * SIDE_COST

        *** end cost:
        move.l      #PI,D0
        fmul        #TWO,D0     * 2*PI
        fmul        D1,D0       * 2*PI*radius
        fmul        D1,D0       * 2*PI*radius*radius
        fmul        D5,D0       * 2*PI*radius*radius*END_COST
        fadd        D0,D2       * D2 ---> New_Cost

        fcmp        D4,D2       * Compares Old_Cost with New_Cost and sets the CCR
        BGT         done        * If New_Cost is greater than Old_Cost code branches to done
        move.l      D2,D4       * Copies New_Cost into Old_Cost
        BRA         do          * Always branches to do

done:
        fsub        #ONE_HUNDRETH,D1    * Corrects an off by one error of radius

        move.l      D1,D0
        fmul        #TWO,D0     * D0 has diameter
        cvtfa       diameter,#2

** calculate height = (volume / PI*r^2)
        move.l      D1,D2       * radius
        fmul        D2,D2       * radius^2
        fmul        #PI,D2      * radius^2*PI
        move.l      D7,D3       * copy of volume
        fdiv        D2,D3       * vol / PI*radius^2  HEIGHT --> D3
        move.l      D3,D0
        cvtfa       height,#2

        move.l      D4,D0       * D0 ---> Old_Cost which is the correct cost
        cvtfa       cost,#2

** DONE, Print the Brute Force answer
        lineout     skipln
        lineout     brute
        lineout     ans1
        lineout     ans2
        lineout     ans3

        break
**********************************************************************

title:    dc.b    'Program 3, masc1370, Kyle Boyce',0
skipln:   dc.b    0
buffer:   ds.b    80
p1:       dc.b    'Please enter the cost of the end material in dollars/cm^2:',0
p2:       dc.b    'Please enter the cost of the side material in dollars/cm^2:',0
p3:       dc.b    'Please enter the volume of the can in milliliters:',0
calculus: dc.b    'Calculus Answer:',0
brute:    dc.b    'Brute Force Answer:',0
ans1:     dc.b    'Can cost: '
cost:     ds.b    40
ans2:     dc.b    'Diameter: '
diameter: ds.b    40
ans3:     dc.b    'Height: '
height:   ds.b    40
          end