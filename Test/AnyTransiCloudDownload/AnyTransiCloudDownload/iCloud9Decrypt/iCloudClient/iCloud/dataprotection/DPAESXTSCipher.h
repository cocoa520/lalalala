//
//  DPAESXTSCipher.h
//  
//
//  Created by Pallas on 8/26/16.
//
//  Complete

#import "XTSAESBlockCipher.h"

@interface DPAESXTSCipher : XTSAESBlockCipher

- (id)initWithBlockSize:(int)blockSize;

@end
