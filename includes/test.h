#ifndef TEST_H
# define TEST_H

# define TX_ER "\e[31m"
# define TX_OK "\e[32m"
# define TX_RS "\e[0m"

# define PREFIX(is_ko) (is_ko ? TX_ER "[KO]" : TX_OK "[ok]")
# define OUTRESULT(is_ko, format, ...) dprintf(STDERR_FILENO, "%s " format TX_RS, PREFIX(is_ko), __VA_ARGS__)

void free_nothing(void *data);

#endif
