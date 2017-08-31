#read-record.s

#INPUT: The file descriptor and a buffer
#OUTPUT: This function writes the data to the buffer and returns a status code

.include "record-def.s"
.include "linux.s"

#Stack Procedural Parameters
.equ ST_READ_BUFFER, 8
.equ ST_FILEDES, 12

.section .text
.globl read_record
.type read_record, @function
read_record:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    movl $SYS_READ, %eax
    movl ST_FILEDES(%ebp), %ebx
    movl ST_READ_BUFFER(%ebp), %ecx
    movl $RECORD_SIZE, %edx
    int $LINUX_SYSCALL
    #OK
    popl %ebx
    movl %ebp, %esp
    popl %ebp
    ret
