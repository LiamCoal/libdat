#include <GNUstep/Foundation/Foundation.h>

int main(int argc, char const **argv) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    if(argc < 3) {
        NSLog(@"Usage: %s <datfile> <directory>", argv[0]);
        return 1;
    }

    NSString *file = [NSString stringWithUTF8String:argv[1]];
    NSString *path = [NSString stringWithUTF8String:argv[2]];

    [[NSFileManager defaultManager] createFileAtPath: file contents: [[NSData alloc] init] attributes: nil];

    NSFileHandle *fh = [NSFileHandle fileHandleForWritingAtPath: file];

    [fh writeData: [NSData dataWithBytes: "DAT\x1a" length: 4]];
    if(fh == nil) {
        NSLog(@"Failed to open file: %@", file);
        return 1;
    } else {
        NSLog(@"Opened file for writing: %@", file);
    }
    [fh seekToFileOffset: 512];

    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];

    NSLog(@"Got array: %@", files);

    for(unsigned long i = 0; i < [files count]; i++) {
        NSLog(@"Operating on %@", [files objectAtIndex: i]);
        [fh writeData: [NSData dataWithBytes:(void*)[[files objectAtIndex: i] UTF8String] length:11]];
        int s = [[files objectAtIndex: i] intValue];
        [fh writeData: [NSData dataWithBytes:(void*)&s length:sizeof(int)]];
        NSMutableString *str = [NSMutableString stringWithCapacity: [[files objectAtIndex: i] length] + [path length] + 1];
        [str appendString: path];
        [str appendString: @"/"];
        [str appendString: [files objectAtIndex: i]];
        NSData *d = [NSData dataWithContentsOfFile: str];
        if(d == nil) {
            NSLog(@"Failed to initialize NSData for file %@. (Is it a dir?)", str);
        }
        [fh writeData: d];
    }

    NSLog(@"Operated on %i files.", [files count]);

    [fh closeFile];
    [pool drain];
    return 0;
}