#include "libasm.h"
#include "test.h"
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <limits.h>

#include <stdio.h>

int	intcmp(void	*a, void *b)
{
	int ia = *(int *)a;
	int ib = *(int *)b;
	int r = ia < ib ? -1 : ia > ib ? +1 : 0;
	return r;
}

int	is_coprime(void *a, void *b)
{
	int x = *(int *)a;
	int y = *(int *)b;
	if (!x || !y)
		return 0;
	x = x > 0 ? x : -x;
	y = y > 0 ? y : -y;
	int z;
	while (y)
	{
		z = x % y;
		x = y;
		y = z;
	}
	return x != 1;
}

int	lt(void *a, void *b)
{
	int x = *(int *)a;
	int y = *(int *)b;
	return !(x < y);
}

void free_nothing(void *data) {
	printf("free %p!\n", data);
}

int main() {
	setvbuf(stdout, NULL, _IONBF, 0);
	int	arr[] = {16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0};
	t_list *head = NULL;
	for (unsigned int i = 0; i < sizeof(arr) / sizeof(arr[0]); ++i) {
		ft_list_push_front(&head, &arr[i]);
	}

	FT_LIST_ADDRESS(head);
	int v ;
	printf("[initial]\n");
	FT_LIST_PRINT(head, int);
	v = 100;
	ft_list_remove_if(&head, &v, intcmp, free_nothing);
	printf("[removed: == %d]\n", v);
	FT_LIST_PRINT(head, int);
	v = 0;
	ft_list_remove_if(&head, &v, intcmp, free_nothing);
	printf("[removed: == %d]\n", v);
	FT_LIST_PRINT(head, int);
	v = 7;
	ft_list_remove_if(&head, &v, intcmp, free_nothing);
	printf("[removed: == %d]\n", v);
	FT_LIST_PRINT(head, int);
	v = 4;
	ft_list_remove_if(&head, &v, is_coprime, free_nothing);
	printf("[removed: coprime with %d]\n", v);
	FT_LIST_PRINT(head, int);
	v = 5;
	ft_list_remove_if(&head, &v, lt, free_nothing);
	printf("[removed: < %d]\n", v);
	FT_LIST_PRINT(head, int);
	v = 100;
	ft_list_remove_if(&head, &v, lt, free_nothing);
	printf("[removed: < %d]\n", v);
	FT_LIST_PRINT(head, int);
	v = 100;
	ft_list_remove_if(&head, &v, lt, free_nothing);
	printf("[removed: < %d]\n", v);
	FT_LIST_PRINT(head, int);
	printf("head = %p\n", head);
}
