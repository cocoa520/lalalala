//
//  NOS.h
//  
//
//  Created by Pallas on 7/30/16.
//
//  Complete

#import "ASN1Object.h"

@class ASN1Primitive;

@interface NOS : ASN1Object {
@private
    int                                 _x;
    NSNumber *                          _y;
    NSMutableData *                     _key;
}

- (id)initWithX:(int)x withY:(NSNumber*)y withKey:(NSMutableData*)key;
- (id)initWithASN1Primitive:(ASN1Primitive*)primitive;

- (int)getX;
- (NSNumber*)getY;
- (NSMutableData*)getKey;

@end
