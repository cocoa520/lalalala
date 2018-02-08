//
//  RFC3394Wrap.h
//  
//
//  Created by Pallas on 8/2/16.
//
//  Complete

#import <Foundation/Foundation.h>

@interface RFC3394Wrap : NSObject

+ (NSMutableData*)unwrap:(NSMutableData*)keyEncryptionKey withWrappedKey:(NSMutableData*)wrappedKey;
+ (NSMutableData*)wrap:(NSMutableData*)keyEncryptionKey withUnwrappedKey:(NSMutableData*)unwrappedKey;

@end
