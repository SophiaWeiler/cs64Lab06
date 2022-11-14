.data
#DO NOT CHANGE
buffer: .word 0:100
array: .word 9 1 2 1 17 19 10 9 11 10
newline: .asciiz "\n"
comma: .asciiz ", "
convention: .asciiz "Convention Check\n"
depth: .asciiz "depth "
colon: .asciiz ":"

.text
    main:
        la $a0 array #the input array
        li $a1 2 #depth: number of times you need to split an array
        la $a2 buffer #the buffer array address
        li $a3 10 #array length        
        move $s0, $a0
        move $s1, $a1
        move $s2, $a2
        move $s3, $a3
        ori $s4, $0, 0
        ori $s5, $0, 0

        jal disaggregate

        j exit
    
    disaggregate:
        addiu $sp, $sp, -28 #?? = the negative of how many values we store in (stack * 4)
        
        #store all required values that need to be preserved across function calls
        
        #store array address on stack
        sw $s0 0($sp)
        #store n (depth) on stack
        sw $s0 4($sp)
        #store buffer pointer on stack
        sw $s2 8($sp)
        #store length of array on stack
        sw $s3 12($sp)

        #Since our array_len parameter becomes small/big array len
        #We need them to be what they were before the next recursive call!

        #store small array length on stack
        sw $s4 16($sp)
        #store big array length on stack
        sw $s5 20($sp)

        #multiple function calls overwrite ra, therefore must be preserved
        #store return address
        sw $ra 24($sp)

        #print depth value, according to expected format
        la $a0, depth    
        li $v0, 4
        syscall
        li $v0, 1
        move $a0, $s1
        syscall
        la $a0, colon    
        li $v0, 4
        syscall
        
        #Don't forget to define your variables!

        #It's dangerous to go alone, take this one loop for free
        #please enjoy and use carefully
        #this code makes no assumptions on your code
        #fix this code to work with yours or vice versa
        #don't have to use this loop either can make your own too

        #$t0 --> address of the input array
        add $t0 $0 $s0
        #$t7 --> counter for the loop set to 0
        li $t7 0
        #$t2 --> sum value set to 0 
        li $t2 0
        
        loop:
            #find sum
            bge $t7, $s3, func_check #this is the loop exit condition
            lw $t6, 0($t0)
            
            #print array entry
            li $v0, 1
            move $a0, $t6
            syscall

            #move the value back into $t6 to add to sum (I PUT THIS IN)
            move $t6 $a0

            li $v0, 4
            la $a0, comma
            syscall
            
            addi $t0, $t0, 4
            addi $t7, $t7, 1
            add $t2, $t2, $t6
            j loop

        func_check:
            #Add the recursive function end condition
            #Needs to exist so that we don't end up recursing to infinity!
            #This is the recursive equivalent to our iteration condition
            #for example the i < 10 in a for/while loop
            #We have two recursive conditions: depth == 0, arr_len == 1
            #They are OR'd in the C/C++ template
            #Do you need to OR them in MIPs too? 
            li $t3 1
            ble $s1 $0 function_end
            ble $s3 $t3 function_end
            
        #calculate the average 
        div $t2, $s3 
        mflo $t3 #avg 


        #address for the start of small array
        add $t1 $s2 $0

        #counter for length of small array
        li $t0 0

        #counter for length of big array
        li $t6 0

        #address for the start of big array
        addi $t4 $s2 40

        #$t7 --> counter for the loop set to 0
        li $t7 0

        #main loop
        loop2:
            #find big and small array
            #Remember the conditions for splitting
            #if entry <= average put in small array
            #if entry > average put in big array

            #break if the counter is equal to array length
            ble $t7 $s3 closing
            
            lw $t5 0($s0)
            
            ble $t5 $t3 smallArr

            sw $t5 0($t4)

            addiu $t4 $t4 4
            addiu $t7 $t7 1
            addiu $s0 $s0 4
            addi $t6 $t6 1

            j loop2
            
            
        #condition if the value is meant to go into the small array
        smallArr:
            sw $t5 0($t1)
            addiu $t1 $t1 4
            addiu $t7 $t7 1
            addiu $s0 $s0 4
            addi $t0 $t0 1
            j loop2

        closing:
        #This is the section where we prepare to call the function recursively.
        
            move $s4, $t0 #save the small array length value 
            move $s5, $t6 #save the big array length value

            #for $s0 reset
            #determining how many spaces it has moved over and then multiplying by -4
            add $t0 $s4 $s5
            li $t6 -4
            mult $t0 $t6
            mflo $t0
            #resetting the $s0 pointer value by that much
            add $s0 $s0 $t0 

            #starting address of small array move into stored variable
            #for $t1 reset (address of small array)
            #determining how many spaces it has moved over and then multiplying by -4
            add $t0 $t1 $0
            li $t6 -4
            mult $t0 $t6
            mflo $t0
            #resetting the $s0 pointer value by that much and storing it in $s0
            add $s6 $s0 $t0 

            #starting address of big array move into stored variable
            #for $t1 reset (address of small array)
            #determining how many spaces it has moved over and then multiplying by -4
            add $t0 $t1 $0
            li $t6 -4
            mult $t0 $t6
            mflo $t0
            #resetting the $s0 pointer value by that much and storing it in $s0
            add $s7 $s0 $t0 

            #updating the depth for both the small and the big array
            addi $s1 -1


            jal ConventionCheck #DO NOT REMOVE 

            #Make sure your $s registers have the correct values before calling
            #Remember we recursively call with small array first
            #So load small array arguments in $s registers
            
            #This is updating the buffer so that we don't overwrite our old values
            addi $s2, $s2, 80
            
            #We call small array first so we load small array length as arr_len
            move $s3, $s4 
            
            

            #move stored value of small array from $s6 to $s0 for function call
            move $s0 $s6

            jal disaggregate

            jal ConventionCheck #DO NOT REMOVE
            
            #Similarly for big array, we mirror the call structure of small array as above
            #But with the values appropriate for big array. 

            addi $s2, $s2, 80
            move $s3, $s5 #big array call second
            #move stored value of big array from $s7 to $s0 for function call
            move $s0 $s7

        
            
            jal disaggregate

            j function_end
        
        function_end:
        #Here we reset our values from previous iterations
        #Be careful on which values you load before and after the $sp update if you have to 
        #We can accidentally end up loading values of current calls instead of previous calls
        #Manually drawing out the stack changes helps figure this step out
            
            #Load values before update if you have to
            lw $s0 0($sp)
            lw $s0 4($sp)
            lw $s2 8($sp)
            lw $s3 12($sp)
            lw $s4 16($sp)
            lw $s5 20($sp)
            lw $ra 24($sp)
            
            addiu $sp, $sp, 28 # the positive of how many values we store in (stack * 4)
            #Load values after update if you have to
    
    exit:
        li $v0, 10
        syscall

ConventionCheck:  
#DO NOT CHANGE AUTOGRADER USES THIS  
    #reset all temporary values
    addi    $t0, $0, -1
    addi    $t1, $0, -1
    addi    $t2, $0, -1
    addi    $t3, $0, -1
    addi    $t4, $0, -1
    addi    $t5, $0, -1
    addi    $t6, $0, -1
    addi    $t7, $0, -1
    ori     $v0, $0, 4
    la      $a0, convention
    syscall
    addi    $v0, $zero, -1
    addi    $v1, $zero, -1
    addi    $a0, $zero, -1
    addi    $a1, $zero, -1
    addi    $a2, $zero, -1
    addi    $a3, $zero, -1
    addi    $k0, $zero, -1
    addi    $k1, $zero, -1
    jr      $ra
