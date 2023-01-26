#include "libasm.h"
#include "test.h"
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <limits.h>

bool test(const char* str)
{
	size_t expected = strlen(str);
	size_t actual = ft_strlen(str);
	bool is_ko = actual != expected;
	OUTRESULT(is_ko, "ft_strlen(\"%s\") = %zu, expected = %zu\n", str, actual, expected);
	return is_ko;
}

bool long_test(size_t expected)
{
	char *str = malloc(sizeof(char) * (expected + 1));
	memset(str, 'a', expected);
	str[expected] = 0;
	size_t actual = ft_strlen(str);
	bool is_ko = actual != expected;
	OUTRESULT(is_ko, "ft_strlen(|%zu|) = %zu\n", expected, actual);
	return is_ko;
}


int main()
{
	unsigned int kos = 0;
	kos += test("");
	kos += test("\0apple");
	kos += test("apple");

	for (size_t n = 1; n < 64; ++n)
		kos += long_test(n);
	kos += long_test(100000);
	kos += long_test((size_t)INT_MAX);
	kos += long_test((size_t)INT_MAX + 10);
	kos += long_test((size_t)UINT_MAX);
	kos += long_test((size_t)UINT_MAX + 10);
	return !(kos == 0);
}
