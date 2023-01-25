#include "libasm.h"
#include <limits.h>
#include <stdio.h>
#include <stdbool.h>
#include <string.h>

int	signify(int n) {
	return n > 0 ? +1 : n < 0 ? -1 : 0;
}

bool test(const char* s1, const char *s2)
{
	int	expected = strcmp(s1, s2);
	int	actual = ft_strcmp(s1, s2);

	bool	is_ko = signify(expected) != signify(actual);
	printf("[%s] strcmp(\"%s\", \"%s\"); expected rv = %d, actual rv = %d\n", is_ko ? "KO" : "ok", s1, s2, expected, actual);
	return is_ko;
}

bool test_longstr(const char* label, const char* s1, const char *s2)
{
	int		expected = strcmp(s1, s2);
	int		actual = ft_strcmp(s1, s2);
	size_t	n1 = strlen(s1);
	size_t	n2 = strlen(s2);

	bool	is_ko = signify(expected) != signify(actual);
	printf("[%s] [%s] strcmp(s1(%zu), s2(%zu)); expected rv = %d, actual rv = %d\n", is_ko ? "KO" : "ok", label, n1, n2, expected, actual);
	return is_ko;
}

#define LONGCASE(label, detsize, detstr)	{\
	size_t n;\
	detsize;\
	char *s1 = malloc(sizeof(char) * (n + 1));\
	char *s2 = malloc(sizeof(char) * (n + 1));\
	memset(s1, 'a', n);\
	memset(s2, 'a', n);\
	s1[n] = s2[n] = 0;\
	detstr;\
	kos += test_longstr(label, s1, s2);\
	free(s1); free(s2);\
}

int main()
{
	unsigned int kos = 0;
	kos += test("", "");
	kos += test("", "apple");
	kos += test("apple", "");
	kos += test("apple", "apple");
	kos += test("新橋", "apple");
	kos += test("apple", "banana");
	kos += test("apple", "applepie");
	kos += test("banamo", "banana");
	kos += test("おばんざい", "おばんです");
	kos += test("おばんざい", "おばんdeath");
	kos += test("おばんxie", "おばんです");
	LONGCASE("INT_MAX - 1 sized; same",
		n = INT_MAX - 1,
		(void)1);
	LONGCASE("INT_MAX sized; same",
		n = INT_MAX,
		(void)1);
	LONGCASE("INT_MAX + 1 sized; same",
		n = INT_MAX; n += 1,
		(void)1);
	LONGCASE("INT_MAX + 1 sized; differ at last letter",
		n = INT_MAX; n += 1,
		s1[n - 1] = (char)200);
	LONGCASE("UINT_MAX + 1 sized; same",
		n = UINT_MAX; n += 1,
		(void)1);
	LONGCASE("UINT_MAX + 1 sized; differ at last letter",
		n = UINT_MAX; n += 1,
		s1[n - 1] = (char)200);
	return !(kos == 0);
}
