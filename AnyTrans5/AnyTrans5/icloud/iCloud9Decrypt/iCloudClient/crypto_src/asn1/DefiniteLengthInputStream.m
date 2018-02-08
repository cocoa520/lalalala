//
//  DefiniteLengthInputStream.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DefiniteLengthInputStream.h"
#import "CategoryExtend.h"

@interface DefiniteLengthInputStream ()

@property (nonatomic, assign) int originalLength;
@property (nonatomic, assign) int remaining;

@end

@implementation DefiniteLengthInputStream
@synthesize originalLength = _originalLength;
@synthesize remaining = _remaining;

+ (NSMutableData *)EMPTY_BYTES {
    static NSMutableData *_EMPTY_BYTES = nil;
    @synchronized(self) {
        if (!_EMPTY_BYTES) {
            _EMPTY_BYTES = [[NSMutableData alloc] initWithSize:0];
        }
    }
    return _EMPTY_BYTES;
}

- (instancetype)initParamInputStream:(Stream *)paramInputStream paramInt:(int)paramInt
{
    if (self = [super initParamInputStream:paramInputStream paramInt:paramInt]) {
        if (paramInt < 0) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"negative lengths not allowed" userInfo:nil];
        }
        
        self.originalLength = paramInt;
        self.remaining = paramInt;
        if (paramInt == 0) {
            [self setParentEofDetect:YES];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (int)getRemaining {
    return self.remaining;
}

- (int)read {
    if (self.remaining == 0) {
        return -1;
    }
    int i = [self.iN read];
    if (i < 0) {
        @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"DEF length %d object truncated by %d", self.originalLength, self.remaining] userInfo:nil];
    }
    if (--self.remaining == 0) {
        [self setParentEofDetect:YES];
    }
    return i;
}

- (int)readParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramInt1:(int)paramInt1 paramInt2:(int)paramInt2 {
    if (self.remaining == 0) {
        return -1;
    }
    int i = (int)MIN(paramInt2, self.remaining);
    int j = [self read:paramArrayOfByte withOff:paramInt1 withLen:i];
    if (j < 0) {
        @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"DEF length %d object truncated by %d", self.originalLength, self.remaining] userInfo:nil];
    }
    if ((self.remaining -= j) == 0) {
        [self setParentEofDetect:YES];
    }
    return j;
}

- (NSMutableData *)toByteArray {
    if (self.remaining == 0) {
        return [DefiniteLengthInputStream EMPTY_BYTES];
    }
    NSMutableData *bytes = [[[NSMutableData alloc] initWithSize:self.remaining] autorelease];
    if ((self.remaining -= [Stream readFully:[self iN] withBuf:bytes]) != 0) {
        @throw [NSException exceptionWithName:@"EOF" reason:[NSString stringWithFormat:@"DEF length %d object truncated by %d", self.originalLength, self.remaining] userInfo:nil];
    }
    [self setParentEofDetect:YES];
    return bytes;
}

@end
