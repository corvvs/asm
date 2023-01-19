#include "libasm.h"
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>

#ifdef USE_CFUNC
# define FT_READ read
#else
# define FT_READ ft_read
#endif

bool test(
	const char *label,
	const char *filename, int fd, char *buffer, size_t size,
	ssize_t expected_rv, int expected_errno
) {
	int ufd = filename ? open(filename, O_RDONLY) : fd;
	errno = 0;
	ssize_t rv = FT_READ(ufd, buffer, size);
	bool is_rv_ko = rv != expected_rv;
	bool is_errno_ko = errno != expected_errno;
	bool is_ko = is_rv_ko || is_errno_ko;
	const char* errmsg = errno != 0 ? strerror(errno) : "\"\"";
	printf("[%s] %s\n", is_ko ? "KO" : "ok", label);
	printf("     read(%d, %s, %zu) = %zd(expected: %zd), errno = %d(%s, expected: %d)\n", ufd, buffer ? "buffer" : "(null)", size, rv, expected_rv, errno, errmsg, expected_errno);
	if (filename) {
		close(ufd);
	}
	return is_ko;
}

int main() {
	char buffer[1000];
	unsigned int kos = 0;
	kos += test("read 0 from STDIN into NULL",
		NULL, STDIN_FILENO, NULL, 0, 0, 0);
	kos += test("attempt to read 10 from " __FILE__ " into NULL",
		__FILE__, -1, NULL, 10, -1, EFAULT);
	kos += test("read 10 from " __FILE__,
		__FILE__, -1, buffer, 10, 10, 0);
	kos += test("read 10 from /dev/null",
		"/dev/null", -1, buffer, 10, 0, 0);
	{
		int devnull = open("/dev/null", O_WRONLY);
		test("attempt to read from /dev/null opened as WRONLY",
			NULL, devnull, buffer, 10, -1, EBADF);
		kos += close(devnull);
	}
	kos += test("read 1000 from /dev/zero",
		"/dev/zero", -1, buffer, 1000, 1000, 0);
	kos += test("attempt to read current dir",
		".", -1, buffer, 10, -1, EISDIR);
	kos += test("attempt to read from fd -1",
		NULL, -1, NULL, 0, -1, EBADF);
	return !(kos == 0);
}
