#include "asmfunc.h"
#include <stdio.h>
#include <stdbool.h>

bool test(const char* str, size_t expected)
{
	size_t actual = ft_strlen(str);
	bool is_ko = actual != expected;
	printf("[%s] ft_strlen(\"%s\") = %zu, expected = %zu\n", is_ko ? "KO" : "ok", str, actual, expected);
	return is_ko;
}

int main()
{
	unsigned int kos = 0;
	kos += test("", 0);
	kos += test("\0apple", 0);
	kos += test("apple", 5);
	return !(kos == 0);
}
