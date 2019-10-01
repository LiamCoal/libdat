#include <GNUstep/Foundation/Foundation.h>
#include <cstring>

int main(int argc, char const **argv) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    if(argc < 3) {
        NSLog(@"Usage: %s <datfile> <filename>", argv[0]);
        return 1;
    }

    NSString *filer = [NSString stringWithUTF8String:argv[1]];
    NSString *filew = [NSString stringWithUTF8String:argv[2]];

    [[NSFileManager defaultManager] createFileAtPath: filew contents: [[NSData alloc] init] attributes: nil];

    NSFileHandle *fhr = [NSFileHandle fileHandleForReadingAtPath: filer];
    NSFileHandle *fhw = [NSFileHandle fileHandleForWritingAtPath: filew];

    NSLog(@"Checking File Header...");
    char *c = (char *)[[fhr readDataOfLength: 4] bytes];

    if(c[0] != 'D' || c[1] != 'A' || c[2] != 'T' || c[3] != 0x1a) {
        NSLog(@"File Header not correct.");
        return 1;
    } else NSLog(@"File Header intact.");

    [fhr seekToFileOffset: 512];

    while(true) {
        int size = 0;
        unsigned long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:filew error:NULL] fileSize];
        c = (char *)[[fhr readDataOfLength: 11] bytes];
        NSLog(@"Checking %s", c);
        size = *(int*)[[fhr readDataOfLength: sizeof(int)] bytes];
        NSLog(@"%s has size %i", c, size);
        if(strcmp(c, [filew UTF8String]) == 0) {
            NSLog(@"Found file, writing.");
            [fhw writeData: [NSData dataWithBytes: (void*)[[fhr readDataOfLength: size] bytes] length: size]];
            NSLog(@"Wrote %i bytes", size);
            break;
        }
        if([fhr offsetInFile] + size < fileSize) {
            NSLog(@"Seeking to %i", [fhr offsetInFile] + size);
            [fhr seekToFileOffset: [fhr offsetInFile] + size];
        }
    }

    [fhr closeFile];
    [fhw closeFile];
    [pool drain];
    return 0;
}