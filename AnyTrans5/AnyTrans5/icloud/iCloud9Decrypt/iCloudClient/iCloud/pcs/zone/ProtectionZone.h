//
//  ProtectionZone.h
//
//
//  Created by JGehry on 8/1/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class PZKeyUnwrap;

@interface ProtectionZone : NSObject {
@private
    PZKeyUnwrap *                                       _unwrapKey;
//    NSMutableData *                                     _masterKey;
    NSMutableArray *                                    _masterKey;
//    NSMutableData *                                     _decryptKey;
    NSMutableArray *                                    _decryptKey;
    NSMutableDictionary *                               _keys;
    NSString *                                          _protectionTag;
}


- (id)initWithPZKeyUnwrap:(PZKeyUnwrap*)unwrapKey withMasterKey:(NSMutableArray*)masterKey withDecryptKey:(NSMutableArray*)decryptKey withKeys:(NSMutableDictionary*)keys withProtectionTag:(NSString*)protectionTag;

- (NSString*)protectionTag;
//- (NSMutableData*)getKdk;
//- (NSMutableData*)getDk;
- (NSMutableData*)decrypt:(NSMutableData*)data identifierWithString:(NSString*)identifier;
- (NSMutableData*)decrypt:(NSMutableData*)data identifierWithMutableData:(NSMutableData*)identifier;
- (NSMutableData*)unwrapKey:(NSMutableData*)wrappedKey;
- (NSMutableDictionary*)getKeys;
- (NSMutableArray*)keyList;

@end
