#include "libasm.h"
#include <stdio.h>
#include <stdbool.h>
#include <string.h>

bool test(const char* str)
{
	char	*expected = ft_strdup(str);

	bool addr_is_ko = expected == str;
	bool str_is_ko = strcmp(expected, str) != 0;
	bool is_ko = addr_is_ko || str_is_ko;
	printf("[%s] src = \"%s\"(%p); strdup(src) = %p %s src\n", is_ko ? "KO" : "ok", str, str, expected, (str_is_ko || addr_is_ko ? "!=" : "=="));
	return is_ko;
}

int main()
{
	unsigned int kos = 0;
	kos += test("");
	kos += test("\0apple");
	kos += test("apple");
	kos += test("志布志市志布志町志布志");
	return !(kos == 0);
}
