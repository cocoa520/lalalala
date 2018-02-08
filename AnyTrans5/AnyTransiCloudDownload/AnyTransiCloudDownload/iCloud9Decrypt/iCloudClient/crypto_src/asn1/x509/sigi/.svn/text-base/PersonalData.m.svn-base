//
//  PersonalData.m
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PersonalData.h"
#import "ASN1Sequence.h"
#import "ASN1Integer.h"
#import "DERTaggedObject.h"
#import "DERPrintableString.h"
#import "DERSequence.h"

@interface PersonalData ()

@property (nonatomic, readwrite, retain) NameOrPseudonym *nameOrPseudonym;
@property (nonatomic, readwrite, retain) BigInteger *nameDistinguisher;
@property (nonatomic, readwrite, retain) ASN1GeneralizedTime *dateOfBirth;
@property (nonatomic, readwrite, retain) DirectoryString *placeOfBirth;
@property (nonatomic, readwrite, retain) NSString *gender;
@property (nonatomic, readwrite, retain) DirectoryString *postalAddress;


@end

@implementation PersonalData
@synthesize nameOrPseudonym = _nameOrPseudonym;
@synthesize nameDistinguisher = _nameDistinguisher;
@synthesize dateOfBirth = _dateOfBirth;
@synthesize placeOfBirth = _placeOfBirth;
@synthesize gender = _gender;
@synthesize postalAddress = _postalAddress;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_nameOrPseudonym) {
        [_nameOrPseudonym release];
        _nameOrPseudonym = nil;
    }
    if (_nameDistinguisher) {
        [_nameDistinguisher release];
        _nameDistinguisher = nil;
    }
    if (_dateOfBirth) {
        [_dateOfBirth release];
        _dateOfBirth = nil;
    }
    if (_placeOfBirth) {
        [_placeOfBirth release];
        _placeOfBirth = nil;
    }
    if (_gender) {
        [_gender release];
        _gender = nil;
    }
    if (_postalAddress) {
        [_postalAddress release];
        _postalAddress = nil;
    }
    [super dealloc];
#endif
}

+ (PersonalData *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[PersonalData class]]) {
        return (PersonalData *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1Sequence class]]) {
        return [[[PersonalData alloc] initParamASN1Sequence:(ASN1Sequence *)paramObject] autorelease];
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"illegal object in getInstance: %s", object_getClassName(paramObject)] userInfo:nil];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if ([paramASN1Sequence size] < 1) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        self.nameOrPseudonym = [NameOrPseudonym getInstance:[localEnumeration nextObject]];
        while ([localEnumeration nextObject]) {
            ASN1TaggedObject *localASN1TaggedObject = [ASN1TaggedObject getInstance:[localEnumeration nextObject]];
            int i = [localASN1TaggedObject getTagNo];
            switch (i) {
                case 0:
                    self.nameDistinguisher = [[ASN1Integer getInstance:localASN1TaggedObject paramBoolean:NO] getValue];
                    break;
                case 1:
                    self.dateOfBirth = [ASN1GeneralizedTime getInstance:localASN1TaggedObject paramBoolean:NO];
                    break;
                case 2:
                    self.placeOfBirth = [DirectoryString getInstance:localASN1TaggedObject paramBoolean:NO];
                    break;
                case 3:
                    self.gender = [[DERPrintableString getInstance:localASN1TaggedObject paramBoolean:NO] getString];
                    break;
                case 4:
                    self.postalAddress = [DirectoryString getInstance:localASN1TaggedObject paramBoolean:YES];
                    break;
                default:
                    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad tag number: %d", [localASN1TaggedObject getTagNo]] userInfo:nil];
                    break;
            }
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamNameOrPseudonym:(NameOrPseudonym *)paramNameOrPseudonym paramBigInteger:(BigInteger *)paramBigInteger paramASN1GeneralizedTime:(ASN1GeneralizedTime *)paramASN1GeneralizedTime paramDirectoryString1:(DirectoryString *)paramDirectoryString1 paramString:(NSString *)paramString paramDirectoryString2:(DirectoryString *)paramDirectoryString2
{
    if (self = [super init]) {
        self.nameOrPseudonym = paramNameOrPseudonym;
        self.dateOfBirth = paramASN1GeneralizedTime;
        self.gender = paramString;
        self.nameDistinguisher = paramBigInteger;
        self.postalAddress = paramDirectoryString2;
        self.placeOfBirth = paramDirectoryString1;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (NameOrPseudonym *)getNameOrPseudonym {
    return self.nameOrPseudonym;
}

- (BigInteger *)getNameDistinguisher {
    return self.nameDistinguisher;
}

- (ASN1GeneralizedTime *)getDateOfBirth {
    return self.dateOfBirth;
}

- (DirectoryString *)getPlaceOfBirth {
    return self.placeOfBirth;
}

- (NSString *)getGender {
    return self.gender;
}

- (DirectoryString *)getPostalAddress {
    return self.postalAddress;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.nameOrPseudonym];
    if (self.nameDistinguisher) {
        ASN1Encodable *integerEncodable = [[ASN1Integer alloc] initBI:self.nameDistinguisher];
        ASN1Encodable *nameEncodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:0 paramASN1Encodable:integerEncodable];
        [localASN1EncodableVector add:nameEncodable];
#if !__has_feature(objc_arc)
        if (integerEncodable) [integerEncodable release]; integerEncodable = nil;
        if (nameEncodable) [nameEncodable release]; nameEncodable = nil;
#endif
    }
    if (self.dateOfBirth) {
        ASN1Encodable *dateEncodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:1 paramASN1Encodable:self.dateOfBirth];
        [localASN1EncodableVector add:dateEncodable];
#if !__has_feature(objc_arc)
        if (dateEncodable) [dateEncodable release]; dateEncodable = nil;
#endif
    }
    if (self.placeOfBirth) {
        ASN1Encodable *placeEncodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:2 paramASN1Encodable:self.placeOfBirth];
        [localASN1EncodableVector add:placeEncodable];
#if !__has_feature(objc_arc)
        if (placeEncodable) [placeEncodable release]; placeEncodable = nil;
#endif
    }
    if (self.gender) {
        ASN1Encodable *printableEncodable = [[DERPrintableString alloc] initParamString:self.gender paramBoolean:YES];
        ASN1Encodable *genderEncodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:3 paramASN1Encodable:printableEncodable];
        [localASN1EncodableVector add:genderEncodable];
#if !__has_feature(objc_arc)
        if (printableEncodable) [printableEncodable release]; printableEncodable = nil;
        if (genderEncodable) [genderEncodable release]; genderEncodable = nil;
#endif
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
