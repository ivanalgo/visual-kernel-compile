#include <stdio.h>
#include <string.h>
#include <stdlib.h>

enum {
	IGNOR,
	INPUT ,
	OUTPUT,
};

struct opt {
	const char *prefix;
	int	has_arg;
	int 	type;	
} opttbls[] = {
	{"-W",			1,	IGNOR},
	{"-D",			1,	IGNOR},
	{"-d",			1,	IGNOR},
	{"-U",			1,	IGNOR},
	{"-E",			0,	IGNOR},
	{"-nostdinc",		0,	IGNOR},
	{"-isystem",		1,	IGNOR},
	{"-include",		1,	IGNOR},
	{"-std",		1,	IGNOR},
	{"-pipe",		0,	IGNOR},
	{"--param",		1,	IGNOR},
	{"-print-file-name",	1,	IGNOR},
	{"--version",		0,	IGNOR},
	{"-nostdlib",		0,	IGNOR},
	{"-shared",		0,	IGNOR},
	{"-O",			1,	IGNOR},
	{"-C",			0,	IGNOR},
	{"-P",			0,	IGNOR},
	{"-I",			1,	IGNOR},
	{"-f",			1,	IGNOR},
	{"-m",			1,	IGNOR},
	{"-o",			1,	OUTPUT},
	{"-c",			0,	IGNOR},
	{"-S",			0,	IGNOR},
	{"-x",			1,	IGNOR},
};

#define OPT_SIZE (sizeof(opttbls)/sizeof(opttbls[0]))

char *input_files = NULL;
char *output_files = NULL;

void append_file(char **file_list, const char *file)
{
	char *list = *file_list;

	if (list == NULL) {
		list = strdup(file);
	} else {
		list = realloc(list, strlen(list) + 1 + strlen(file));
		strcat(list, " ");
		strcat(list, file);
	}

	*file_list = list;
}

void handle_input_file(const char *cmd)
{
	append_file(&input_files, cmd);
}

void handle_output_file(const char *cmd)
{
	append_file(&output_files, cmd);
}

void handle_no_option(const char *cmd)
{
	handle_input_file(cmd);
}

int main(int argc, char *argv[])
{
	int idx;
	struct opt *opt;
	int oi;
	const char *arg;

	for (idx = 2; idx < argc; ++idx) {
		if (argv[idx][0] != '-' || argv[idx][1] == '\0') {
			/* not start with  -, or just is -, then this argv[idx]
			 * is not a option */
			handle_no_option(argv[idx]);
			continue;
		}

		/* handle option */
		for (oi = 0; oi < OPT_SIZE; ++oi) {
			opt = &opttbls[oi];
			if (strncmp(argv[idx], opt->prefix, strlen(opt->prefix)) == 0) {
				arg = argv[idx] + strlen(opt->prefix);
				goto match;
			}
		}

		fprintf(stderr, "Invalid option %s\n", argv[idx]);
		return 1;
match:
		if (opt->has_arg) {
			//printf("opt %s arg %s\n", opt->prefix, arg);
			if (arg[0] == '\0') {
				idx++;
				arg = argv[idx];
			}

			if (opt->type == 1) {
				//printf("opt %s arg %s\n", opt->prefix, arg);
				handle_input_file(arg);
			}
			else if (opt->type == 2)
				handle_output_file(arg);
		}
	}

	printf("%s : %s\n", input_files, output_files);
	return 0;
}
