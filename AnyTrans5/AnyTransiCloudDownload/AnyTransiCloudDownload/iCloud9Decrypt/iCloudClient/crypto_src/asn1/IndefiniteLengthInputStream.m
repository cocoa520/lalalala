//
//  IndefiniteLengthInputStream.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "IndefiniteLengthInputStream.h"

@interface IndefiniteLengthInputStream ()

@property (nonatomic, assign) int b1;
@property (nonatomic, assign) int b2;
@property (nonatomic, assign) BOOL eofReached;
@property (nonatomic, assign) BOOL eofOn00;

@end

@implementation IndefiniteLengthInputStream
@synthesize b1 = _b1;
@synthesize b2 = _b2;
@synthesize eofReached = _eofReached;
@synthesize eofOn00 = _eofOn00;

- (instancetype)initParamInputStream:(Stream *)paramInputStream paramInt:(int)paramInt
{
    self = [super initParamInputStream:paramInputStream paramInt:paramInt];
    if (self) {
        self.b1 = (int)[paramInputStream read];
        self.b2 = (int)[paramInputStream read];
        if (self.b2 < 0) {
            [NSException exceptionWithName:NSGenericException reason:@"" userInfo:nil];
        }
        [self checkForEof];
    }
    return self;
}

- (void)setEofOn00:(BOOL)paramBoolean {
    self.eofOn00 = paramBoolean;
    [self checkForEof];
}

- (BOOL)checkForEof {
    if (!self.eofReached && self.eofOn00 && (self.b1 == 0) && (self.b2 == 0)) {
        self.eofReached = YES;
        [self setParentEofDetect:YES];
    }
    return self.eofReached;
}

- (int)readParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramInt1:(int)paramInt1 paramInt2:(int)paramInt2 {
    if (self.eofOn00 || (paramInt2 < 3)) {
        return [super read:paramArrayOfByte withOff:paramInt1 withLen:paramInt2];
    }
    if (self.eofReached) {
        return -1;
    }
    int i = [self.iN read:paramArrayOfByte withOff:(paramInt1 + 2) withLen:(paramInt2 - 2)];
    if (i < 0) {
        @throw [NSException exceptionWithName:NSGenericException reason:@"" userInfo:nil];
    }
    ((Byte *)[paramArrayOfByte bytes])[paramInt1] = ((Byte)self.b1);
    ((Byte *)[paramArrayOfByte bytes])[paramInt1 + 1] = ((Byte)self.b2);
    self.b1 = [self read];
    self.b2 = [self read];
    if (self.b2 < 0) {
        @throw [NSException exceptionWithName:NSGenericException reason:@"" userInfo:nil];
    }
    return i + 2;
}

- (int)read {
    if ([self checkForEof]) {
        return -1;
    }
    int i = [self read];
    if (i < 0) {
        @throw [NSException exceptionWithName:NSGenericException reason:@"" userInfo:nil];
    }
    int j = self.b1;
    self.b1 = self.b2;
    self.b2 = i;
    return j;
}

@end
