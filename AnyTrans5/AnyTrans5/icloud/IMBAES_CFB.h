//
//  IMBAES_CFB.h
//  iCloudDemo
//
//  Created by Pallas on 7/18/14.
//  Copyright (c) 2014 com.imobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>
//#import "CommonType.h"

@interface IMBAES_CFB : NSObject {
}

+ (NSMutableData *)decryptCFBWithKey:(Byte*)key withIV:(Byte*)iv withData:(NSData*)data;

@end
