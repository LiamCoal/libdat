#include "libdat.h"

int main(int argc, char const **argv) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    if(argc < 3) {
        NSLog(@"Usage: %s <datfile> <directory>", argv[0]);
        return 1;
    }

    NSString *s1 = [NSString stringWithUTF8String:argv[1]];
    NSString *s2 = [NSString stringWithUTF8String:argv[2]];

    [[NSFileManager defaultManager] createFileAtPath: s1 contents: [[NSData alloc] init] attributes: NULL];

    int r = store(s1, s2);
    [pool drain];
    return r;
}