//
//  EncryptedKeys.h
//  
//
//  Created by Pallas on 7/30/16.
//
//  Complete

#import "ASN1Object.h"

@class ASN1Primitive;

@interface EncryptedKeys : ASN1Object {
@private
    int                                     _x;
    NSMutableSet *                          _encryptedKeySet;
    NSMutableData *                         _cont0;
}

- (id)initWithX:(int)x withEncryptedKeySet:(NSSet*)encryptedKeySet withCont0:(NSMutableData*)cont0;
- (id)initWithASN1Primitive:(ASN1Primitive*)primitive;

- (int)getX;
- (NSMutableSet*)getEncryptedKeySet;
- (NSMutableData*)getCont0;

@end
