//
//  KeyBlob.h
//  
//
//  Created by Pallas on 8/29/16.
//
//  Complete

#import <Foundation/Foundation.h>

@interface KeyBlob : NSObject {
@private
    NSMutableData *                         _uuid;
    NSMutableData *                         _publicKey;
    NSMutableData *                         _wrappedKey;
    int                                     _protectionClass;
    int                                     _u1;
    int                                     _u2;
    int                                     _u3;
}

- (int)protectionClass;
- (int)u1;
- (int)u2;
- (int)u3;

+ (NSMutableData*)uuid:(NSMutableData*)data;
+ (KeyBlob*)create:(NSMutableData*)data;

- (id)initWithUuid:(NSMutableData*)uuid withPublicKey:(NSMutableData*)publicKey withWrappedKey:(NSMutableData*)wrappedKey withProtectionClass:(int)protectionClass withU1:(int)u1 withU2:(int)u2 withU3:(int)u3;

- (NSMutableData*)getUuid;
- (NSString*)uuidBase64;
- (NSMutableData*)getPublicKey;
- (NSMutableData*)getWrappedKey;

@end
