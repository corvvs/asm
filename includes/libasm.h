#include <stdlib.h>
#include <unistd.h>

size_t	ft_strlen(const char *str);
char 	*ft_strcpy(char *dst, const char *src);
int		ft_strcmp(const char *s1, const char *s2);
char	*ft_strdup(const char *str);
ssize_t	ft_read(int fd, void *data, size_t n);
ssize_t	ft_write(int fd, void *data, size_t n);

int		ft_atoi_base(const char *str, const char *base);

int		ft_is_sign(int c);
int		ft_is_space(int c);

#include <limits.h>
int		make_map(const char *base, unsigned char char_map[UCHAR_MAX + 1]);
