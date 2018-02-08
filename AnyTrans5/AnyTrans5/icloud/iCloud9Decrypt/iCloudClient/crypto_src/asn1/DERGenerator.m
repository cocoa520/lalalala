//
//  DERGenerator.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DERGenerator.h"
#import "Arrays.h"

@interface DERGenerator ()

@property (nonatomic, assign) BOOL tagged;
@property (nonatomic, assign) BOOL isExplicit;
@property (nonatomic, assign) int tagNo;

@end

@implementation DERGenerator
@synthesize tagged = _tagged;
@synthesize isExplicit = _isExplicit;
@synthesize tagNo = _tagNo;

- (instancetype)initParamOutputStream:(Stream *)paramOutputStream
{
    if (self = [super initParamOutputStream:paramOutputStream]) {
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamOutputStream:(Stream *)paramOutputStream paramInt:(int)paramInt paramBoolean:(BOOL)paramBoolean
{
    if (self = [super initParamOutputStream:paramOutputStream]) {
        self.tagged = YES;
        self.isExplicit = paramBoolean;
        self.tagNo = paramInt;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (void)writeLength:(Stream *)paramOutputStream paramInt:(int)paramInt {
    if (paramInt > 127) {
        int i = 1;
        int j = paramInt;
        while (j >>= 8 != 0) {
            i++;
        }
        [paramOutputStream writeWithByte:((Byte)(i | 0x80))];
        for (int k = (i - 1) * 8; k >= 0; k -= 8) {
            [paramOutputStream writeWithByte:((Byte)(paramInt >> k))];
        }
    }else {
        [paramOutputStream writeWithByte:((Byte)paramInt)];
    }
}

- (void)writeDEREncoded:(Stream *)paramOutputStream paramInt:(int)paramInt paramArrayOfByte:(NSMutableData *)paramArrayOfByte {
    [paramOutputStream writeWithByte:paramInt];
    [self writeLength:paramOutputStream paramInt:(int)[paramArrayOfByte length]];
    [paramOutputStream write:paramArrayOfByte];
}

- (void)writeDEREncoded:(int)paramInt paramArrayOfByte:(NSMutableData *)paramArrayOfByte {
    if (self.tagged) {
        int i = self.tagNo | 0x80;
        if (self.isExplicit) {
            int j = self.tagNo | 0x20 | 0x80;
            MemoryStreamEx *localMemoryStream = [MemoryStreamEx memoryStreamEx];
            [self writeDEREncoded:localMemoryStream paramInt:paramInt paramArrayOfByte:paramArrayOfByte];
            NSMutableData *data = [localMemoryStream availableData];
            NSMutableData *mutData = [Arrays copyOfWithData:data withNewLength:(int)[data length]];
            [self writeDEREncoded:self.oUT paramInt:j paramArrayOfByte:mutData];
#if !__has_feature(objc_arc)
            if (mutData) [mutData release]; mutData = nil;
#endif
        }else if ((paramInt & 0x20) != 0) {
            [self writeDEREncoded:self.oUT paramInt:i | 0x20 paramArrayOfByte:paramArrayOfByte];
        }else {
            [self writeDEREncoded:self.oUT paramInt:i paramArrayOfByte:paramArrayOfByte];
        }
    }else {
        [self writeDEREncoded:self.oUT paramInt:paramInt paramArrayOfByte:paramArrayOfByte];
    }
}

@end
