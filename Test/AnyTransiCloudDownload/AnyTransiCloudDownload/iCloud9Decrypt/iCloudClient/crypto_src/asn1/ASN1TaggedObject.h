//
//  ASN1TaggedObject.h
//  crypto
//
//  Created by JGehry on 5/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1TaggedObjectParser.h"

@interface ASN1TaggedObject : ASN1TaggedObjectParser {
    int _tagNO;
    BOOL _empty;
    BOOL _explicit;
    ASN1Encodable *_obj;
}

@property (nonatomic, assign) int tagNO;
@property (nonatomic, assign) BOOL empty;
@property (nonatomic, assign) BOOL explicit;
@property (nonatomic, readwrite, retain) ASN1Encodable *obj;

- (instancetype)initParamBoolean:(BOOL)paramBoolean paramInt:(int)paramInt paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
+ (ASN1TaggedObject *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
+ (ASN1TaggedObject *)getInstance:(id)paramObject;

- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive;
- (int)getTagNo;
- (BOOL)isExplicit;
- (BOOL)isEmpty;
- (ASN1Primitive *)getObject;
- (ASN1Encodable *)getObjectParser:(int)paramInt paramBoolean:(BOOL)paramBoolean;
- (ASN1Primitive *)getLoadedObject;
- (NSString *)toString;

@end
