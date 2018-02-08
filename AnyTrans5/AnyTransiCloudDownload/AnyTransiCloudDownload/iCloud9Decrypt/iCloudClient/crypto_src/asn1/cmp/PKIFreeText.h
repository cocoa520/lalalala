//
//  PKIFreeText.h
//  crypto
//
//  Created by JGehry on 6/21/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Sequence.h"
#import "ASN1TaggedObject.h"
#import "DERUTF8String.h"

@interface PKIFreeText : ASN1Object {
    ASN1Sequence *_strings;
}

@property (nonatomic, readwrite, retain) ASN1Sequence *strings;

+ (PKIFreeText *)getInstance:(id)paramObject;
+ (PKIFreeText *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamDERUTF8String:(DERUTF8String *)paramDERUTF8String;
- (instancetype)initParamString:(NSString *)paramString;
- (instancetype)initParamArrayOfDERUTF8String:(NSMutableArray *)paramArrayOfDERUTF8String;
- (instancetype)initParamArrayOfString:(NSMutableArray *)paramArrayOfString;
- (int)size;
- (DERUTF8String *)getStringAt:(int)paramInt;
- (ASN1Primitive *)toASN1Primitive;

@end
