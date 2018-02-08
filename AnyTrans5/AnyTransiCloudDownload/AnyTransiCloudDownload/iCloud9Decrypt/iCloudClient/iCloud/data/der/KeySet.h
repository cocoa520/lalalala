//
//  KeySet.h
//  
//
//  Created by Pallas on 7/27/16.
//
//  Complete

#import "ASN1Object.h"

static int KeySet_APPLICATION_TAG = 2;

@class ASN1Primitive;
@class SignatureInfo;

@interface KeySet : ASN1Object {
@private
    NSString *                              _name;
    NSMutableSet *                          _keys;
    NSMutableSet *                          _serviceKeyIDs;
    NSMutableData *                         _checksum;
    NSNumber *                              _flags;
    SignatureInfo *                         _signatureInfo;
}

- (NSString*)name;
- (NSNumber*)flags;
- (SignatureInfo*)signatureInfo;

- (id)initWithName:(NSString*)name withKeys:(NSSet*)keys withServices:(NSSet*)services withChecksum:(NSMutableData*)checksum withFlags:(NSNumber*)flags withSignatureInfo:(SignatureInfo*)signatureInfo;
- (id)initWithName:(NSString*)name withKeys:(NSSet*)keys withServices:(NSSet*)services withFlags:(NSNumber*)flags withSignatureInfo:(SignatureInfo*)signatureInfo;
- (id)initWithASN1Primitive:(ASN1Primitive*)primitive;

- (NSMutableSet*)getKeys;
- (NSMutableSet*)getServiceKeyIDs;
- (NSMutableData*)getChecksum;

@end