#include "libasm.h"
#include "test.h"
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <limits.h>

#include <stdio.h>

#define FT_LIST_PRINT(list, data_type)	{\
	t_list *curr = list;\
	printf("[");\
	while (curr) {\
		printf("%d, ", *(data_type *)curr->data);\
		curr = curr->next;\
	}\
	printf("]\n");\
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
	int	arr[] = {9, 100, 5, -1, 45, 2, 817, 94, 0, -4, 17};
	for (unsigned int i = 2; i < sizeof(arr) /  sizeof(arr[0]); ++i) {
		printf("i = %u\n", i);
		t_list *head = NULL;
		for (unsigned int j = 0; j < i; ++j) {
			ft_list_push_front(&head, &arr[j]);
		}
		printf("sorting:   ");
		FT_LIST_PRINT(head, int);
		ft_list_sort(&head, intcmp);
		printf("sorted:    ");
		FT_LIST_PRINT(head, int);
		ft_list_sort(&head, intcmp);
		printf("re-sorted: ");
		FT_LIST_PRINT(head, int);
	}
}
