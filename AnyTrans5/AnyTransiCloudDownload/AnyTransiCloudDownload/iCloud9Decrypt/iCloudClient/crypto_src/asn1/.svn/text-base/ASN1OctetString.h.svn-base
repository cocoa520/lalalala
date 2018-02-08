//
//  ASN1OctetString.h
//  crypto
//
//  Created by JGehry on 5/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Primitive.h"
#import "ASN1TaggedObject.h"
#import "ASN1OctetStringParser.h"

@interface ASN1OctetString : ASN1OctetStringParser {
    NSMutableData *_string;
}

@property (nonatomic, readwrite, retain) NSMutableData *string;

+ (ASN1OctetString *)getInstance:(id)paramObject;
+ (ASN1OctetString *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initWithParamAOB:(NSMutableData *)paramArrayOfByte;
- (ASN1OctetStringParser *)parser;
- (NSMutableData *)getOctets;
- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive;
- (ASN1Primitive *)getLoadedObject;
- (ASN1Primitive *)toDERObject;
- (ASN1Primitive *)toDLObject;
- (void)encode:(ASN1OutputStream *)paramASN1OutputStream;
- (NSString *)toString;

@end
