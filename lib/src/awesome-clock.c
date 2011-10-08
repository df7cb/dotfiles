#define _BSD_SOURCE
#include <assert.h>
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
#define ms * 1000

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
		if (stat (socket, &st) != -1) {
			usleep (1000 ms);
			return;
		}
		usleep (500 ms);
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

#define BAT "C1ED"
#define BAT_FULL  "/sys/class/power_supply/" BAT "/charge_full"
#define BAT_STATE "/sys/class/power_supply/" BAT "/charge_now"
#define CURRENT   "/sys/class/power_supply/" BAT "/current_now"

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
		if ((f = fopen (BAT_FULL, "r")) == NULL) {
			max_cap = -2;
			return -1;
		}
		fgets (buf, sizeof (buf), f);
		max_cap = atoi (buf);
		fclose (f);
		if (max_cap <= 0) {
			fprintf (stderr, "Cannot read last full capacity\n");
			max_cap = -2;
			return -1;
		}
	}

	if ((f = fopen (BAT_STATE, "r")) == NULL) {
		perror (BAT_STATE);
		//max_cap = -2;
		return -1;
	}
	fgets (buf, sizeof (buf), f);
	remaining = atoi (buf);
	fclose (f);

	if ((f = fopen (CURRENT, "r")) == NULL) {
		perror (CURRENT);
		//max_cap = -2;
		return -1;
	}
	fgets (buf, sizeof (buf), f);
	rate = atoi (buf);
	fclose (f);

	if (rate > 0)
		fprintf (a, "0 widget_tell topbar battery text  %.0f%% %.0f' \n",
			(double) remaining / max_cap * 100.0,
			(double) remaining / rate * 60.0);
	else
		fprintf (a, "0 widget_tell topbar battery text  %.0f%% \n",
			(double) remaining / max_cap * 100.0);

	return 0;
}

static int
wireless (FILE *a)
{
	FILE *f;
	char buf[200];
	if ((f = fopen ("/proc/net/wireless", "r")) == NULL) {
		return -1;
	}

	int link_quality;
	while (fgets (buf, sizeof (buf), f)) {
		if (sscanf (buf, "%*s %*d %d", &link_quality) >0) {
			fprintf (a, "0 widget_tell topbar wireless text  %d%% \n",
					(int) (link_quality / 0.7));
			break;
		}
	}
	fclose (f);

	return 0;
}

static int
loadavg (FILE *a)
{
	FILE *f;
	char buf[30];
	if ((f = fopen ("/proc/loadavg", "r")) == NULL) {
		perror ("/proc/loadavg");
		return -1;
	}
	fgets (buf, sizeof (buf), f);
	fclose (f);

	char *p;
	p = strchr (buf, ' ');
	assert (p);
	p = strchr (p + 1, ' ');
	assert (p);
	p = strchr (p + 1, ' ');
	assert (p);
	*p = '\0';

	fprintf (a, "0 widget_tell topbar loadavg text  %s \n", buf);
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
	//int mailcount = -1;

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
		wireless (a);
		loadavg (a);

		if (maildir && t.tv_sec >= mail_time + 10) {
			int c = count_mail (maildir);
			if (c)
				fprintf (a, "0 widget_tell topbar mail text  %d Mail%s \n",
						c, c > 1 ? "s" : "");
			else
				fprintf (a, "0 widget_tell topbar mail text  \n");
			mail_time = t.tv_sec - (t.tv_sec % 10);
			/*
			if (c > mailcount && mailcount != -1)
				system ("echo mx | sudo cw -e -s console -w 30");
			mailcount = c;
			*/
		}

		fprintf (a, "\n");

		fflush (a);
		usleep (1000 ms - t.tv_usec);
	}
}
