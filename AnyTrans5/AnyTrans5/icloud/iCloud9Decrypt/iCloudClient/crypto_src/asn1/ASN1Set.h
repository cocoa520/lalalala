//
//  ASN1Set.h
//  crypto
//
//  Created by JGehry on 5/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Primitive.h"
#import "ASN1SetParser.h"
#import "ASN1TaggedObject.h"
#import "ASN1EncodableVector.h"

@interface ASN1Set : ASN1Primitive  {
@private
    BOOL _isSorted;
    NSMutableArray *_set;
}

+ (ASN1Set *)getInstance:(id)paramObject;
+ (ASN1Set *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)init;
- (instancetype)initParamASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (instancetype)initParamASN1EncodableVector:(ASN1EncodableVector *)paramASN1EncodableVector paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamArrayOfASN1Encodable:(NSMutableArray *)paramArrayOfASN1Encodable paramBoolean:(BOOL)paramBoolean;
- (ASN1Primitive *)toDERObject;
- (ASN1Primitive *)toDLObject;
- (ASN1Encodable *)getObjectAt:(int)paramInt;
- (NSEnumerator *)getObjects;
- (int)size;
- (NSMutableArray *)toArray;

- (ASN1SetParser *)parser;
- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive;
- (BOOL)isConstructed;
- (NSString *)toString;
@end
