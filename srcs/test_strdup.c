#include "libasm.h"
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <limits.h>

bool test(const char* str)
{
	char	*expected = ft_strdup(str);

	bool addr_is_ko = expected == str;
	bool str_is_ko = strcmp(expected, str) != 0;
	bool is_ko = addr_is_ko || str_is_ko;
	printf("[%s] src = \"%s\"(%p); strdup(src) = %p %s src\n", is_ko ? "KO" : "ok", str, str, expected, (str_is_ko || addr_is_ko ? "!=" : "=="));
	free(expected);
	return is_ko;
}

bool long_test(const char* label, const char* str)
{
	size_t	n = ft_strlen(str);
	char	*expected = ft_strdup(str);

	bool addr_is_ko = expected == str;
	bool str_is_ko = strcmp(expected, str) != 0;
	bool is_ko = addr_is_ko || str_is_ko;
	printf("[%s] [%s] src = %p(%zu); strdup(src) = %p %s src\n", is_ko ? "KO" : "ok", label, str, n, expected, (str_is_ko || addr_is_ko ? "!=" : "=="));
	free(expected);
	return is_ko;
}

#define LONGCASE(label, detsize, detstr)	{\
	size_t n;\
	detsize;\
	char *s = malloc(sizeof(char) * (n + 1));\
	memset(s, 'a', n);\
	s[n] = 0;\
	detstr;\
	kos += long_test(label, s);\
	free(s);\
}

int main()
{
	unsigned int kos = 0;
	kos += test("");
	kos += test("\0apple");
	kos += test("apple");
	kos += test("志布志市志布志町志布志");


	LONGCASE("INT_MAX - 1 sized", n = INT_MAX - 1, (void)1);
	LONGCASE("INT_MAX sized", n = INT_MAX, (void)1);
	LONGCASE("INT_MAX + 1 sized", n = INT_MAX; n += 1, (void)1);
	LONGCASE("UINT_MAX sized", n = UINT_MAX, (void)1);
	LONGCASE("UINT_MAX + 1 sized", n = UINT_MAX; n += 1, (void)1);

	return !(kos == 0);
}
