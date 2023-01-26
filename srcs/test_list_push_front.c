#include "libasm.h"
#include "test.h"
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <limits.h>

int	test(const char *label, t_list *list, const char* expected) {
	char *buffer = malloc(sizeof(char) * (10000 + 1));
	FT_LIST_WRITE_STR(buffer, list);
	bool is_ko = strcmp(buffer, expected);
	OUTRESULT(is_ko, "%s\n     expected: %s\n     actual:   %s\n", label, expected, buffer);
	free(buffer);
	return is_ko;
}

int main() {
	int kos = 0;
	ft_list_push_front(NULL, NULL);
	t_list	*head = NULL;
	kos += test("blank list", head, "[]");
	ft_list_push_front(&head, NULL);
	kos += test("push front a NULL", head, "[(null), ]");
	ft_list_push_front(&head, NULL);
	kos += test("push front a NULL again", head, "[(null), (null), ]");

	char	*str1 = strdup("hello");
	ft_list_clear(head, free_nothing);
	head = NULL;
	ft_list_push_front(&head, str1);
	kos += test("cleared, and push front a hello", head, "[hello, ]");
	ft_list_push_front(&head, str1);
	kos += test("push front one more hello", head, "[hello, hello, ]");

	strcpy(str1, "world");
	kos += test("hello -> world", head, "[world, world, ]");

	char	*str2 = strdup("world");
	ft_list_push_front(&head, str2);
	kos += test("push front a world", head, "[world, world, world, ]");
	ft_list_push_front(&head, str2);
	kos += test("push front a world, again", head, "[world, world, world, world, ]");
	ft_list_push_front(&head, str1);
	kos += test("push front a world as str1", head, "[world, world, world, world, world, ]");

	strcpy(str2, "tokyo");
	kos += test("str2: world -> tokyo", head, "[world, tokyo, tokyo, world, world, ]");

	ft_list_clear(head, free_nothing);
	free(str1);
	free(str2);
	printf("%d cases failed\n", kos);
	return !!kos;
}
