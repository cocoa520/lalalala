//
//  ASN1ApplicationSpecific.h
//  crypto
//
//  Created by JGehry on 6/13/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Primitive.h"
#import "ASN1OutputStream.h"

@interface ASN1ApplicationSpecific : ASN1Primitive {
@protected
    BOOL _isConstructed;
    int _tag;
    NSMutableData *_octets;
}

@property (nonatomic, assign) BOOL isConstructed;
@property (nonatomic, assign) int tag;
@property (nonatomic, readwrite, retain) NSMutableData *octets;

+ (ASN1ApplicationSpecific *)getInstance:(id)paramObject;
- (instancetype)initParamBoolean:(BOOL)paramBoolean paramInt:(int)paramInt paramArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (BOOL)isConstructed;
- (NSMutableData *)getContents;
- (int)getApplicationTag;
- (ASN1Primitive *)getObject;
- (ASN1Primitive *)getObject:(int)paramInt;
- (int)encodedLength;
- (void)encode:(ASN1OutputStream *)paramASN1OutputStream;
- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive;
+ (int)getLengthOfHeader:(NSMutableData *)paramArrayOfByte;

@end
