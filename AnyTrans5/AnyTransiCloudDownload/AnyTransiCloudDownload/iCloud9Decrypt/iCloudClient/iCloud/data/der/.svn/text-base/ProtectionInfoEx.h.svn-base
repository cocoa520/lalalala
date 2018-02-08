//
//  ProtectionInfo.h
//  
//
//  Created by Pallas on 7/30/16.
//
//  Complete

#import "ASN1Object.h"

static int ProtectionInfo_APPLICATION_TAG = 1;

@class EncryptedKeys;
@class TypeData;

@interface ProtectionInfoEx : ASN1Object {
@private
    EncryptedKeys *                             _encryptedKeys;
    NSMutableData *                             _data;
    TypeData *                                  _signature;
    NSMutableData *                             _hmac;
    NSMutableData *                             _tag;
    NSMutableData *                             _cont3;
    NSMutableData *                             _cont4;
}

- (EncryptedKeys*)encryptedKeys;
- (TypeData*)signature;

- (id)initWithEncryptedKeys:(EncryptedKeys*)encryptedKeys withData:(NSMutableData*)data withSignature:(TypeData*)signature withHmac:(NSMutableData*)hmac withTag:(NSMutableData*)tag withCont3:(NSMutableData*)cont3 withCont4:(NSMutableData*)cont4;
- (id)initWithASN1Primitive:(ASN1Primitive*)primitive;

- (NSMutableData*)getData;
- (NSMutableData*)getHmac;
- (NSMutableData*)getTag;
- (NSMutableData*)getCont3;
- (NSMutableData*)getCont4;

@end
