#include <Foundation/Foundation.h>

int main (int argc, char * argv[])
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSArray * args = [[NSProcessInfo processInfo] arguments];
	printf ("%s\n", [[args objectAtIndex:0] UTF8String]);
	[pool drain];
	return 0;
}
