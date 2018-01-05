//
//  PZAssistantLight.h
//
//
//  Created by JGehry on 8/2/16.
//
//
//  Complete

#import <Foundation/Foundation.h>

@class Digest;
@class ECPublicKey;
@class ECPrivateKeyEx;

@interface PZAssistantLight : NSObject {
@private
    Digest *                                _digest;
    NSString *                              _curveName;
    NSMutableData *                         _info;
    int                                     _curveFieldLength;
    int                                     _keyLength;
}

+ (PZAssistantLight*)instance;

- (id)initWithDigest:(Digest*)digest withCurveName:(NSString*)curveName withInfo:(NSMutableData*)info withKeyLength:(int)keyLength;

- (NSMutableData*)masterKey:(NSMutableData*)protectionInfoData withKeys:(NSMutableArray*)keys;
- (NSMutableData*)unwrap:(ECPublicKey*)otherPublicKey withMyPrivateKey:(ECPrivateKeyEx*)myPrivateKey withDigest:(Digest*)digest withWrappedKey:(NSMutableData*)wrappedKey;

@end
