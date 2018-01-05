//
//  ChunkEncryptionKeys.h
//  
//
//  Created by Pallas on 8/8/16.
//
//  Complete

#import <Foundation/Foundation.h>

@interface ChunkEncryptionKeys : NSObject

+ (NSMutableData*)unwrapKey:(NSMutableData*)kek withKeyData:(NSMutableData*)keyData;
+ (int)keyType:(NSMutableData*)keyData;

@end