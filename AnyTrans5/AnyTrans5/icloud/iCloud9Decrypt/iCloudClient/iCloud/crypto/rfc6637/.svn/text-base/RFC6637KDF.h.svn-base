//
//  RFC6637KDF.h
//  
//
//  Created by Pallas on 7/28/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class Digest;
@class ASN1ObjectIdentifier;
@class ECPoint;

@interface RFC6637KDF : NSObject {
@private
    Digest *                        _digestFactory;
    NSMutableData *                 _formattedOid;
    Byte                            _publicKeyAlgID;
    Byte                            _symAlgID;
    Byte                            _kdfHashID;
}

- (id)initWithDigest:(Digest*)digestFactory withFormattedOid:(NSMutableData*)formattedOid withPublicKeyAlgID:(Byte)publicKeyAlgID withSymAlgID:(Byte)symAlgID withKdfHashID:(Byte)kdfHashID;
- (id)initWithDigest:(Digest*)digestFactory withOid:(ASN1ObjectIdentifier*)oid withPublicKeyAlgID:(Byte)publicKeyAlgID withSymAlgID:(Byte)symAlgID withKdfHashID:(Byte)kdfHashID;

- (NSMutableData*)apply:(ECPoint*)S withFingerprint:(NSMutableData*)fingerprint;
+ (NSMutableData*)formatOid:(ASN1ObjectIdentifier*)oid;

@end
