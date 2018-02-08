//
//  BERFactory.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "BERFactory.h"

@implementation BERFactory

+ (BERSequence *)EMPTY_SEQUENCE {
    static BERSequence *_EMPTY_SEQUENCE = nil;
    @synchronized(self) {
        if (!_EMPTY_SEQUENCE) {
            _EMPTY_SEQUENCE = [[BERSequence alloc] init];
        }
    }
    return _EMPTY_SEQUENCE;
}

+ (BERSet *)EMPTY_SET {
    static BERSet *_EMPTY_SET = nil;
    @synchronized(self) {
        if (!_EMPTY_SET) {
            _EMPTY_SET = [[BERSet alloc] init];
        }
    }
    return _EMPTY_SET;
}

+ (BERSequence *)createSequence:(ASN1EncodableVector *)paramASN1EncodableVector {
    BERSequence *sequence = [[[BERSequence alloc] initBERParamASn1EncodableVector:paramASN1EncodableVector] autorelease];
    return [paramASN1EncodableVector size] < 1 ? [BERFactory EMPTY_SEQUENCE] : sequence;
}

+ (BERSet *)createSet:(ASN1EncodableVector *)paramASN1EncodableVector {
    BERSet *set = [[[BERSet alloc] initBERParamASN1EncodableVector:paramASN1EncodableVector] autorelease];
    return [paramASN1EncodableVector size] < 1 ? [BERFactory EMPTY_SET] : set;
}

@end
