//
//  ASN1Sequence.h
//  crypto
//
//  Created by JGehry on 5/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Primitive.h"
#import "ASN1Encodable.h"
#import "ASN1TaggedObject.h"
#import "ASN1EncodableVector.h"
#import "ASN1SequenceParser.h"

@interface ASN1Sequence : ASN1Primitive {
    NSMutableArray *_seq;
}

@property (nonatomic, readwrite, retain) NSMutableArray *seq;

+ (ASN1Sequence *)getInstance:(id)paramObject;
+ (ASN1Sequence *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;

- (instancetype)init;
- (instancetype)initParamASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (instancetype)initParamASN1EncodableVector:(ASN1EncodableVector *)paramASN1EncodableVector;
- (instancetype)initParamArrayOfASN1Encodable:(NSMutableArray *)paramArrayOfASN1Encodable;
- (NSMutableArray *)toArray;
- (int)size;
- (ASN1Encodable *)getObjectAt:(int)paramInt;

- (NSEnumerator *)getObjects;
- (ASN1SequenceParser *)parser;
- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive;
- (ASN1Primitive *)toDERObject;
- (ASN1Primitive *)toDLObject;
- (BOOL)isConstructed;
- (void)encode:(ASN1OutputStream *)paramASN1OutputStream;

@end
