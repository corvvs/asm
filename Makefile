CC			:= gcc
CFLAGS		:= -Wall -Wextra -Werror
ASM			:= nasm
ASMFLAGS	:= -f macho64
NM			:= nm
NMFLAGS		:= -g

%.o: %.asm
	$(ASM) $(ASMFLAGS) $< -o $@

ft_strlen:	test_strlen.o ft_strlen.o
	@echo [Building $@]
	$(CC) $(CFLAGS) $^ -o $@

.PHONY: test_strlen
test_strlen: ft_strlen
	@echo
	@echo [Testing $^]
	./$^

.PHONY: nm_strlen
nm_strlen: ft_strlen.o
	$(NM) $(NMFLAGS) $^

.PHONY:	clean
clean:
	rm -rf *.o

.PHONY:	fclean
fclean:	clean
	rm -rf ft_strlen
