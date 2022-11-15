# cs64Lab06
Homework buddy: Oscar Benedek

1. Explain what you think the MIPs code is doing in a paragraph (3+ lines). Sufficiently summarizing what’s happening in your MIPs code’s disaggregate function is what we expect. Do not guess what the C/C++ code is doing. (5 points)

I think that the MIPS code is taking in an array of length 10 and recursively splitting it into two smaller arrays at each depth level, the first array containing values that are smaller than the average and the second array containing values that are larger than the average. In the MIPS code, you store certain values on the stack that are needed so that when you return from one depth level/recursive call, you can use the original values in the rest of the code. These values are the starting point for the array, the length of the array, the depth you are currently at, the buffer array where the small/big array values are stored, the starting address for the small/big array and the return address. In the disaggregate function after storing these values, the code will loop through the values in the array and sum them, then calculate the average value. It will then loop through the array again adding the values that are bigger/smaller to seperate arrays within the large buffer array, keeping track of the length. The code will then move the values needed for the sub calls into the saved registers and make the recursive call to the function, ultimately splitting up the array into smaller/bigger by depth.


2. Will the space used in the stack change with change in array length or change in array values? Or change in depth value? Why or why not? (5 points)


The space used in the stack will only change when the original input depth value changes. This is because with each depth value, the number of times that new memory is allocated on the stack grows by a factor of two (i.e. with depth level 0 --> 36 bits of memory allocated once, depth level 1 --> 36 bits of memory allcated twice, depth level 2 --> 36 bits of memory allocated four times, etc.). Change in array length and array values will not affect the space used in the stack because not all the values are stored on the stack, only a pointer to the address of the memory is stored, therefore, it doesn't matter how many values or what values are contained within the array.



