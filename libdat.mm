#include "libdat.h"

int read(NSString *datfile, NSString *outfile) {
    NSString *filer = datfile;
    NSString *filew = outfile;

    [[NSFileManager defaultManager] createFileAtPath: filew contents: [[NSData alloc] init] attributes: nil];

    NSFileHandle *fhr = [NSFileHandle fileHandleForReadingAtPath: filer];
    NSFileHandle *fhw = [NSFileHandle fileHandleForWritingAtPath: filew];

    char *c = (char *)[[fhr readDataOfLength: 4] bytes];

    if(c[0] != 'D' || c[1] != 'A' || c[2] != 'T' || c[3] != 0x1a) return 1;

    [fhr seekToFileOffset: 512];

    int i = 0;

    while(i < 1000) {
        int size = 0;
        unsigned long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:filew error:NULL] fileSize];
        c = (char *)[[fhr readDataOfLength: 11] bytes];
        size = *(int*)[[fhr readDataOfLength: sizeof(int)] bytes];
        if(strcmp(c, [filew UTF8String]) == 0) {
            [fhw writeData: [NSData dataWithBytes: (void*)[[fhr readDataOfLength: size] bytes] length: size]];
            break;
        }
        if([fhr offsetInFile] + size < fileSize) {
            [fhr seekToFileOffset: [fhr offsetInFile] + size];
        }
        i++;
    }

    if(i == 1000) NSLog(@"Failed to read file %@ from %@", filew, filer);

    [fhr closeFile];
    [fhw closeFile];
    return 0;
}

int read(NSString *datfile, NSString *filename, NSFileHandle *file) {
    int r = read(datfile, filename);
    if(r == 0) file = [NSFileHandle fileHandleForReadingAtPath: filename];
    return r;
}

int store(NSString *datfile, NSString *directory) {
    NSString *file = datfile;
    NSString *path = directory;

    NSFileHandle *fh = [NSFileHandle fileHandleForWritingAtPath: file];

    [fh writeData: [NSData dataWithBytes: "DAT\x1a" length: 4]];
    if(fh == nil) {
        return 1;
    }
    [fh seekToFileOffset: 512];

    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];

    for(unsigned long i = 0; i < [files count]; i++) {
        [fh writeData: [NSData dataWithBytes:(void*)[[files objectAtIndex: i] UTF8String] length:11]];
        NSMutableString *str = [NSMutableString stringWithCapacity: [[files objectAtIndex: i] length] + [path length] + 1];
        [str appendString: path];
        [str appendString: @"/"];
        [str appendString: [files objectAtIndex: i]];
        int s = [[[NSFileManager defaultManager] attributesOfItemAtPath:str error:NULL] fileSize];
        [fh writeData: [NSData dataWithBytes:(void*)&s length:sizeof(int)]];
        NSData *d = [NSData dataWithContentsOfFile: str];
        [fh writeData: d];
    }

    [fh closeFile];
    return 0;
}