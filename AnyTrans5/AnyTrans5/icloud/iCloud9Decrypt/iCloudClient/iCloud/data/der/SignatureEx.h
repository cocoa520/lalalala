//
//  Signature.h
//  
//
//  Created by Pallas on 7/29/16.
//
//  Complete

#import "ASN1Object.h"

@class ASN1Primitive;

@interface SignatureEx : ASN1Object {
@private
    NSMutableData *                         _signerKeyID;
    int                                     _type;
    NSMutableData *                         _data;
}

- (id)initWithSignerKeyID:(NSMutableData*)signerKeyID withType:(int)type withData:(NSMutableData*)data;
- (id)initWithASN1Primitive:(ASN1Primitive*)primitive;

- (NSMutableData*)getSignerKeyID;
- (int)getType;
- (NSMutableData*)getData;

@end
