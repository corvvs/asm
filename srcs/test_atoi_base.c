#include "libasm.h"
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <limits.h>

int main() {
	// int c = 0;
	// while (c < 1000000) {
	// 	if (ft_is_space(c)) {
	// 		printf("(%d)(%x) is space\n", c, c);
	// 	}
	// 	c += 1;
	// }

	// const char *base = "0123456789";
	const char *base = "quickbrown";
	unsigned char	char_map[UCHAR_MAX + 1];
	unsigned char	base_len = make_map(base, char_map);
	printf("base len = %u\n", base_len);
	if (base_len) {
		for (int i = 0; i < UCHAR_MAX; ++i) {
			if (char_map[i] != UCHAR_MAX) {
				printf("char_map[%d('%c')] = %u\n", i, i, char_map[i]);
			}
		}
	}
}
