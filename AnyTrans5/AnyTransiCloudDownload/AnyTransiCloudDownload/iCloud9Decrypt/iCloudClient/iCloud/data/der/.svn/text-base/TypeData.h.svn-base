//
//  TypeData.h
//  
//
//  Created by Pallas on 7/29/16.
//
//  Complete

#import "ASN1Object.h"

@class ASN1Primitive;

@interface TypeData : ASN1Object {
@private
    int                             _type;
    NSMutableData *                 _data;
}

- (id)initWithType:(int)type withData:(NSMutableData*)data;
- (id)initWithASN1Primitive:(ASN1Primitive*)primitive;

- (int)getType;
- (NSMutableData*)getData;

@end
