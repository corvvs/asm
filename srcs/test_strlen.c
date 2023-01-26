#include "libasm.h"
#include "test.h"
#include <stdio.h>
#include <stdbool.h>
#include <string.h>

bool test(const char* str)
{
	size_t expected = strlen(str);
	size_t actual = ft_strlen(str);
	bool is_ko = actual != expected;
	OUTRESULT(is_ko, "ft_strlen(\"%s\") = %zu, expected = %zu\n", str, actual, expected);
	return is_ko;
}

int main()
{
	unsigned int kos = 0;
	kos += test("");
	kos += test("\0apple");
	kos += test("apple");
	return !(kos == 0);
}
