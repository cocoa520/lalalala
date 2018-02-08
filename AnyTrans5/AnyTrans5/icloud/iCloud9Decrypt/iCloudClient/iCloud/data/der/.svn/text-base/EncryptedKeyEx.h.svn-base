//
//  EncryptedKey.h
//  
//
//  Created by Pallas on 7/30/16.
//
//

#import "ASN1Object.h"

@class NOS;

@interface EncryptedKeyEx : ASN1Object {
@private
    NOS *                                       _masterKey;
    NSMutableData *                             _wrappedKey;
    NSNumber *                                  _flags;
}

- (id)initWithMasterKey:(NOS*)masterKey withWrappedKey:(NSMutableData*)wrappedKey withFlags:(NSNumber*)flags;
- (id)initWithASN1Primitive:(ASN1Primitive*)primitive;

- (NSNumber*)getFlags;
- (NOS*)getMasterKey;
- (NSMutableData*)getWrappedKey;

@end
