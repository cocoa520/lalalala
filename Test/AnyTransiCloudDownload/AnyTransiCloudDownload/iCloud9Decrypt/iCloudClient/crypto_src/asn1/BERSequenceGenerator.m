//
//  BERSequenceGenerator.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "BERSequenceGenerator.h"
#import "BEROutputStream.h"

@implementation BERSequenceGenerator

- (instancetype)initParamOutputStream:(Stream *)paramOutputStream
{
    if (self = [super initParamOutputStream:paramOutputStream]) {
        [self writeBERHeader:48];
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
    if (self = [super initParamOutputStream:paramOutputStream paramInt:paramInt paramBoolean:paramBoolean]) {
        [self writeBERHeader:48];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (void)addObject:(ASN1Encodable *)paramASN1Encodable {
    BEROutputStream *outputStream = [[BEROutputStream alloc] initParamOutputStream:self.oUT];
    [[paramASN1Encodable toASN1Primitive] encode:outputStream];
#if !__has_feature(objc_arc)
    if (outputStream) [outputStream release]; outputStream = nil;
#endif
}

- (void)close {
    [self writeBEREnd];
}

@end
