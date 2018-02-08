//
//  DPAESCBCBlockIVGenerator.h
//  
//
//  Created by Pallas on 8/26/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class BlockCipher;

@interface DPAESCBCBlockIVGenerator : NSObject {
@private
    BlockCipher *                               _cipher;
}

- (id)initWithFileKey:(NSMutableData*)fileKey;

- (NSMutableData*)apply:(int)blockOffset;

@end
