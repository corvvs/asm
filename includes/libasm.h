#ifndef LIBASM_H
# define LIBASM_H

#include <stdlib.h>
#include <unistd.h>

typedef struct		s_list
{
	void			*data;
	struct s_list	*next;
}					t_list;

#define FT_LIST_PRINT(list, data_type)	{\
	t_list *curr = list;\
	printf("[");\
	while (curr) {\
		printf("%d, ", *(data_type *)curr->data);\
		curr = curr->next;\
	}\
	printf("]\n");\
}

#define FT_LIST_ADDRESS(list)	{\
	t_list *curr = list;\
	printf("[");\
	while (curr) {\
		printf("%p|%p, ", curr, curr->data);\
		curr = curr->next;\
	}\
	printf("]\n");\
}

size_t	ft_strlen(const char *str);
char 	*ft_strcpy(char *dst, const char *src);
int		ft_strcmp(const char *s1, const char *s2);
char	*ft_strdup(const char *str);
ssize_t	ft_read(int fd, void *data, size_t n);
ssize_t	ft_write(int fd, void *data, size_t n);

int		ft_atoi_base(const char *str, const char *base);
void	ft_list_push_front(t_list **begin_list, void *data);
size_t	ft_list_size(t_list *begin_list);
void	ft_list_sort(t_list **begin_list, int (*cmp)());
void	ft_list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)(), void (*free_fct)(void *));

int		ft_is_sign(int c);
int		ft_is_space(int c);
t_list	*ft_list_new(void *data);
void	ft_list_delete(t_list *node, void (*free_fct)(void *));
void	ft_list_clear(t_list *list, void (*free_fct)(void *));

#include <limits.h>
int		make_map(const char *base, unsigned char char_map[UCHAR_MAX + 1]);
#endif
