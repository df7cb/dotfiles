/*
 * Christoph Berg <cb@fsinfo.cs.uni-sb.de>
 * $Id$
 * 990214: xidle
 * 010202: xkbd
 */
 
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <X11/Xlib.h>

#define VENDOR_IS(x) !strncmp(vendor, x, strlen(x))

int main() {
	Display *display;
	char *vendor;
	
	if( (display=XOpenDisplay(NULL)) == NULL ) {
		exit(2);
	}

	vendor = ServerVendor(display);

	if(VENDOR_IS("The XFree86 Project, Inc")) {
		puts("pc");
	} else if(VENDOR_IS("X Consortium")) {
		puts("sun");
	} else {
		fprintf(stderr, "unknown vendor: %s\n", vendor); return 1;
	}
	
	return 0;
}
