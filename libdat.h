#ifndef LIBDATH
#define LIBDATH

#include <GNUstep/Foundation/Foundation.h>

int read(NSString *datfile, NSString *outfile);
int read(NSString *datfile, NSString *filename, NSFileHandle *file);
int store(NSString *datfile, NSString *directory);

#endif