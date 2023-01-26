#include "libasm.h"
#include "test.h"
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <limits.h>

bool	test(const char* str)
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

bool	longtest(size_t n)
{
	char	*src = malloc(sizeof(char) * (n + 1));
	char	*dst = malloc(sizeof(char) * (n + 1));
	src[n] = 0;
	for (size_t i = 0; i < n; ++i)
		src[i] = 'a' + i % 26;
	char	*rv = ft_strcpy(dst, src);
	bool	dst_is_ko = strcmp(rv, src) != 0;
	bool	rv_is_ko = rv != dst;
	bool	is_ko = dst_is_ko || rv_is_ko;
	OUTRESULT(is_ko, "|%zu| expected rv = %p, actual rv = %p\n", n, dst, rv);
	free(src);
	free(dst);
	return is_ko;
}

int	main()
{
	unsigned int kos = 0;
	kos += test("");
	kos += test("\0apple");
	kos += test("apple");
	kos += test("        lea     rax, [rdi]                      ; rdi に入っているアドレスが指す値, ではなくアドレス自体をraxに入れる");

	kos += longtest(12345);
	kos += longtest(INT_MAX - 1);
	kos += longtest(INT_MAX);
	kos += longtest((size_t)INT_MAX + 1);
	return !(kos == 0);
}
