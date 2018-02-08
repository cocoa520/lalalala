//
//  SignerLocation.m
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "SignerLocation.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"
#import "DirectoryString.h"

@interface SignerLocation ()

@property (nonatomic, readwrite, retain) DERUTF8String *countryName;
@property (nonatomic, readwrite, retain) DERUTF8String *localityName;
@property (nonatomic, readwrite, retain) ASN1Sequence *postalAddress;

@end

@implementation SignerLocation
@synthesize countryName = _countryName;
@synthesize localityName = _localityName;
@synthesize postalAddress = _postalAddress;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_countryName) {
        [_countryName release];
        _countryName = nil;
    }
    if (_localityName) {
        [_localityName release];
        _localityName = nil;
    }
    if (_postalAddress) {
        [_postalAddress release];
        _postalAddress = nil;
    }
    [super dealloc];
#endif
}

+ (SignerLocation *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[SignerLocation class]]) {
        return (SignerLocation *)paramObject;
    }
    return [[[SignerLocation alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        DERTaggedObject *localDERTaggedObject = nil;
        while (localDERTaggedObject = [localEnumeration nextObject]) {
            switch ([localDERTaggedObject getTagNo]) {
                case 0: {
                    DERUTF8String *utf8String = [[DERUTF8String alloc] initParamString:[[DirectoryString getInstance:localDERTaggedObject paramBoolean:YES] getString]];
                    self.countryName = utf8String;
#if !__has_feature(objc_arc)
                    if (utf8String) [utf8String release]; utf8String = nil;
#endif
                }
                    break;
                case 1: {
                    DERUTF8String *utf8String = [[DERUTF8String alloc] initParamString:[[DirectoryString getInstance:localDERTaggedObject paramBoolean:YES] getString]];
                    self.localityName = utf8String;
#if !__has_feature(objc_arc)
                    if (utf8String) [utf8String release]; utf8String = nil;
#endif
                }
                    break;
                case 2:
                    if ([localDERTaggedObject isExplicit]) {
                        self.postalAddress = [ASN1Sequence getInstance:localDERTaggedObject paramBoolean:YES];
                    }else {
                        self.postalAddress = [ASN1Sequence getInstance:localDERTaggedObject paramBoolean:NO];
                    }
                    if (self.postalAddress && ([self.postalAddress size] > 6)) {
                        @throw [NSException exceptionWithName:NSGenericException reason:@"postal address must contain less than 6 strings" userInfo:nil];
                    }
                    break;
                default:
                    @throw [NSException exceptionWithName:NSGenericException reason:@"illegal tag" userInfo:nil];
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

- (instancetype)initParamDERUTF8String1:(DERUTF8String *)paramDERUTF8String1 paramDERUTF8String2:(DERUTF8String *)paramDERUTF8String2 paramASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if (paramASN1Sequence && ([paramASN1Sequence size] > 6)) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"postal address must contain less than 6 strings" userInfo:nil];
        }
        if (paramDERUTF8String1) {
            self.countryName = [DERUTF8String getInstance:[paramDERUTF8String1 toASN1Primitive]];
        }
        if (paramDERUTF8String2) {
            self.localityName = [DERUTF8String getInstance:[paramDERUTF8String2 toASN1Primitive]];
        }
        if (paramASN1Sequence) {
            self.postalAddress = [ASN1Sequence getInstance:[paramASN1Sequence toASN1Primitive]];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (DERUTF8String *)getCountryName {
    return self.countryName;
}

- (DERUTF8String *)getLocalityName {
    return self.localityName;
}

- (ASN1Sequence *)getPostalAddress {
    return self.postalAddress;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if (self.countryName) {
        ASN1Encodable *countryEncodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:0 paramASN1Encodable:self.countryName];
        [localASN1EncodableVector add:countryEncodable];
#if !__has_feature(objc_arc)
        if (countryEncodable) [countryEncodable release]; countryEncodable = nil;
#endif
    }
    if (self.localityName) {
        ASN1Encodable *localityEncodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:1 paramASN1Encodable:self.localityName];
        [localASN1EncodableVector add:localityEncodable];
#if !__has_feature(objc_arc)
        if (localityEncodable) [localityEncodable release]; localityEncodable = nil;
#endif
    }
    if (self.postalAddress) {
        ASN1Encodable *postalEncodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:2 paramASN1Encodable:self.postalAddress];
        [localASN1EncodableVector add:postalEncodable];
#if !__has_feature(objc_arc)
        if (postalEncodable) [postalEncodable release]; postalEncodable = nil;
#endif
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
