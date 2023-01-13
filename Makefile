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
NM_NAMES	:=	$(addprefix nm_,$(NAMES))

MakeDep		= $(OBJDIR)/test_$(1).o $(OBJDIR)/ft_$(1).o
MakeTestDep	= test_$(1)
MakeNameDep	= nm_$(1)

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

.PHONY: 		$(TEST_NAMES)
$(call MakeTestDep,strlen):	strlen
	@echo
	@echo [Testing $^]
	./$^

.PHONY:			$(NM_NAMES)
$(call MakeNameDep,strlen):	strlen
	$(NM) $(NMFLAGS) $(OBJDIR)/ft_$^.o

.PHONY:		clean fclean re
clean:
	rm -rf $(OBJDIR)

fclean:		clean
	rm -rf $(NAMES)

re:			fclean all
