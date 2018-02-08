//
//  ProcurationSyntax.m
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ProcurationSyntax.h"
#import "ASN1Sequence.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"
#import "DERPrintableString.h"

@interface ProcurationSyntax ()

@property (nonatomic, readwrite, retain) NSString *country;
@property (nonatomic, readwrite, retain) DirectoryString *typeOfSubstitution;
@property (nonatomic, readwrite, retain) GeneralName *thirdPerson;
@property (nonatomic, readwrite, retain) IssuerSerial *certRef;

@end

@implementation ProcurationSyntax
@synthesize country = _country;
@synthesize typeOfSubstitution = _typeOfSubstitution;
@synthesize thirdPerson = _thirdPerson;
@synthesize certRef = _certRef;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_country) {
        [_country release];
        _country = nil;
    }
    if (_typeOfSubstitution) {
        [_typeOfSubstitution release];
        _typeOfSubstitution = nil;
    }
    if (_thirdPerson) {
        [_thirdPerson release];
        _thirdPerson = nil;
    }
    if (_certRef) {
        [_certRef release];
        _certRef = nil;
    }
    [super dealloc];
#endif
}

+ (ProcurationSyntax *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[ProcurationSyntax class]]) {
        return (ProcurationSyntax *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1Sequence class]]) {
        return [[[ProcurationSyntax alloc] initParamASN1Sequence:(ASN1Sequence *)paramObject] autorelease];
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"illegal object in getInstance: %s", object_getClassName(paramObject)] userInfo:nil];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if (([paramASN1Sequence size] < 1) || ([paramASN1Sequence size] > 3)) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        id localObject = nil;
        while (localObject = [localEnumeration nextObject]) {
            ASN1TaggedObject *localASN1TaggedObject = [ASN1TaggedObject getInstance:localObject];
            switch ([localASN1TaggedObject getTagNo]) {
                case 1:
                    self.country = [[DERPrintableString getInstance:localASN1TaggedObject paramBoolean:YES] getString];
                    break;
                case 2:
                    self.typeOfSubstitution = [DirectoryString getInstance:localASN1TaggedObject paramBoolean:YES];
                    break;
                case 3: {
                    ASN1Primitive *localASN1Primitive = [localASN1TaggedObject getObject];
                    if ([localASN1Primitive isKindOfClass:[ASN1TaggedObject class]]) {
                        self.thirdPerson = [GeneralName getInstance:localASN1Primitive];
                    }else {
                        self.certRef = [IssuerSerial getInstance:localASN1Primitive];
                    }
                }
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

- (instancetype)initParamString:(NSString *)paramString paramDirectoryString:(DirectoryString *)paramDirectoryString paramIssuerSerial:(IssuerSerial *)paramIssuerSerial
{
    if (self = [super init]) {
        self.country = paramString;
        self.typeOfSubstitution = paramDirectoryString;
        self.thirdPerson = nil;
        self.certRef = paramIssuerSerial;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamString:(NSString *)paramString paramDirectoryString:(DirectoryString *)paramDirectoryString paramGeneralName:(GeneralName *)paramGeneralName
{
    if (self = [super init]) {
        self.country = paramString;
        self.typeOfSubstitution = paramDirectoryString;
        self.thirdPerson = paramGeneralName;
        self.certRef = nil;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (NSString *)getCountry {
    return self.country;
}

- (DirectoryString *)getTypeOfSubstitution {
    return self.typeOfSubstitution;
}

- (GeneralName *)getThirdPerson {
    return self.thirdPerson;
}

- (IssuerSerial *)getCertRef {
    return self.certRef;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if (self.country) {
        ASN1Encodable *encodable = [[DERPrintableString alloc] initParamString:self.country paramBoolean:YES];
        ASN1Encodable *countryEncodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:1 paramASN1Encodable:encodable];
        [localASN1EncodableVector add:countryEncodable];
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
        if (countryEncodable) [countryEncodable release]; countryEncodable = nil;
#endif
    }
    if (self.typeOfSubstitution) {
        ASN1Encodable *typeOfSubstitutionEncodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:2 paramASN1Encodable:self.typeOfSubstitution];
        [localASN1EncodableVector add:typeOfSubstitutionEncodable];
#if !__has_feature(objc_arc)
        if (typeOfSubstitutionEncodable) [typeOfSubstitutionEncodable release]; typeOfSubstitutionEncodable = nil;
#endif
    }
    if (self.thirdPerson) {
        ASN1Encodable *thirdPersonEncodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:3 paramASN1Encodable:self.thirdPerson];
        [localASN1EncodableVector add:thirdPersonEncodable];
#if !__has_feature(objc_arc)
        if (thirdPersonEncodable) [thirdPersonEncodable release]; thirdPersonEncodable = nil;
#endif
    }else {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:3 paramASN1Encodable:self.certRef];
        [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
