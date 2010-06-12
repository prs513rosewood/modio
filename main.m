#include <Foundation/Foundation.h>

int main (int argc, char * argv[])
{
	NSString * args = [[NSProcessInfo] arguments];
	printf ("%s", [[args objectAtIndex:0] UTF8String]);
	return 0;
}
