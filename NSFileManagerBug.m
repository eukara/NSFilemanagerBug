#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

int main(int argc, char **argv)
{
	int ch;
	/* general */
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSApplication *application = [NSApplication sharedApplication];
	NSString *fromDir = nil;
	NSString *toDir = nil;

	/* test-case related */
	NSFileManager *fileManager;
	BOOL didSucceed;

	while ((ch = getopt(argc, argv, "hof")) != -1) {
		switch (ch) {
		case 'h':
			fputs( "-h help\n", stderr );
			fputs( "-f inputDirectory\n", stderr );
			fputs( "-o fromDirectory\n", stderr );
			return 0;
		case 'f':
			fromDir = [NSString stringWithUTF8String: argv[optind]];
			optind++;
			break;
		case 'o':
			toDir = [NSString stringWithUTF8String: argv[optind]];
			optind++;
			break;
		default:
			return 1;
		}
	}
	argc -= optind;
	argv += optind;

	/* options */
	if (!toDir) {
		NSAlert *alertPanel = [[NSAlert  alloc] init];
		[alertPanel setMessageText: @"No output directory set"];
		[alertPanel setInformativeText: @"Specify an output directory with -o [fromDirectory]"];
		[alertPanel setAlertStyle: (NSAlertStyle)1];
		[alertPanel runModal];
		[alertPanel release];
		[application stop: nil];
		[pool drain];
		return 0;
	}

	if (!fromDir) {
		fromDir = @"./testitems";
	}

	fileManager = [NSFileManager defaultManager];
	didSucceed = [fileManager copyPath: fromDir toPath: toDir handler:nil];
	NSLog(@"fileManager copyPath from %@ to %@ status: %d", fromDir, toDir, didSucceed);

	[application stop: nil];
	[pool drain];

	return 0;
}
