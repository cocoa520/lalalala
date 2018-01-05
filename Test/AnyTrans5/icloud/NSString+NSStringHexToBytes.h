//
//  NSString+NSString_NSStringHexToBytes.h
//  iMobieTrans
//
//  Created by Pallas on 2/21/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSString_NSStringHexToBytes)

- (NSData*)hexToBytes;
+ (NSString*)stringToHex:(uint8_t*)bytes length:(int)length;

@end
