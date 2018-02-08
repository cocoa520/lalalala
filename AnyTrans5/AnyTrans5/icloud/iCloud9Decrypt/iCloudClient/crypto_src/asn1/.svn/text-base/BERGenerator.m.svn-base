//
//  BERGenerator.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "BERGenerator.h"

@interface BERGenerator ()

@property (nonatomic, assign) BOOL tagged;
@property (nonatomic, assign) BOOL isExplicit;
@property (nonatomic, assign) int tagNo;

@end

@implementation BERGenerator
@synthesize tagged = _tagged;
@synthesize isExplicit = _isExplicit;
@synthesize tagNo = _tagNo;

- (instancetype)initParamOutputStream:(Stream *)paramOutputStream
{
    self = [super initParamOutputStream:paramOutputStream];
    if (self) {
    }
    return self;
}

- (instancetype)initParamOutputStream:(Stream *)paramOutputStream paramInt:(int)paramInt paramBoolean:(BOOL)paramBoolean
{
    self = [super initParamOutputStream:paramOutputStream];
    if (self) {
        self.tagged = TRUE;
        self.isExplicit = paramBoolean;
        self.tagNo = paramInt;
    }
    return self;
}

- (Stream *)getRawOutputStream {
    return self.oUT;
}

- (void)writeHdr:(int)paramInt {
    [self.oUT writeWithByte:paramInt];
    [self.oUT writeWithByte:128];
}

- (void)writeBERHeader:(int)paramInt {
    if (self.tagged) {
        int i = (self.tagNo | 0x80);
        if (self.isExplicit) {
            [self writeHdr:(i | 0x20)];
            [self writeHdr:paramInt];
        }else if ((paramInt & 0x20) != 0) {
            [self writeHdr:(i | 0x20)];
        }else {
            [self writeHdr:i];
        }
    }else {
        [self writeHdr:paramInt];
    }
}

- (void)writeBEREnd {
    [self.oUT writeWithByte:0];
    [self.oUT writeWithByte:0];
    if ((self.tagged) && (self.isExplicit)) {
        [self.oUT writeWithByte:0];
        [self.oUT writeWithByte:0];
    }
}

@end
