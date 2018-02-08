//
//  OriginatorIdentifierOrKey.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "OriginatorIdentifierOrKey.h"
#import "DERTaggedObject.h"

@interface OriginatorIdentifierOrKey ()

@property (nonatomic, readwrite, retain) ASN1Encodable *iD;

@end

@implementation OriginatorIdentifierOrKey
@synthesize iD = _iD;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_iD) {
        [_iD release];
        _iD = nil;
    }
    [super dealloc];
#endif
}

+ (OriginatorIdentifierOrKey *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[OriginatorIdentifierOrKey class]]) {
        return (OriginatorIdentifierOrKey *)paramObject;
    }
    if ([paramObject isKindOfClass:[IssuerAndSerialNumber class]] || [paramObject isKindOfClass:[ASN1Sequence class]]) {
        return [[[OriginatorIdentifierOrKey alloc] initParamIssuerAndSerialNumber:[IssuerAndSerialNumber getInstance:paramObject]] autorelease];
    }
    if ([paramObject isKindOfClass:[ASN1TaggedObject class]]) {
        ASN1TaggedObject *localASN1TaggedObject = (ASN1TaggedObject *)paramObject;
        if ([localASN1TaggedObject getTagNo] == 0) {
            return [[[OriginatorIdentifierOrKey alloc] initParamSubjectKeyIdentifier:[SubjectKeyIdentifier getInstance:localASN1TaggedObject paramBoolean:false]] autorelease];
        }
        if ([localASN1TaggedObject getTagNo] == 1) {
            return [[[OriginatorIdentifierOrKey alloc] initParamOriginatorPublicKey:[OriginatorPublicKey getInstance:localASN1TaggedObject paramBoolean:false]] autorelease];
        }
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Invalid OriginatorIdentifierOrKey: %s", object_getClassName(paramObject)] userInfo:nil];
}

+ (OriginatorIdentifierOrKey *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    if (!paramBoolean) {
        @throw [NSException exceptionWithName:NSGenericException reason:@"Can't implicitly tag OriginatorIdentifierOrKey" userInfo:nil];
    }
    return [OriginatorIdentifierOrKey getInstance:[paramASN1TaggedObject getObject]];
}

- (instancetype)initParamIssuerAndSerialNumber:(IssuerAndSerialNumber *)paramIssuerAndSerialNumber
{
    if (self = [super init]) {
        self.iD = paramIssuerAndSerialNumber;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1OctetString:(ASN1OctetString *)paramASN1OctetString
{
    if (self = [super init]) {
        SubjectKeyIdentifier *subject = [[SubjectKeyIdentifier alloc] initParamArrayOfByte:[paramASN1OctetString getOctets]];
        [self initParamSubjectKeyIdentifier:subject];
#if !__has_feature(objc_arc)
    if (subject) [subject release]; subject = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamSubjectKeyIdentifier:(SubjectKeyIdentifier *)paramSubjectKeyIdentifier
{
    if (self = [super init]) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:0 paramASN1Encodable:paramSubjectKeyIdentifier];
        self.iD = encodable;
#if !__has_feature(objc_arc)
    if (encodable) [encodable release]; encodable = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamOriginatorPublicKey:(OriginatorPublicKey *)paramOriginatorPublicKey
{
    if (self = [super init]) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:1 paramASN1Encodable:paramOriginatorPublicKey];
        self.iD = encodable;
#if !__has_feature(objc_arc)
    if (encodable) [encodable release]; encodable = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
        
    }
}

- (instancetype)initParamASN1Primitive:(ASN1Primitive *)paramASN1Primitive
{
    if (self = [super init]) {
        self.iD = paramASN1Primitive;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
        
    }
}

- (ASN1Encodable *)getId {
    return self.iD;
}

- (IssuerAndSerialNumber *)getIssuerAndSerialNumber {
    if ([self.iD isKindOfClass:[IssuerAndSerialNumber class]]) {
        return (IssuerAndSerialNumber *)self.iD;
    }
    return nil;
}

- (SubjectKeyIdentifier *)getSubjectKeyIdentifier {
    if ([self.iD isKindOfClass:[ASN1TaggedObject class]] && ([((ASN1TaggedObject *)self.iD) getTagNo] == 0)) {
        return [SubjectKeyIdentifier getInstance:(ASN1TaggedObject *)self.iD paramBoolean:false];
    }
    return nil;
}

- (OriginatorPublicKey *)getOriginatorKey {
    if ([self.iD isKindOfClass:[ASN1TaggedObject class]] && ([((ASN1TaggedObject *)self.iD) getTagNo] == 1)) {
        return [OriginatorPublicKey getInstance:(ASN1TaggedObject *)self.iD paramBoolean:false];
    }
    return nil;
}

- (ASN1Primitive *)toASN1Primitive {
    return [self.iD toASN1Primitive];
}

@end
