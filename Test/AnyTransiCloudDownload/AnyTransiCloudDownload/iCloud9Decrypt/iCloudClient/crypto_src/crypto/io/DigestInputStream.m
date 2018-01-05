//
//  DigestInputStream.m
//
//
//  Created by JGehry on 8/8/16.
//
//
//  Complete

#import "DigestInputStream.h"
#import "Digest.h"

@interface DigestInputStream ()

@property (nonatomic, readwrite, retain) Stream *iN;
@property (nonatomic, readwrite, retain) Digest *digest;

@end

@implementation DigestInputStream
@synthesize iN = _iN;
@synthesize digest = _digest;

- (id)initWithStream:(Stream*)stream digest:(Digest*)digest {
    if (self = [super init]) {
        [self setIN:stream];
        [self setDigest:digest];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setIN:nil];
    [self setDigest:nil];
    [super dealloc];
#endif
}

- (int)read {
    int b = [[self iN] read];
    if (b >= 0) {
        [[self digest] update:(Byte)b];
    }
    return b;
}

- (int)read:(NSMutableData*)buffer {
    return [self read:buffer withOff:0 withLen:(int)(buffer.length)];
}

- (int)read:(NSMutableData*)buffer withOff:(int)offset withLen:(int)count {
    int n = [[self iN] read:buffer withOff:offset withLen:count];
    if (n > 0) {
        [[self digest] blockUpdate:buffer withInOff:offset withLength:n];
    }
    return n;
}

- (int64_t)skip:(int64_t)n {
    return [[self iN] skip:n];
}

- (int)available {
    return [[self iN] available];
}

- (void)close {
    [[self iN] close];
}

- (void)mark:(int)readlimit {
    [[self iN] mark:readlimit];
}

- (void)reset {
    [[self iN] reset];
}

- (BOOL)markSupported {
    return [[self iN] markSupported];
}

- (Digest*)getDigest {
    return [self digest];
}

@end
