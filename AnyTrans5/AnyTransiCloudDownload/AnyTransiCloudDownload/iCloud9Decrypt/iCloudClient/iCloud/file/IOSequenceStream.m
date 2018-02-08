//
//  IOSequenceStream.m
//  
//
//  Created by Pallas on 8/30/16.
//
//  Complete

#import "IOSequenceStream.h"
#import "CategoryExtend.h"

@interface IOSequenceStream ()

@property (nonatomic, readwrite, retain) NSMutableArray *streams;
@property (nonatomic, readwrite, retain) NSEnumerator *it;
@property (nonatomic, readwrite, retain) NSFileHandle *is;

@end

@implementation IOSequenceStream
@synthesize streams = _streams;
@synthesize it = _it;
@synthesize is = _is;

- (id)initWithEnumerator:(NSEnumerator*)streams {
    if (self = [super init]) {
        if (!streams) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"streams" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setIt:streams];
        [self next];
        return self;
    } else {
        return nil;
    }
}

- (id)initWithStreams:(NSMutableArray*)streams {
    if (self = [self initWithEnumerator:[streams objectEnumerator]]) {
        [self setStreams:streams];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setStreams:nil];
    [self setIt:nil];
    [self setIs:nil];
    [super dealloc];
#endif
}

- (void)next {
    if ([self is]) {
        [[self is] closeFile];
    }
    
    NSFileHandle *tmpStream = [[self it] nextObject];
    if (tmpStream) {
        [self setIs:tmpStream];
    } else {
        [self setIs:nil];
    }
}

- (void)close {
    if ([self is]) {
        [[self is] closeFile];
    }
}

- (int)available {
    return [self is] ? (int)[[self is] available] : 0;
}

- (int)read {
    while ([self is]) {
        int c = [[self is] readByte];
        if (c != -1) {
            return c;
        }
        [self next];
    }
    return -1;
}

- (int)read:(NSMutableData*)buffer {
    return [self read:buffer withOff:0 withLen:(int)(buffer.length)];
}

- (int)read:(NSMutableData*)buffer withOff:(int)offset withLen:(int)count {
    if (!buffer) {
        @throw [NSException exceptionWithName:@"NullPointer" reason:@"buffer" userInfo:nil];
    }
    if ([self is] == nil) {
        return -1;
    }
    if (offset < 0 || count < 0 || count > buffer.length - offset) {
        @throw [NSException exceptionWithName:@"IndexOutOfBounds" reason:@"IOSequenceStream" userInfo:nil];
    }
    if (count == 0) {
        return 0;
    }
    do {
        int n = [[self is] read:buffer withOffset:offset withCount:count];
        if (n > 0) {
            return n;
        }
        [self next];
    } while ([self is]);
    return -1;
}

@end
