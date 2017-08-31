#read-records.s
#the main program

.include "linux.s"
.include "record-def.s"

.section .data
input_file_name:
    .ascii "test.dat\0"
output_file_name:
    .ascii "test_out.dat\0"
.section .bss
    .lcomm record_buffer, RECORD_SIZE
.equ ST_INPUT_DESCRIPTOR, -4 #These are the locations on the stack 
.equ ST_OUTPUT_DESCRIPTOR, -8 #where we will store the descriptors

.section .text
.globl _start
_start:
    movl %esp, %ebp
    subl $8, %esp #Allocate space to hold the descriptors
open_fd_in:
    movl $SYS_OPEN, %eax
    movl $input_file_name, %ebx
    movl $O_RDONLY, %ecx #This says to open read-only
    movl $O_PERMISSION, %edx 
    int $LINUX_SYSCALL #Open the input file
store_fd_in:
    movl %eax, ST_INPUT_DESCRIPTOR(%ebp) #Save file descriptor
open_fd_out:
    movl $SYS_OPEN, %eax
    movl $output_file_name, %ebx
    movl $O_CREAT_WRONLY_TRUNC, %ecx #This says to create a new file
    movl $O_PERMISSION, %edx
    int $LINUX_SYSCALL
store_fd_out:
    movl %eax, ST_OUTPUT_DESCRIPTOR(%ebp)
loop_begin:
    #Read record
    pushl ST_INPUT_DESCRIPTOR(%ebp)
    pushl $record_buffer
    call read_record #Get one record
    addl $8, %esp
    cmpl $RECORD_SIZE, %eax
    jne loop_end
    #Increment the age
    movl $RECORD_AGE + record_buffer, %ebx
    incl (%ebx)
    #Write record
    pushl ST_OUTPUT_DESCRIPTOR(%ebp)
    pushl $record_buffer
    call write_record #Save one record
    addl $8, %esp
    jmp loop_begin
loop_end:
    #Close the files
    movl $SYS_CLOSE, %eax
    movl ST_INPUT_DESCRIPTOR(%ebp), %ebx
    int $LINUX_SYSCALL
    movl $SYS_CLOSE, %eax
    movl ST_OUTPUT_DESCRIPTOR(%ebp), %ebx
    int $LINUX_SYSCALL
    #Exit the program
    movl $SYS_EXIT, %eax
    movl $0, %ebx
    int $LINUX_SYSCALL
