# cs64Lab06
Homework buddy: Oscar Benedek

1. Explain what you think the MIPs code is doing in a paragraph (3+ lines). Sufficiently summarizing what’s happening in your MIPs code’s disaggregate function is what we expect. Do not guess what the C/C++ code is doing. (5 points)

I think that the MIPS code is taking in an array of length 10 and recursively splitting it into two smaller arrays at each depth level, the first array containing values that are smaller than the average and the second array containing values that are larger than the average. In the MIPS code, you store certain values on the stack that are needed so that when you return from one depth level/recursive call, you can use the original values in the rest of the code. These values are the starting point for the array, the length of the array, the depth you are currently at, the buffer array where the small/big array values are stored, the starting address for the small/big array and the return address. In the disaggregate function after storing these values, the code will loop through the values in the array and sum them, then calculate the average value. It will then loop through the array again adding the values that are bigger/smaller to seperate arrays within the large buffer array, keeping track of the length. The code will then move the values needed for the sub calls into the saved registers and make the recursive call to the function, ultimately splitting up the array into smaller/bigger by depth.


2. Will the space used in the stack change with change in array length or change in array values? Or change in depth value? Why or why not? (5 points)

The space used in the stack will change when there is a change in the array values that are passed in as the $s0 value (i.e. main array that is being used for the disaggregate function call). This is because, when a new array is created (big/small) it is passed in as the $s0 value for the function call and at the beggining of the function call, memory is allocated on the stack. It is not when there is a change in depth because at the same depth, two different arrays are being used which means the stack changes, therefore it can not be soley reliant on when the depth changes. Also, it is change in array values not change in array length because two arrays of the same length but different values will still cause new memory to be allocated on the stack. Therefore, change in array value is the main cause of the change in the stack because it is the factor that consistenly requires the stack to be updated whereas depth and length have exceptions where they remain the same but the stack data does not. 




