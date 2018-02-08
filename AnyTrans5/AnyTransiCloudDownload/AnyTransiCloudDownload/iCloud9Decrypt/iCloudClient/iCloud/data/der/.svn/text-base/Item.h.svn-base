//
//  Item.h
//  
//
//  Created by Pallas on 7/30/16.
//
//  Complete

#import "ASN1Object.h"

@class ASN1Primitive;

@interface Item : ASN1Object {
@private
    int                             _version;
    NSMutableData *                 _data;
}

- (id)initWithVersion:(int)version withData:(NSMutableData*)data;
- (id)initWithASN1Primitive:(ASN1Primitive*)primitive;

- (int)getVersion;
- (NSMutableData*)getOctets;

@end
