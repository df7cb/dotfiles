static void parse_options(int argc, char *argv[]) {
	int c;
	while((c = getopt(argc, argv, "ho:")) >= 0) {
		switch(c) {
			case 'h':
				print_help();
				exit(0);
				break;
			case 'o':
				out_fname = optarg;
				break;
			default:
				// fprintf(stderr, "unknown option '%c'\n", c);
				print_help();
				exit(6);
		}
	}
}

