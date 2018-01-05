//
//  PrivateKey.h
//  
//
//  Created by Pallas on 7/30/16.
//
//  Complete

#import "ASN1Object.h"

@class PublicKeyInfo;
@class ASN1Primitive;

@interface PrivateKey : ASN1Object {
@private
    NSMutableData *                                 _privateKey;
    PublicKeyInfo *                                 _publicKeyInfo;
}

- (PublicKeyInfo*)publicKeyInfo;

- (id)initWithPrivateKey:(NSMutableData*)privateKey withPublicKeyInfo:(PublicKeyInfo*)publicKeyInfo;
- (id)initWithASN1Primitive:(ASN1Primitive*)primitive;

- (NSMutableData*)getPrivateKey;

@end
