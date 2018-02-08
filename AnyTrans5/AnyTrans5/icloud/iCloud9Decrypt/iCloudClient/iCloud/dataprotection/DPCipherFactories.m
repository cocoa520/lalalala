//
//  DPCipherFactories.m
//  
//
//  Created by Pallas on 8/26/16.
//
//  Complete

#import "DPCipherFactories.h"
#import "BlockCipher.h"
#import "DPAESCBCCipher.h"
#import "DPAESXTSCipher.h"

@implementation DPCipherFactories

+ (BlockCipher*)AES_CBC {
    return [[[DPAESCBCCipher alloc] init] autorelease];
}

+ (BlockCipher*)AES_XTS {
    return [[[DPAESXTSCipher alloc] init] autorelease];
}

@end
