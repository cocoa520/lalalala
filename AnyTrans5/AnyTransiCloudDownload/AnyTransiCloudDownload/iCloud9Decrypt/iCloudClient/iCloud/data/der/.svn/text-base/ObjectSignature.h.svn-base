//
//  ObjectSignature.h
//  
//
//  Created by Pallas on 7/30/16.
//
//  Complete

#import "ASN1Object.h"

@class SignatureInfo;
@class SignatureEx;
@class ASN1Primitive;

@interface ObjectSignature : ASN1Object {
@private
    SignatureInfo *                         _signatureInfo;
    SignatureEx *                             _signature;
}

- (SignatureInfo*)signatureInfo;
- (SignatureEx*)signature;

- (id)initWithSignatureInfo:(SignatureInfo*)signatureInfo withSignature:(SignatureEx*)signature;
- (id)initWithASN1Primitive:(ASN1Primitive*)primitive;

@end
