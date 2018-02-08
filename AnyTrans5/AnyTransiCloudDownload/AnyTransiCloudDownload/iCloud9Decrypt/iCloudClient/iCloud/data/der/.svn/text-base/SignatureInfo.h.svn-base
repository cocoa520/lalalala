//
//  SignatureInfo.h
//  
//
//  Created by Pallas on 7/29/16.
//
//  Complete

#import "ASN1Object.h"

@class ASN1Primitive;

@interface SignatureInfo : ASN1Object {
@private
    int                                 _version;
    NSMutableData *                     _info;
}

- (id)initWithVersion:(int)version withInfo:(NSMutableData*)info;
- (id)initWithASN1Primitive:(ASN1Primitive*)primitive;

- (int)getVersion;
- (NSMutableData*)getInfo;

@end
