//
//  X500Name.h
//  crypto
//
//  Created by JGehry on 6/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "X500NameStyle.h"
#import "ASN1TaggedObject.h"

@interface X500Name : ASN1Object {
@private
    BOOL _isHashCodeCalculated;
    int _hashCodeValue;
    X500NameStyle *_style;
    NSMutableArray *_rdns;
}

+ (X500Name *)getInstance:(id)paramObject;
+ (X500Name *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
+ (X500Name *)getInstance:(X500NameStyle *)paramX500NameStyle paramObject:(id)paramObject;
- (instancetype)initParamX500NameStyle:(X500NameStyle *)paramX500NameStyle paramX500Name:(X500Name *)paramX500Name;
- (instancetype)initParamArrayOfRDN:(NSMutableArray *)paramArrayOfRDN;
- (instancetype)initParamX500NameStyle:(X500NameStyle *)paramX500NameStyle paramArrayOfRDN:(NSMutableArray *)paramArrayOfRDN;
- (instancetype)initParamString:(NSString *)paramString;
- (instancetype)initParamX500NameStyle:(X500NameStyle *)paramX500NameStyle paramString:(NSString *)paramString;
- (NSMutableArray *)getRDNS;
- (NSMutableArray *)getAttributeTypes;
- (NSMutableArray *)getRDNSParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier;
- (ASN1Primitive *)toASN1Primitive;
- (NSString *)toString;
+ (void)setDefaultStyle:(X500NameStyle *)paramX500NameStyle;
+ (X500NameStyle *)getDefaultStyle;
@end
