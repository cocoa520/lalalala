//
//  BEROutputStream.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "BEROutputStream.h"

@implementation BEROutputStream

- (instancetype)initParamOutputStream:(Stream *)paramOutputStream
{
    self = [super initDERParamOutputStream:paramOutputStream];
    if (self) {
    }
    return self;
}

- (void)writeObject:(id)paramObject {
    if (!paramObject) {
        [self writeNull];
    }else if ([paramObject isKindOfClass:[ASN1Primitive class]]) {
        [((ASN1Primitive *)paramObject) encode:self];
    }else if ([paramObject isKindOfClass:[ASN1Encodable class]]) {
        [[((ASN1Encodable *)paramObject) toASN1Primitive] encode:self];
    }else {
        @throw [NSException exceptionWithName:NSGenericException reason:@"object not BEREncodable" userInfo:nil];
    }
}

@end
