//
//  IssuerSerial.m
//  crypto
//
//  Created by JGehry on 6/23/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "IssuerSerial.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@implementation IssuerSerial
@synthesize issuer = _issuer;
@synthesize serial = _serial;
@synthesize issuerUID = _issuerUID;

+ (IssuerSerial *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[IssuerSerial class]]) {
        return (IssuerSerial *)paramObject;
    }
    if (paramObject) {
        return [[[IssuerSerial alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (IssuerSerial *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [IssuerSerial getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if (([paramASN1Sequence size] != 2) && ([paramASN1Sequence size] != 3)) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        self.issuer = [GeneralNames getInstance:[paramASN1Sequence getObjectAt:0]];
        self.serial = [ASN1Integer getInstance:[paramASN1Sequence getObjectAt:1]];
        if ([paramASN1Sequence size] == 3) {
            self.issuerUID = [DERBitString getInstance:[paramASN1Sequence getObjectAt:2]];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamX500Name:(X500Name *)paramX500Name paramBigInteger:(BigInteger *)paramBigInteger
{
    if (self = [super init]) {
        GeneralName *name = [[GeneralName alloc] initParamX500Name:paramX500Name];
        GeneralNames *names = [[GeneralNames alloc] initParamGeneralName:name];
        ASN1Integer *integer = [[ASN1Integer alloc] initBI:paramBigInteger];
        [self initParamGeneralNames:names paramASN1Integer:integer];
#if !__has_feature(objc_arc)
    if (name) [name release]; name = nil;
    if (names) [names release]; names = nil;
    if (integer) [integer release]; integer = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamGeneralNames:(GeneralNames *)paramGeneralNames paramBigInteger:(BigInteger *)paramBigInteger
{
    if (self = [super init]) {
        ASN1Integer *integer = [[ASN1Integer alloc] initBI:paramBigInteger];
        [self initParamGeneralNames:paramGeneralNames paramASN1Integer:integer];
#if !__has_feature(objc_arc)
    if (integer) [integer release]; integer = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamGeneralNames:(GeneralNames *)paramGeneralNames paramASN1Integer:(ASN1Integer *)paramASN1Integer
{
    if (self = [super init]) {
        self.issuer = paramGeneralNames;
        self.serial = paramASN1Integer;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (void)dealloc
{
    [self setIssuer:nil];
    [self setSerial:nil];
    [self setIssuerUID:nil];
    [super dealloc];
}

- (GeneralNames *)getIssuer {
    return self.issuer;
}

- (ASN1Integer *)getSerial {
    return self.serial;
}

- (DERBitString *)getIssuerUID {
    return self.issuerUID;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.issuer];
    [localASN1EncodableVector add:self.serial];
    if (self.issuerUID) {
        [localASN1EncodableVector add:self.issuerUID];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
