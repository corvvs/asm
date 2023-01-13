SRCDIR		:=	srcs
OBJDIR		:=	objs
INCDIR		:=	includes
CC			:=	gcc
CFLAGS		:=	-Wall -Wextra -Werror -I$(INCDIR)
ASM			:=	nasm
ASFLAGS		:=	-f macho64
NM			:=	nm
NMFLAGS		:=	-g
NAMES		:=	strlen\
				# strcpy\
				# strcmp\
				# write\
				# read\
				# strdup\
				# atoi_base\
				# list_push_front\
				# list_size\
				# list_sort\
				# list_remove_if

TEST_NAMES	:=	$(addprefix test_,$(NAMES))

MakeDep		= $(OBJDIR)/test_$(1).o $(OBJDIR)/ft_$(1).o

.PHONY: all
all:	$(NAMES)

.PHONY: tall
tall:	$(TEST_NAMES)

$(OBJDIR)/%.o: $(SRCDIR)/%.c
	mkdir -p $(OBJDIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJDIR)/%.o: $(SRCDIR)/%.asm
	mkdir -p $(OBJDIR)
	$(ASM) $(ASFLAGS) $< -o $@

strlen:			$(call MakeDep,strlen)
	@echo [Building $@]
	$(CC) $(CFLAGS) $^ -o $@

strcpy:			$(call MakeDep,strcpy)
	@echo [Building $@]
	$(CC) $(CFLAGS) $^ -o $@

.PHONY: 		test_strlen
test_strlen:	strlen
	@echo
	@echo [Testing $^]
	./$^

.PHONY:		nm_strlen
nm_strlen:	ft_strlen.o
	$(NM) $(NMFLAGS) $^

.PHONY:		clean
clean:
	rm -rf $(OBJDIR)

.PHONY:		fclean
fclean:		clean
	rm -rf $(NAMES)

.PHONY: 	re
re:			fclean all
