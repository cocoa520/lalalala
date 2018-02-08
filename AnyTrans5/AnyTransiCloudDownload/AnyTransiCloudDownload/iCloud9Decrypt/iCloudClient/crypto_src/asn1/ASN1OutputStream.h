//
//  ASN1OutputStream.h
//  crypto
//
//  Created by JGehry on 5/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Encodable.h"
#import "ASN1Primitive.h"
#import "CategoryExtend.h"

@interface ASN1OutputStream : Stream {
@private
    Stream *_oUT;
}

- (instancetype)initASN1OutputStream:(Stream*)paramOutputStream;
- (void)writeLength:(int)paramInt;
- (void)write:(int)paramInt;
- (void)writeParamArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (void)writeParamAOBAndInt:(NSMutableData *)paramArrayOfByte paramInt1:(int)paramInt1 paramInt2:(int)paramInt2;
- (void)writeEncoded:(int)paramInt paramArrayOfByte:(NSMutableData *)paramArrayofByte;
- (void)writeTag:(int)paramInt1 paramInt2:(int)paramInt2;
- (void)writeEncoded:(int)paramInt1 paramInt2:(int)paramInt2 paramArrayOfByte:(NSMutableData *)paramArrayofByte;
- (void)writeNull;
- (void)writeObject:(ASN1Encodable *)paramASN1Encodable;
- (void)writeImplicitObject:(ASN1Primitive *)paramASN1Primitive;
- (ASN1OutputStream *)getDERSubStream;
- (ASN1OutputStream *)getDLSubStream;
- (void)close;

@end

@interface ImplicitOutputStream : ASN1OutputStream {
@private
    BOOL _first;
}

- (instancetype)initParamOutputStream:(Stream *)paramOutputStream;
- (void)write:(int)paramInt;

@end
