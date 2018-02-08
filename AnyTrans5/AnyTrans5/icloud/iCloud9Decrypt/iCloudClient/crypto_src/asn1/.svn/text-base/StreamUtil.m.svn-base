//
//  StreamUtil.m
//  crypto
//
//  Created by JGehry on 5/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "StreamUtil.h"
#import "LimitedInputStream.h"
#import "ASN1InputStream.h"
#import "CategoryExtend.h"

@implementation StreamUtil

+ (int)findLimit:(Stream *)paramInputStream {
    if ([paramInputStream isKindOfClass:[LimitedInputStream class]]) {
        return [((LimitedInputStream *)paramInputStream) getRemaining];
    }
    if ([paramInputStream isKindOfClass:[ASN1InputStream class]]) {
        return [((ASN1InputStream *)paramInputStream) getLimit];
    }
    if ([paramInputStream isKindOfClass:[MemoryStreamEx class]]) {
        return [((MemoryStreamEx*)paramInputStream) available];
    }
    return (int)0x7fffffff;
}

+ (int)calculateBodyLength:(int)paramInt {
    int i = 1;
    if (paramInt > 127) {
        int j = 1;
        uint k = paramInt;
        
        while ((k  >>= 8) != 0) {
            j++;
        }
        for (int m = (j - 1) * 8; m >= 0; m -= 8) {
            i++;
        }
    }
    return i;
}

+ (int)calculateTagLength:(int)paramInt {
    int i = 1;
    if (paramInt >= 31) {
        if (paramInt < 128) {
            i++;
        }else {
            NSMutableData *arrayOfByte = [[[NSMutableData alloc] initWithSize:5] autorelease];
            int j = (int)[arrayOfByte length];
            ((Byte *)[arrayOfByte bytes])[--j] = (Byte)(paramInt & 0x7F);
            do {
                paramInt >>= 7;
                ((Byte *)[arrayOfByte bytes])[--j] = (Byte)((paramInt & 0x7F) | 0x80);
            } while (paramInt > 127);
            i += (int)[arrayOfByte length] - j;
        }
    }
    return i;
}

+ (NSMutableData *)readAll:(Stream *)paramInputStream {
    return nil;
}

@end
