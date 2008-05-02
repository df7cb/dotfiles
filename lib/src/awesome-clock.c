#define _BSD_SOURCE
#include <ctype.h>
#include <dirent.h>
#include <locale.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/types.h>
#include <time.h>
#include <unistd.h>

#define TIMEFORMAT " %-e. %-H:%M:%S "
/* #define TIMEFORMAT " KW %V %-e. %b %-H:%M:%S " */

static void
wait_for_socket ()
{
	char *display;
	char socket[100];
	int i;
	struct stat st;

	if ((display = getenv ("DISPLAY")) == NULL || strlen (display) < 2) {
		fprintf (stderr, "DISPLAY is not set or too short");
		exit (1);
	}
	snprintf (socket, sizeof (socket), "%s/.awesome_ctl.%d",
			getenv ("HOME"), atoi (display + 1));

	for (i = 0; i < 20; i++) {
		if (stat (socket, &st) != -1)
			return;
		usleep (500000);
	}

	perror (socket);
	exit (1);
}

static int
count_mail (char *path)
{
	DIR *dir;
	struct dirent *entry;
	dir = opendir (path);
	if (!dir)
		return 0;

	int count = 0;
	while ((entry = readdir (dir))) {
		if (DT_DIR == entry->d_type)
			continue;
		count++;
	}
	closedir (dir);
	return count;
}

#define LAST_FULL "last full capacity:"
#define BAT_STATE "/proc/acpi/battery/BAT1/state"
#define REMAINING "remaining capacity:"
#define RATE "present rate:"

static int
bat_cap (FILE *a)
{
	static int max_cap = -1;
	static char buf[128];
	FILE *f;
	int remaining, rate;

	if (max_cap == -2)
		return -1;

	if (max_cap == -1) {
		if ((f = fopen ("/proc/acpi/battery/BAT1/info", "r")) == NULL) {
			max_cap = -2;
			return -1;
		}
		while (fgets (buf, sizeof (buf), f)) {
			if (!strncmp (buf, LAST_FULL, sizeof (LAST_FULL) - 1)) {
				max_cap = atoi (buf + sizeof (LAST_FULL));
				break;
			}
		}
		fclose (f);
		if (max_cap <= 0) {
			fprintf (stderr, "Cannot read last full capacity\n");
			max_cap = -2;
			return -1;
		}
	}

	if ((f = fopen (BAT_STATE, "r")) == NULL) {
		perror (BAT_STATE);
		max_cap = -2;
		return -1;
	}
	while (fgets (buf, sizeof (buf), f)) {
		if (!strncmp (buf, REMAINING, sizeof (REMAINING) - 1))
			remaining = atoi (buf + sizeof (REMAINING));
		if (!strncmp (buf, RATE, sizeof (RATE) - 1))
			rate = atoi (buf + sizeof (RATE));
	}
	fclose (f);

	if (rate > 0)
		fprintf (a, "0 widget_tell topbar battery text  %d mAh %.1f%% %.1fm \n", remaining, (double) remaining / max_cap * 100.0,
			(double) remaining / rate * 60.0);
	else
		fprintf (a, "0 widget_tell topbar battery text  %d mAh %.1f%% \n", remaining, (double) remaining / max_cap * 100.0);

	return 0;
}

int
main (int argc, char **argv)
{
	FILE *a;
	char buf[30];
	struct timeval t;
	time_t mail_time = 0;
	int clock_screen = 0;
	char *maildir = NULL;

	setlocale (LC_ALL, "");

	if (argc > 1)
		clock_screen = atoi (argv[1]);
	if (argc > 2)
		maildir = argv[2];

	wait_for_socket ();
	if ((a = popen ("awesome-client", "w")) == NULL) {
		perror ("awesome-client");
		exit (1);
	}

	for (;;) {
		gettimeofday (&t, NULL);
		strftime (buf, sizeof (buf), TIMEFORMAT, localtime (&t.tv_sec));
		fprintf (a, "%d widget_tell topbar clock text %s\n\n",
				clock_screen, buf);

		bat_cap (a);

		if (maildir && t.tv_sec >= mail_time + 10) {
			int c = count_mail (maildir);
			if (c)
				fprintf (a, "0 widget_tell topbar mail text  %d Mail%s \n",
						c, c > 1 ? "s" : "");
			else
				fprintf (a, "0 widget_tell topbar mail text  \n");
			mail_time = t.tv_sec - (t.tv_sec % 10);
		}

		fprintf (a, "\n");

		fflush (a);
		usleep (1000000 - t.tv_usec);
	}
}
