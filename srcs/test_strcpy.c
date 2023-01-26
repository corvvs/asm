#include "libasm.h"
#include "test.h"
#include <stdio.h>
#include <stdbool.h>
#include <string.h>

bool test(const char* str)
{
	char	*dst_actual = malloc(1000);
	char	*rv_actual = ft_strcpy(dst_actual, str);

	bool	dst_is_ko = strcmp(dst_actual, str) != 0;
	bool	rv_is_ko = rv_actual != dst_actual;
	bool	is_ko = dst_is_ko || rv_is_ko;
	OUTRESULT(is_ko, "strcpy: \"%s\" -> \"%s\" expected rv = %p, actual rv = %p\n", str, dst_actual, dst_actual, rv_actual);
	free(dst_actual);
	return is_ko;
}

int main()
{
	unsigned int kos = 0;
	kos += test("");
	kos += test("\0apple");
	kos += test("apple");
	kos += test("        lea     rax, [rdi]                      ; rdi に入っているアドレスが指す値, ではなくアドレス自体をraxに入れる");
	return !(kos == 0);
}
