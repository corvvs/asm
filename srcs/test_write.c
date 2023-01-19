#include "libasm.h"
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>

#ifdef USE_CFUNC
# define FT_WRITE write
#else
# define FT_WRITE ft_write
#endif

bool test(
	const char *label,
	const char *filename, int fd, char *buffer, size_t size,
	ssize_t expected_rv, int expected_errno
) {
	int ufd = filename ? open(filename, O_WRONLY | O_CREAT | O_TRUNC) : fd;
	errno = 0;
	ssize_t rv = FT_WRITE(ufd, buffer, size);
	bool is_rv_ko = rv != expected_rv;
	bool is_errno_ko = errno != expected_errno;
	bool is_ko = is_rv_ko || is_errno_ko;
	const char* errmsg = errno != 0 ? strerror(errno) : "\"\"";
	printf("[%s] %s\n", is_ko ? "KO" : "ok", label);
	printf("     write(%d, %s, %zu) = %zd(expected: %zd), errno = %d(%s, expected: %d)\n", ufd, buffer ? "buffer" : "(null)", size, rv, expected_rv, errno, errmsg, expected_errno);
	if (filename) {
		close(ufd);
	}
	return is_ko;
}

#define WRITE_FILE "write.to"

int main() {
	char buffer[1000];
	unsigned int kos = 0;
	kos += test("write 0 to STDIN from NULL",
		NULL, STDOUT_FILENO, NULL, 0, 0, 0);
	kos += test("attempt to write 10 into STDIN from " WRITE_FILE " from NULL",
		WRITE_FILE, -1, NULL, 10, -1, EFAULT);
	kos += test("write 10 to " WRITE_FILE,
		WRITE_FILE, -1, buffer, 10, 10, 0);
	kos += test("write 10 from /dev/null",
		"/dev/null", -1, buffer, 10, 10, 0);
	{
		int devnull = open("/dev/null", O_RDONLY);
		test("attempt to write into /dev/null opened as RDONLY",
			NULL, devnull, buffer, 10, -1, EBADF);
		kos += close(devnull);
	}
	kos += test("write 1000 into /dev/zero",
		"/dev/zero", -1, buffer, 1000, 1000, 0);
	kos += test("attempt to write into current dir",
		".", -1, buffer, 10, -1, EBADF); // EISDIR ではない
	kos += test("attempt to write into fd -1",
		NULL, -1, NULL, 0, -1, EBADF);
	return !(kos == 0);
}
