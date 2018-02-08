//
//  BackupEscrow.h
//  
//
//  Created by Pallas on 7/28/16.
//
//  Complete

#import "ASN1Object.h"

static int BackupEscrow_APPLICATION_TAG = 4;

@class ASN1Primitive;

@interface BackupEscrow : ASN1Object {
@private
    NSMutableData *                         _wrappedKey;
    NSMutableData *                         _data;
    NSMutableData *                         _x;
    int                                     _y;
    NSMutableData *                         _masterKeyPublic;
}

- (id)initWithWrappedKey:(NSMutableData*)wrappedKey withData:(NSMutableData*)data withX:(NSMutableData*)x withY:(int)y withMasterKeyPublic:(NSMutableData*)masterKeyPublic;
- (id)initWithASN1Primitive:(ASN1Primitive*)primitive;

- (NSMutableData*)getWrappedKey;
- (NSMutableData*)getData;
- (NSMutableData*)getX;
- (int)y;
- (NSMutableData*)getMasterKeyPublic;

@end
