//
//  PublicKeyInfo.h
//  
//
//  Created by Pallas on 7/30/16.
//
//  Complete

#import "ASN1Object.h"

@class SignatureInfo;
@class SignatureEx;
@class ObjectSignature;

static int PublicKeyInfo_APPLICATION_TAG = 1;

@interface PublicKeyInfo : ASN1Object {
@private
    int                                     _service;
    int                                     _type;
    NSMutableData *                         _key;
    SignatureInfo *                         _signatureInfo;
    SignatureEx *                             _signature;
    ObjectSignature *                       _extendedSignature;
}

- (int)service;
- (int)type;
- (SignatureEx*)signature;
- (ObjectSignature*)extendedSignature;

- (id)initWithService:(int)service withType:(int)type withKey:(NSMutableData*)key withSignatureInfo:(SignatureInfo*)signatureInfo withSignature:(SignatureEx*)signature withExtendedSignature:(ObjectSignature*)extendedSignature;
- (id)initWithASN1Primitive:(ASN1Primitive*)primitive;

- (NSMutableData*)getKey;
- (SignatureInfo*)buildAndTime;

@end
