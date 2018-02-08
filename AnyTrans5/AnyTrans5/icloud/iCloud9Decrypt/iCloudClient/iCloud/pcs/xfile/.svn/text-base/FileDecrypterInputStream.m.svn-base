//
//  FileDecrypterInputStream.m
//  
//
//  Created by Pallas on 4/26/16.
//
//  Complete

#import "FileDecrypterInputStream.h"
#import "BlockDecrypter.h"
#import "CategoryExtend.h"

static int FileDecrypterInputStream_BLOCK_LENGTH = 0x1000;

@interface FileDecrypterInputStream ()

@property (nonatomic, readwrite, retain) Stream *input;
@property (nonatomic, readwrite, retain) BlockDecrypter *decrypter;
@property (nonatomic, readwrite, retain) NSMutableData *iN;
@property (nonatomic, readwrite, retain) NSMutableData *oUT;
@property (nonatomic, assign) int pos;
@property (nonatomic, assign) int limit;
@property (nonatomic, assign) int block;

@end

@implementation FileDecrypterInputStream
@synthesize input = _input;
@synthesize decrypter = _decrypter;
@synthesize iN = _iN;
@synthesize oUT = _oUT;
@synthesize pos = _pos;
@synthesize limit = _limit;
@synthesize block = _block;

- (id)initWithInput:(Stream*)input withBlockDecrypter:(BlockDecrypter*)blockDecrypter withBlockLength:(int)blockLength {
    if (self = [super init]) {
        if (input == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"input" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (blockDecrypter == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"blockDecrypter" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setInput:input];
        [self setDecrypter:blockDecrypter];
        NSMutableData *tmpIn = [[NSMutableData alloc] initWithSize:blockLength];
        [self setIN:tmpIn];
        NSMutableData *tmpOut = [[NSMutableData alloc] initWithSize:blockLength];
        [self setOUT:tmpOut];
#if !__has_feature(objc_arc)
        if (tmpIn) [tmpIn release]; tmpIn = nil;
        if (tmpOut) [tmpOut release]; tmpOut = nil;
#endif
        [self setPos:0];
        [self setLimit:0];
        [self setBlock:0];
        return self;
    }else {
        return nil;
    }
}

- (id)initWithInput:(Stream*)input withBlockDecrypter:(BlockDecrypter*)blockDecrypter {
    if (self = [self initWithInput:input withBlockDecrypter:blockDecrypter withBlockLength:FileDecrypterInputStream_BLOCK_LENGTH]) {
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setInput:nil];
    [self setDecrypter:nil];
    [self setIN:nil];
    [self setOUT:nil];
    [super dealloc];
#endif
}

- (int)read {
    NSMutableData *b = [[NSMutableData alloc] initWithSize:1];
    [self read:b];
    int ret = ((Byte*)(b.bytes))[0];
#if !__has_feature(objc_arc)
    if (b) [b release]; b = nil;
#endif
    return ret;
}

- (int)read:(NSMutableData*)buffer withOff:(int)offset withLen:(int)count {
    int read = 0;
    while (read < count) {
        if ([self pos] >= [self limit]) {
            [self fill];
        }
        if ([self limit] == -1) {
            return read == 0 ? -1 : read;
        }
        
        int remaining = [self limit] - [self pos];
        int length = count > remaining ? remaining : count;
        
        [buffer copyFromIndex:(offset + read) withSource:[self oUT] withSourceIndex:[self pos] withLength:length];
        
        self.pos += length;
        read += length;
    }
    return read;
}

- (void)fill {
    [self setLimit:[self readBuffer]];
    if ([self limit] == -1) {
        return;
    }
    [self setPos:0];
    int processed = [[self decrypter] decryptWithBlock:[self block] withInData:[self iN] withInDataOff:0 withLength:[self limit] withOutData:[self oUT] withOutDataOff:[self pos]];
    if (processed != _limit) {
    }
    self.block++;
}

- (int)readBuffer {
    if ([self limit] == -1) {
        return -1;
    }
    int offset = 0;
    do {
        int read = [[self input] read:[self iN] withOff:offset withLen:((int)([self iN].length) - offset)];
        if (read == -1) {
            return offset == 0 ? -1 : offset;
        }
        offset += read;
    } while (offset < (int)([self iN].length));
    return offset;
}

- (void)close {
    [[self input] close];
}

@end
