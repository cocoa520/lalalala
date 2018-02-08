//
//  InputReferenceStream.m
//
//
//  Created by JGehry on 8/8/16.
//
//
//  Complete

#import "InputReferenceStream.h"

@interface InputReferenceStream ()

@property (nonatomic, readwrite, retain) Stream *inputStream;
@property (nonatomic, readwrite, retain) id reference;

@end

@implementation InputReferenceStream
@synthesize inputStream = _inputStream;
@synthesize reference = _reference;

- (id)initWithInputStream:(Stream*)inputStream reference:(id)reference {
    if (self = [super init]) {
        if (!inputStream) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"inputStream" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (!reference) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"reference" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setInputStream:inputStream];
        [self setReference:reference];
        return self;
    }else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setInputStream:nil];
    [self setReference:nil];
    [super dealloc];
#endif
}

- (int)read {
    return [[self inputStream] read];
}

- (BOOL)markSupported {
    return [[self inputStream] markSupported];
}

- (void)reset {
    [[self inputStream] reset];
}

- (void)mark:(int)readlimit {
    [[self inputStream] mark:readlimit];
}

- (void)close {
    [[self inputStream] close];
}

- (int)available {
    return [[self inputStream] available];
}

- (int64_t)skip:(int64_t)n {
    return [[self inputStream] skip:n];
}

- (int)read:(NSMutableData*)buffer withOff:(int)offset withLen:(int)count {
    return [[self inputStream] read:buffer withOff:offset withLen:count];
}

- (int)read:(NSMutableData*)buffer {
    return [[self inputStream] read:buffer];
}

@end
