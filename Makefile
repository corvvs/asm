SRCDIR		:=	srcs
OBJDIR		:=	objs
INCDIR		:=	includes
CC			:=	gcc
CFLAGS		:=	-Wall -Wextra -Werror -I$(INCDIR) -g -fsanitize=address
ASM			:=	nasm
ASFLAGS		:=	-f macho64
AR			:=	ar
ARFLAGS		:=	rcs
NM			:=	nm
NMFLAGS		:=	-g
NAME		:=	libasm.a

### リストの定義
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
ASM_OBJS	:=	$(addsuffix .o,$(addprefix $(OBJDIR)/ft_,$(NAMES)))

### 関数定義
MakeDep		= $(OBJDIR)/test_$(1).o $(NAME)
MakeTestDep	= test_$(1)
MakeNameDep	= nm_$(1)

### all, tall(test all)
.PHONY: all
all:	$(NAME)

.PHONY: tall
tall:	$(TEST_NAMES)

### コンパイル用パターンルール
$(OBJDIR)/%.o: $(SRCDIR)/%.c
	mkdir -p $(OBJDIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJDIR)/%.o: $(SRCDIR)/%.asm
	mkdir -p $(OBJDIR)
	$(ASM) $(ASFLAGS) $< -o $@

$(NAME):		$(ASM_OBJS)
	$(AR) $(ARFLAGS) $@ $^

### 各関数の実行ファイルビルドルール
strlen:			$(call MakeDep,strlen)
	@echo [Building $@]
	$(CC) $(CFLAGS) $^ -o $@

strcpy:			$(call MakeDep,strcpy)
	@echo [Building $@]
	$(CC) $(CFLAGS) $^ -o $@

### 各関数のテストルール
.PHONY: 		$(TEST_NAMES)
$(call MakeTestDep,strlen):	strlen
	@echo
	@echo [Testing $^]
	./$^

### 各関数のnmルール
.PHONY:			$(NM_NAMES)
$(call MakeNameDep,strlen):	strlen
	$(NM) $(NMFLAGS) $(OBJDIR)/ft_$^.o

### その他
.PHONY:		clean fclean re
clean:
	rm -rf $(OBJDIR)

fclean:		clean
	rm -rf $(NAME) $(NAMES)

re:			fclean all
