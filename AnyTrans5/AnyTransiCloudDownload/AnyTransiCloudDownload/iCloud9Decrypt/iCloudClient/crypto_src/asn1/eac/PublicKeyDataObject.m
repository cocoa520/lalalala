//
//  PublicKeyDataObject.m
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PublicKeyDataObject.h"
#import "ASN1Sequence.h"
#import "EACObjectIdentifiers.h"
#import "ECDSAPublicKey.h"
#import "RSAPublicKeyEAC.h"

@implementation PublicKeyDataObject

+ (PublicKeyDataObject *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[PublicKeyDataObject class]]) {
        return (PublicKeyDataObject *)paramObject;
    }
    if (paramObject) {
        ASN1Sequence *localASN1Sequence = [ASN1Sequence getInstance:paramObject];
        ASN1ObjectIdentifier *localASN1ObjectIdentifier = [ASN1ObjectIdentifier getInstance:[localASN1Sequence getObjectAt:0]];
        if ([localASN1ObjectIdentifier on:[EACObjectIdentifiers id_TA_ECDSA]]) {
            return [[[ECDSAPublicKey alloc] initParamASN1Sequence:localASN1Sequence] autorelease];
        }
        return [[[RSAPublicKeyEAC alloc] initParamASN1Sequence:localASN1Sequence] autorelease];
    }
    return nil;
}


- (ASN1ObjectIdentifier *)getUsage {
    return nil;
}

@end
