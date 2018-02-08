//
//  IMBBigEndianBitConverter.h
//  BackupTool_Mac
//
//  Created by Pallas on 1/15/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <malloc/malloc.h>

@interface IMBBigEndianBitConverter : NSObject

+ (uint16)bigEndianToUInt16:(Byte *)inArray byteLength:(int)byteLength;

+ (int32_t)bigEndianToInt32:(Byte *)inArray byteLength:(int)byteLength;

+ (uint32)bigEndianToUInt32:(Byte *)inArray byteLength:(int)byteLength;

+ (int64_t)bigEndianToInt64:(Byte *)inArray byteLength:(int)byteLength;

+ (NSMutableData*)bigEndianBytes:(Byte *)inArray byteLength:(int)byteLength;

+ (BOOL)isLitte_Endian;

+ (Byte *)reverseBytes:(Byte *)inArray offset:(int)offset count:(int)count;

@end
