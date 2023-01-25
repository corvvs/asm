#include "libasm.h"
#include "test.h"
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <limits.h>

int main() {
	int		data = 1234;
	t_list	*head = NULL;
	size_t	n = ft_list_size(head);
	printf("size = %zu\n", n);
	for (int i = 0; i < 100; ++i) {
		ft_list_push_front(&head, &data);
		n = ft_list_size(head);
		printf("size = %zu\n", n);
	}
	ft_list_clear(head, free_nothing);
}
