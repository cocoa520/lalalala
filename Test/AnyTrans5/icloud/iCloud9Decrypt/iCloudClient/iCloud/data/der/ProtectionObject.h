//
//  ProtectionObject.h
//  
//
//  Created by Pallas on 7/30/16.
//
//  Complete

#import "ASN1Object.h"

@class NOS;
@class ASN1Primitive;

@interface ProtectionObject : ASN1Object {
@private
    NSMutableSet *                          _xSet; // NSMutableData
    NOS *                                   _masterKey;
    NSMutableSet *                          _masterKeySet; //NOS
}

- (id)initWithXSet:(NSMutableSet*)xSet withMasterKey:(NOS*)masterKey withMasterKeySet:(NSMutableSet*)masterKeySet;
- (id)initWithASN1Primitive:(ASN1Primitive*)primitive;

- (NSMutableSet*)getXSet;
- (NOS*)getMasterKey;
- (NSMutableSet*)getMasterKeySet;

@end
