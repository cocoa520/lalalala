//
//  GeneralName.h
//  crypto
//
//  Created by JGehry on 6/22/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Choice.h"
#import "ASN1TaggedObject.h"
#import "X509Name.h"
#import "X500Name.h"

@interface GeneralName : ASN1Choice {
@private
    ASN1Encodable *_obj;
    int _tag;
}

+ (int)otherName;
+ (int)rfc822Name;
+ (int)dNSName;
+ (int)x400Address;
+ (int)directoryName;
+ (int)ediPartyName;
+ (int)uniformResourceIdentifier;
+ (int)iPAddress;
+ (int)registeredID;
+ (GeneralName *)getInstance:(id)paramObject;
+ (GeneralName *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamX509Name:(X509Name *)paramX509Name;
- (instancetype)initParamX500Name:(X500Name *)paramX500Name;
- (instancetype)initParamInt:(int)paramInt paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (instancetype)initParamInt:(int)paramInt paramString:(NSString *)paramString;
- (int)getTagNo;
- (ASN1Encodable *)getName;
- (NSString *)toString;
- (ASN1Primitive *)toASN1Primitive;

@end
