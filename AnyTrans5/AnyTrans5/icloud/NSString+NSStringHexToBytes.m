//
//  NSString+NSString_NSStringHexToBytes.m
//  iMobieTrans
//
//  Created by Pallas on 2/21/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "NSString+NSStringHexToBytes.h"

@implementation NSString (NSString_NSStringHexToBytes)

- (NSData*)hexToBytes {
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= self.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [self substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

+ (NSString*)stringToHex:(uint8_t*)bytes length:(int)length {
    NSMutableString *hexString = [[NSMutableString alloc] init];
    for (int i = 0; i < length; i++) {
        @autoreleasepool {
            [hexString appendString:[NSString stringWithFormat:@"%02x", bytes[i]&0x00FF]];
        }
    }
    return hexString;
}

@end
