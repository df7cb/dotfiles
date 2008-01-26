#include <locale.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <time.h>
#include <unistd.h>

int
main (int argc, char **argv)
{
	FILE *a;
	char buf[30];
	struct timeval t;

	setlocale (LC_ALL, "");
	sleep (1);

	if ((a = popen ("awesome-client", "w")) == NULL) {
		perror ("awesome-client");
		exit (1);
	}

	for (;;) {
		gettimeofday (&t, NULL);
		strftime (buf, sizeof (buf), " KW %-V %a %-e. %b %-H:%M:%S ", localtime (&t.tv_sec));
		fprintf (a, "0 widget_tell clock %s\n\n", buf);
		fflush (a);
		usleep (1000000 - t.tv_usec);
	}
}
