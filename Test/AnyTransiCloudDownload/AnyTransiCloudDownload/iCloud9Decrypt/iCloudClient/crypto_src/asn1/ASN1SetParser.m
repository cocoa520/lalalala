//
//  ASN1SetParser.m
//  crypto
//
//  Created by JGehry on 6/1/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1SetParser.h"
#import "ASN1Set.h"
#import "ASN1Sequence.h"

@interface ASN1SetParser ()

@property (nonatomic, assign) int index;

@end

@implementation ASN1SetParser
@synthesize index = _index;

- (int)max {
    static int _max = 0;
    @synchronized(self) {
        if (_max == 0) {
            ASN1Set *asn1Set = [[ASN1Set alloc] init];
            _max = [asn1Set size];
#if !__has_feature(objc_arc)
    if (asn1Set) [asn1Set release]; asn1Set = nil;
#endif
        }
    }
    return _max;
}

- (ASN1Encodable *)readObject {
    if (self.index == [self max]) {
        return nil;
    }
    ASN1Set *asn1Set = [[ASN1Set alloc] init];
    ASN1Encodable *localASN1Encodable = [asn1Set getObjectAt:self.index++];
#if !__has_feature(objc_arc)
    if (asn1Set) [asn1Set release]; asn1Set = nil;
#endif
    if ([localASN1Encodable isKindOfClass:[ASN1Sequence class]]) {
        return [((ASN1Sequence *)localASN1Encodable) parser];
    }
    if ([localASN1Encodable isKindOfClass:[ASN1Set class]]) {
        return [((ASN1Set *)localASN1Encodable) parser];
    }
    return localASN1Encodable;
}

- (ASN1Primitive *)getLoadedObject {
    return nil;
}

- (ASN1Primitive *)toASN1Primitive {
    return nil;
}

@end
