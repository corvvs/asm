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

int main() {
	setvbuf(stdout, NULL, _IONBF, 0);
	int kos = 0;
	int	arr[] = {16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0};
	t_list *head = NULL;
	for (unsigned int i = 0; i < sizeof(arr) / sizeof(arr[0]); ++i) {
		ft_list_push_front(&head, &arr[i]);
	}

	int v ;
	kos += test("[initial]", head, "[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, ]");
	v = 100;
	ft_list_remove_if(&head, &v, intcmp, free_nothing);
	kos += test("[removed: == 100]", head, "[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, ]");
	v = 0;
	ft_list_remove_if(&head, &v, intcmp, free_nothing);
	kos += test("[removed: == 0]", head, "[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, ]");
	v = 7;
	ft_list_remove_if(&head, &v, intcmp, free_nothing);
	kos += test("[removed: == 7]", head, "[1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13, 14, 15, 16, 1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13, 14, 15, 16, ]");
	ft_list_remove_if(&head, &v, intcmp, free_nothing);
	kos += test("[removed: == 7]", head, "[1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13, 14, 15, 16, 1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13, 14, 15, 16, ]");
	v = 5;
	ft_list_remove_if(&head, &v, is_coprime, free_nothing);
	kos += test("[removed: coprime with 5]", head, "[5, 10, 15, 5, 10, 15, ]");
	v = 11;
	ft_list_remove_if(&head, &v, lt, free_nothing);
	kos += test("[removed: < 11]", head, "[15, 15, ]");
	v = 100;
	ft_list_remove_if(&head, &v, lt, free_nothing);
	kos += test("[removed: < 100]", head, "[]");
	ft_list_remove_if(&head, &v, lt, free_nothing);
	kos += test("[removed: < 100]", head, "[]");
	return !(kos == 0);
}
