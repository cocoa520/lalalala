//
//  IMBLittleEndianBitConverter.h
//  BackupTool_Mac
//
//  Created by Pallas on 1/19/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <malloc/malloc.h>

@interface IMBLittleEndianBitConverter : NSObject

+ (uint16)littleEndianToUInt16:(Byte *)inArray byteLength:(int)byteLength;

+ (int32_t)littleEndianToInt32:(Byte *)inArray byteLength:(int)byteLength;

+ (uint32)littleEndianToUInt32:(Byte *)inArray byteLength:(int)byteLength;

+ (int64_t)littleEndianToInt64:(Byte *)inArray byteLength:(int)byteLength;

+ (NSMutableData*)littleEndianBytes:(Byte *)inArray byteLength:(int)byteLength;

+ (BOOL)isLitte_Endian;

+ (Byte *)reverseBytes:(Byte *)inArray offset:(int)offset count:(int)count;

@end
