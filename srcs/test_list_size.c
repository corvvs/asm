#include "libasm.h"
#include "test.h"
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <limits.h>

bool test(t_list *list, size_t expected)
{
	size_t actual = ft_list_size(list);
	bool is_ko = actual != expected;
	OUTRESULT(is_ko, "expected = %zu, actual = %zu\n", expected, actual);
	return is_ko;
}

int main() {
	unsigned int kos = 0;
	kos += test(NULL, 0);
	int		data = 1234;
	t_list	*head = NULL;
	size_t	n = ft_list_size(head);
	printf("size = %zu\n", n);
	kos += test(head, 0);
	int i = 0;
	for (; i < 100; ++i) {
		ft_list_push_front(&head, &data);
		kos += test(head, i + 1);
	}
	for (; i < 1000000; ++i) {
		ft_list_push_front(&head, &data);
		if (i % 123456 == 0)
			kos += test(head, i + 1);
	}
	kos += test(head, 1000000);
	ft_list_clear(head, free_nothing);
	return !(kos == 0);
}
