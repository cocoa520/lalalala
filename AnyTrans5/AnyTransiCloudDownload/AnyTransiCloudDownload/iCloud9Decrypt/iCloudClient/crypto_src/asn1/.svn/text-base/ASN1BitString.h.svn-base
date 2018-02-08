//
//  ASN1BitString.h
//  crypto
//
//  Created by JGehry on 5/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1String.h"
#import "CategoryExtend.h"

@interface ASN1BitString : ASN1String {
@protected
    NSMutableData *_data;
    int _padBits;
}

@property (nonatomic, readwrite, retain) NSMutableData *data;
@property (nonatomic, assign) int padBits;

+ (int)getPadBits:(int)paramInt;
+ (NSMutableData *)getBytes:(int)paramInt;
+ (ASN1BitString *)fromInputStream:(int)paramInt paramInputStream:(Stream *)paramInputStream;
+ (NSMutableData *)derForm:(NSMutableData *)paramArrayOfByte paramInt:(int)paramInt;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramInt:(int)paramInt;
- (NSString *)getString;
- (int)intValue;
- (NSMutableData *)getOctets;
- (NSMutableData *)getBytes;
- (int)getPadBits;
- (NSString *)toString;
- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive;
- (ASN1Primitive *)getLoadedObject;
- (ASN1Primitive *)toDERObject;
- (void)encode:(ASN1OutputStream *)paramASN1OutputStream;

@end
