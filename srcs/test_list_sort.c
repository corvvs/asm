#include "libasm.h"
#include "test.h"
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <limits.h>

#include <stdio.h>

int	test(const char *label, t_list *list, const char* expected) {
	char *buffer = malloc(sizeof(char) * (10000 + 1));
	FT_LIST_WRITE_INT(buffer, list);
	bool is_ko = strcmp(buffer, expected);
	OUTRESULT(is_ko, "%s\n     expected: %s\n     actual:   %s\n", label, expected, buffer);
	free(buffer);
	return is_ko;
}

int	intcmp(void	*a, void *b)
{
	int ia = *(int *)a;
	int ib = *(int *)b;
	int r = ia < ib ? -1 : ia > ib ? +1 : 0;
	// printf("cmp(%d, %d) = %d\n", ia, ib, r);
	return r;
}

int main() {
	int kos = 0;

	int	arr[] = {9, 100, 5, -1, 45, 2, 817, 94, 0, -4, 17, };
	t_list *head = NULL;
	kos += test("blank", head,        "[]");
	ft_list_sort(&head, intcmp);
	kos += test("sorted blank", head, "[]");
	int v = 99999;
	ft_list_push_front(&head, &v);
	kos += test("single element list: [99999]", head, "[99999, ]");
	ft_list_sort(&head, intcmp);
	kos += test("sorted [99999]", head, "[99999, ]");

	ft_list_clear(head, free_nothing);
	head = NULL;
	for (unsigned int i = 0; i < sizeof(arr) / sizeof(arr[0]); ++i) {
		ft_list_push_front(&head, &arr[sizeof(arr) / sizeof(arr[0]) - i - 1]);
	}
	kos += test("sorting", head,      "[9, 100, 5, -1, 45, 2, 817, 94, 0, -4, 17, ]");
	ft_list_sort(&head, intcmp);
	kos += test("sorted once", head,  "[-4, -1, 0, 2, 5, 9, 17, 45, 94, 100, 817, ]");
	ft_list_sort(&head, intcmp);
	kos += test("sorted twice", head, "[-4, -1, 0, 2, 5, 9, 17, 45, 94, 100, 817, ]");
	ft_list_clear(head, free_nothing);

	return !(kos == 0);
}
