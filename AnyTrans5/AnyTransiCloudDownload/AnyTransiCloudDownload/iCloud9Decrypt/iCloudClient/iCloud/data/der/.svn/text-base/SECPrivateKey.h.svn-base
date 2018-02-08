//
//  SECPrivateKey.h
//  
//
//  Created by Pallas on 7/30/16.
//
//  Complete

#import "ASN1Object.h"

@class ASN1Primitive;

@interface SECPrivateKey : ASN1Object {
@private
    int                                     _version;
    NSMutableData *                         _privateKey;
    NSMutableData *                         _parameters;
    NSMutableData *                         _publicKey;
}

- (int)version;

- (id)initWithVersion:(int)version withPrivateKey:(NSMutableData*)privateKey withParameters:(NSMutableData*)parameters withPublicKey:(NSMutableData*)publicKey;
- (id)initWithASN1Primitive:(ASN1Primitive*)primitive;

- (NSMutableData*)getPrivateKey;
- (NSMutableData*)getParameters;
- (NSMutableData*)getPublicKey;

@end
