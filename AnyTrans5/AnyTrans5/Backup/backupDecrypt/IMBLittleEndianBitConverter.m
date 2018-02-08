//
//  IMBLittleEndianBitConverter.m
//  BackupTool_Mac
//
//  Created by Pallas on 1/19/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBLittleEndianBitConverter.h"
#import "IMBCommonEnum.h"

@implementation IMBLittleEndianBitConverter
//#import "CommonType.h"

+ (uint16)littleEndianToUInt16:(Byte *)inArray byteLength:(int)byteLength {
    uint16 ret = 0;
    if (![self isLitte_Endian]) {
        Byte *reverseBytes = [self reverseBytes:inArray offset:0 count:byteLength];
        memcpy (uint_16.c, reverseBytes, sizeof uint_16.c);
        ret = uint_16.ui16;
        free(reverseBytes);
    } else {
        memcpy (uint_16.c, inArray, sizeof uint_16.c);
        ret = uint_16.ui16;
    }
    return ret;
}

+ (int32_t)littleEndianToInt32:(Byte *)inArray byteLength:(int)byteLength {
    int32_t ret = 0;
    if (![self isLitte_Endian]) {
        Byte *reverseBytes = [self reverseBytes:inArray offset:0 count:byteLength];
        memcpy (int_32.c, reverseBytes, sizeof int_32.c);
        ret = int_32.i32;
        free(reverseBytes);
    } else {
        memcpy (int_32.c, inArray, sizeof int_32.c);
        ret = int_32.i32;
    }
    return ret;
}

+ (uint32)littleEndianToUInt32:(Byte *)inArray byteLength:(int)byteLength {
    uint32 ret = 0;
    if (![self isLitte_Endian]) {
        Byte *reverseBytes = [self reverseBytes:inArray offset:0 count:byteLength];
        memcpy (uint_32.c, reverseBytes, sizeof uint_32.c);
        ret = uint_32.ui32;
        free(reverseBytes);
    } else {
        memcpy (uint_32.c, inArray, sizeof uint_32.c);
        ret = uint_32.ui32;
    }
    return ret;
}

+ (int64_t)littleEndianToInt64:(Byte *)inArray byteLength:(int)byteLength {
    int64_t ret = 0;
    if (![self isLitte_Endian]) {
        Byte *reverseBytes = [self reverseBytes:inArray offset:0 count:byteLength];
        memcpy (int_64.c, reverseBytes, sizeof int_64.c);
        ret = int_64.i64;
        free(reverseBytes);
    } else {
        memcpy (int_64.c, inArray, sizeof int_64.c);
        ret = int_64.i64;
    }
    return ret;
}

+ (NSMutableData*)littleEndianBytes:(Byte *)inArray byteLength:(int)byteLength {
    NSMutableData *retData = nil;
    if (![self isLitte_Endian]) {
        Byte *reverseBytes = [self reverseBytes:inArray offset:0 count:byteLength];
        retData = [NSMutableData dataWithBytes:reverseBytes length:byteLength];
    } else {
        retData = [NSMutableData dataWithBytes:inArray length:byteLength];
    }
    return retData;
}

// 若处理器是Big_endian的，则返回false；若是Little_endian的，则返回true。
+ (BOOL)isLitte_Endian {
    union w{
        int a;
        char b;
    } c;
    c.a = 1;
    return (c.b == 1);
}

+ (Byte *)reverseBytes:(Byte *)inArray offset:(int)offset count:(int)count {
    Byte *retBytes = NULL;
    
    if (count != 0) {
        retBytes = malloc(count);
        memset(retBytes, 0, malloc_size(retBytes));
    } else {
        return NULL;
    }
    int j = count;
    Byte tmpBytes[count];
    for (int i = offset; i < offset + count; i++) {
        Byte c = inArray[i];
        tmpBytes[--j] = c;
    }
    memcpy(retBytes, tmpBytes, count);
    
    return retBytes;
}

@end
