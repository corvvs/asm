SRCDIR		:=	srcs
OBJDIR		:=	objs
INCDIR		:=	includes
CC			:=	gcc
CFLAGS		:=	-Wall -Wextra -Werror -fno-builtin -I$(INCDIR) -g -fsanitize=address
ASM			:=	nasm
ASFLAGS		:=	-f macho64 -g
AR			:=	ar
ARFLAGS		:=	rcs
NM			:=	nm
NMFLAGS		:=	-g
NAME		:=	libasm.a

### リストの定義
NAMES		:=	strlen\
				strcpy\
				strcmp\
				strdup\
				read\
				write\
				atoi_base\
				list_push_front\
				list_size\
				list_sort\
				# list_remove_if
TEST_NAMES	:=	$(addprefix test_,$(NAMES))
NM_NAMES	:=	$(addprefix nm_,$(NAMES))
ASM_OBJS	:=	$(addsuffix .o,$(addprefix $(OBJDIR)/ft_,$(NAMES)))

define TARGET_EXEC
$(1):	$(call MakeDep,$(1))
	@echo [Building $(1)]
	$(CC) $(CFLAGS) $(call MakeDep,$(1)) -o $(1)
endef

define TARGET_TEST
$(call MakeTestDep,$(1)):	$(1)
	@echo
	@echo [Testing $(1)]
	./$(1)
endef

define TARGET_NM
$(call MakeNameDep,$(1)):	$(1)
	$(NM) $(NMFLAGS) $(OBJDIR)/ft_$(1).o
endef

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
	@mkdir -p $(OBJDIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJDIR)/%.o: $(SRCDIR)/%.s
	@mkdir -p $(OBJDIR)
	$(ASM) $(ASFLAGS) $< -o $@

$(NAME):		$(ASM_OBJS)
	$(AR) $(ARFLAGS) $@ $^

### 各関数の実行ファイルビルドルール
$(foreach func,\
	$(NAMES),\
	$(eval $(call TARGET_EXEC,$(func))))

### 各関数のテストルール
.PHONY: 		$(TEST_NAMES)
$(foreach func,\
	$(NAMES),\
	$(eval $(call TARGET_TEST,$(func))))

### 各関数のnmルール
.PHONY:			$(NM_NAMES)
$(foreach func,\
	$(NAMES),\
	$(eval $(call TARGET_NM,$(func))))

### その他
.PHONY:		clean fclean re
clean:
	rm -rf $(OBJDIR)

fclean:		clean
	rm -rf $(NAME) $(NAMES)

re:			fclean all
