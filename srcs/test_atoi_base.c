#include "libasm.h"
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>

int main() {
	int c = 0;
	while (c < 1000000) {
		if (ft_is_space(c)) {
			printf("(%d)(%x) is space\n", c, c);
		}
		c += 1;
	}
}
