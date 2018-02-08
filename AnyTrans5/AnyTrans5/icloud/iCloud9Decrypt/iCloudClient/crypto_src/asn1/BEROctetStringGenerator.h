//
//  BEROctetStringGenerator.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "BERGenerator.h"
#import "CategoryExtend.h"

@interface BEROctetStringGenerator : BERGenerator

- (instancetype)initParamOutputStream:(Stream *)paramOutputStream;
- (instancetype)initParamOutputStream:(Stream *)paramOutputStream paramInt:(int)paramInt paramBoolean:(BOOL)paramBoolean;
- (Stream *)getOctetOutputStream;
- (Stream *)getOctetOutputStream:(NSMutableData *)paramArrayOfByte;

@end

#import "DEROutputStream.h"

@interface BufferedBEROctetStream : Stream {
@private
    NSMutableData *_buf;
    int _off;
    DEROutputStream *_derOut;
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (void)write:(int)paramInt;
- (void)write:(NSMutableData *)paramArrayOfByte paramInt1:(int)paramInt1 paramInt2:(int)paramInt2;
- (void)close;

@end
