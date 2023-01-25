#include "libasm.h"
#include "test.h"
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <limits.h>

int main() {
	char	*str1 = strdup("hello");
	ft_list_push_front(NULL, NULL);

	char	*str2 = strdup("world");
	t_list	*head = NULL;
	ft_list_push_front(&head, str1);
	printf("head       = %p\n", head);
	printf("head->data = %s\n", (char *)head->data);
	printf("head->next = %p\n", head->next);

	ft_list_push_front(&head, str2);
	printf("head       = %p\n", head);
	printf("head->data = %s\n", (char *)head->data);
	printf("head->next = %p\n", head->next);

	t_list	*next = head->next;
	printf("next       = %p\n", next);
	printf("next->data = %s\n", (char *)next->data);
	printf("next->next = %p\n", next->next);

	ft_list_clear(head, free_nothing);
	free(str1);
	free(str2);
}
