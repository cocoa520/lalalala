//
//  DirectoryString.h
//  crypto
//
//  Created by JGehry on 6/3/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Choice.h"
#import "ASN1String.h"
#import "ASN1TaggedObject.h"
#import "DERT61String.h"
#import "DERPrintableString.h"
#import "DERUniversalString.h"
#import "DERUTF8String.h"
#import "DERBMPString.h"

@interface DirectoryString : ASN1Choice {
@private
    ASN1String *_string;
}

+ (DirectoryString *)getInstance:(id)paramObject;
+ (DirectoryString *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamString:(NSString *)paramString;
- (instancetype)initParamDERT61String:(DERT61String *)paramDERT61String;
- (instancetype)initParamDERPrintableString:(DERPrintableString *)paramDERPrintableString;
- (instancetype)initParamDERUniversalString:(DERUniversalString *)paramDERUniversalString;
- (instancetype)initParamDERUTF8String:(DERUTF8String *)paramDERUTF8String;
- (instancetype)initParamDERBMPString:(DERBMPString *)paramDERBMPString;
- (NSString *)getString;
- (NSString *)toString;
- (ASN1Primitive *)toASN1Primitive;

@end
