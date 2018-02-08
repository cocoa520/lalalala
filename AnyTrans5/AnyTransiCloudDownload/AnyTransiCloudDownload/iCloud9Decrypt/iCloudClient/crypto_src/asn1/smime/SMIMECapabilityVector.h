//
//  SMIMECapabilityVector.h
//  crypto
//
//  Created by JGehry on 6/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASN1EncodableVector.h"
#import "ASN1ObjectIdentifier.h"

@interface SMIMECapabilityVector : NSObject {
@private
    ASN1EncodableVector *_capabilities;
}

- (void)addCapability:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier;
- (void)addCapability:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramInt:(int)paramInt;
- (void)addCapability:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (ASN1EncodableVector *)toASN1EncodableVector;

@end
