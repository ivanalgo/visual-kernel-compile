#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <libgen.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

void hookcmd_init(void) __attribute__((constructor));

char cmdline[1024];

char *argv[256];

static void inline get_cmdline()
{
	int fd;
	int ret;

	fd = open("/proc/self/cmdline", O_RDONLY);
	if (fd < 0) {
		perror("open /proc/self/cmdline");
		exit(1);
	}

	ret = read(fd, cmdline, 1024);
	if (ret < 0) {
		perror("read");
		exit(1);
	}
}

static void inline build_argv()
{
	size_t i;
	int argc = 1;
	size_t len = strlen(cmdline);
	char *start;

	start = cmdline;
	for (i = 0; i <= len; ++i) {
		if(cmdline[i] == '\0') {
			argv[argc++] = start;
			start = cmdline + i + 1;
		}
	}
	argv[argc] = NULL;
}

char *hook_cmd_tbl[] = {
	""
};

void hookcmd_init(void)
{
	char cmd[128] = { '\0' };
	char *name;

	get_cmdline();
	build_argv();

	strncpy(cmd, argv[1], sizeof(cmd) - 1);
	name = basename(cmd);

	fprintf(stderr, "cmd: %s\n", name);
}
