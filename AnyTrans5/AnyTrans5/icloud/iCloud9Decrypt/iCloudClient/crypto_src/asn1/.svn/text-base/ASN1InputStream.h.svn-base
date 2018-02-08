//
//  ASN1InputStream.h
//  crypto
//
//  Created by JGehry on 6/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Primitive.h"
#import "DefiniteLengthInputStream.h"
#import "CategoryExtend.h"

@interface ASN1InputStream : Stream {
@protected
    Stream *_iN;
@private
    int _limit;
    BOOL _lazyEvaluate;
    NSMutableArray *_tmpBuffers;
}

+ (int)readTagNumber:(Stream *)paramInputStream paramInt:(int)paramInt;
+ (int)readLength:(Stream *)paramInputStream paramInt:(int)paramInt;
+ (ASN1Primitive *)createPrimitiveDERObject:(int)paramInt paramDefiniteLengthInputStream:(DefiniteLengthInputStream *)paramDefiniteLengthInputStream paramArrayOfByte:(NSMutableArray *)paramArrayOfByte;

- (instancetype)initParamInputStream:(Stream *)paramInputStream;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamInputStream:(Stream *)paramInputStream paramInt:(int)paramInt;
- (instancetype)initParamInputStream:(Stream *)paramInputStream paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamInputStream:(Stream *)paramInputStream paramInt:(int)paramInt paramBoolean:(BOOL)paramBoolean;
- (ASN1Primitive *)readObject;
- (int)getLimit;
- (ASN1Primitive *)buildObject:(int)paramInt1 paramInt2:(int)paramInt2 paramInt3:(int)paramInt3;

@end
