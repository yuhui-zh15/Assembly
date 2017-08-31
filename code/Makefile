main: main.o read-record.o write-record.o
	ld -m elf_i386 -o main main.o read-record.o write-record.o
read-record.o: read-record.s
	as --32 -o $@ $?
write-record.o: write-record.s
	as --32 -o $@ $?
main.o: main.s
	as --32 -o $@ $?
clean:
	rm -f *.o main
