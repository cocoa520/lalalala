//
//  DERFactory.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DERFactory.h"
#import "DERSequence.h"
#import "DERSet.h"
#import "DLSequence.h"
#import "DLSet.h"

@implementation DERFactory

+ (ASN1Sequence *)EMPTY_SEQUENCE {
    static ASN1Sequence *_EMPTY_SEQUENCE = nil;
    @synchronized(self) {
        if (!_EMPTY_SEQUENCE) {
            _EMPTY_SEQUENCE = [[DERSequence alloc] init];
        }
    }
    return _EMPTY_SEQUENCE;
}

+ (ASN1Set *)EMPTY_SET {
    static ASN1Set *_EMPTY_SET = nil;
    @synchronized(self) {
        if (!_EMPTY_SET) {
            _EMPTY_SET = [[DERSet alloc] init];
        }
    }
    return _EMPTY_SET;
}

+ (ASN1Sequence *)createSequence:(ASN1EncodableVector *)paramASN1EncodableVector {
    DLSequence *dlSequence = [[[DLSequence alloc] initDLParamASN1EncodableVector:paramASN1EncodableVector] autorelease];
    return [paramASN1EncodableVector size] < 1 ? [DERFactory EMPTY_SEQUENCE] : dlSequence;
}

+ (ASN1Set *)createSet:(ASN1EncodableVector *)paramASN1EncodableVector {
    DLSet *dlSet = [[[DLSet alloc] initDLParamASN1EncodableVector:paramASN1EncodableVector] autorelease];
    return [paramASN1EncodableVector size] < 1 ? [DERFactory EMPTY_SET] : dlSet;
}

@end
