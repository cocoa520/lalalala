//
//  RevocationValues.m
//  crypto
//
//  Created by JGehry on 7/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "RevocationValues.h"
#import "DERSequence.h"
#import "DERTaggedObject.h"
#import "BasicOCSPResponse.h"
#import "CertificateList.h"
#import "BasicOCSPResponse.h"

@interface RevocationValues ()

@property (nonatomic, readwrite, retain) ASN1Sequence *crlVals;
@property (nonatomic, readwrite, retain) ASN1Sequence *ocspVals;
@property (nonatomic, readwrite, retain) OtherRevVals *otherRevVals;

@end

@implementation RevocationValues
@synthesize crlVals = _crlVals;
@synthesize ocspVals = _ocspVals;
@synthesize otherRevVals = _otherRevVals;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_crlVals) {
        [_crlVals release];
        _crlVals = nil;
    }
    if (_ocspVals) {
        [_ocspVals release];
        _ocspVals = nil;
    }
    if (_otherRevVals) {
        [_otherRevVals release];
        _otherRevVals = nil;
    }
    [super dealloc];
#endif
}

+ (RevocationValues *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[RevocationValues class]]) {
        return (RevocationValues *)paramObject;
    }
    if (paramObject) {
        return [[[RevocationValues alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if ([paramASN1Sequence size] > 3) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        NSEnumerator *localEnumeration1 = [paramASN1Sequence getObjects];
        DERTaggedObject *localDERTaggedObject = nil;
        while (localDERTaggedObject = [localEnumeration1 nextObject]) {
            switch ([localDERTaggedObject getTagNo]) {
                case 0: {
                    ASN1Sequence *localASN1Sequence1 = (ASN1Sequence *)[localDERTaggedObject getObject];
                    NSEnumerator *localEnumeration2 = [localASN1Sequence1 getObjects];
                    id localObject = nil;
                    while (localObject = [localEnumeration2 nextObject]) {
                        [CertificateList getInstance:localObject];
                    }
                    self.crlVals = localASN1Sequence1;
                }
                    break;
                case 1: {
                    ASN1Sequence *localASN1Sequence2 = (ASN1Sequence *)[localDERTaggedObject getObject];
                    NSEnumerator *localEnumeration3 = [localASN1Sequence2 getObjects];
                    id localObject = nil;
                    while (localObject = [localEnumeration3 nextObject]) {
                        [BasicOCSPResponse getInstance:localObject];
                    }
                    self.ocspVals = localASN1Sequence2;
                }
                    break;
                case 2: {
                    self.otherRevVals = [OtherRevVals getInstance:[localDERTaggedObject getObject]];
                }
                    break;
                default:
                    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"invalid tag: %d", [localDERTaggedObject getTagNo]] userInfo:nil];
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

- (instancetype)initParamArrayOfCertificateList:(NSMutableArray *)paramArrayOfCertificateList paramArrayOfBasicOCSPResponse:(NSMutableArray *)paramArrayOfBasicOCSPResponse paramOtherRevVals:(OtherRevVals *)paramOtherRevVals
{
    if (self = [super init]) {
        if (paramArrayOfCertificateList) {
            ASN1Sequence *sequence = [[DERSequence alloc] initDERparamArrayOfASN1Encodable:paramArrayOfCertificateList];
            self.crlVals = sequence;
#if !__has_feature(objc_arc)
            if (sequence) [sequence release]; sequence = nil;
#endif
        }
        if (paramArrayOfBasicOCSPResponse) {
            ASN1Sequence *sequence = [[DERSequence alloc] initDERparamArrayOfASN1Encodable:paramArrayOfBasicOCSPResponse];
            self.ocspVals = sequence;
#if !__has_feature(objc_arc)
            if (sequence) [sequence release]; sequence = nil;
#endif
        }
        self.otherRevVals = paramOtherRevVals;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (NSMutableArray *)getCrlVals {
    if (!self.crlVals) {
        return [[[NSMutableArray alloc] initWithSize:0] autorelease];
    }
    NSMutableArray *arrayOfCertificateList = [[[NSMutableArray alloc] initWithSize:(int)[self.crlVals size]] autorelease];
    for (int i = 0; i < arrayOfCertificateList.count; i++) {
        arrayOfCertificateList[i] = [CertificateList getInstance:[self.crlVals getObjectAt:i]];
    }
    return arrayOfCertificateList;
}

- (NSMutableArray *)getOcspVals {
    if (!self.ocspVals) {
        return [[[NSMutableArray alloc] initWithSize:0] autorelease];
    }
    NSMutableArray *arrayOfBasicOCSPResponse = [[[NSMutableArray alloc] initWithSize:(int)[self.ocspVals size]] autorelease];
    for (int i = 0; i < arrayOfBasicOCSPResponse.count; i++) {
        arrayOfBasicOCSPResponse[i] = [BasicOCSPResponse getInstance:[self.ocspVals getObjectAt:i]];
    }
    return arrayOfBasicOCSPResponse;
}

- (OtherRevVals *)getOtherRevVals {
    return self.otherRevVals;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if (self.crlVals) {
        ASN1Encodable *crlValsEncodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:0 paramASN1Encodable:self.crlVals];
        [localASN1EncodableVector add:crlValsEncodable];
#if !__has_feature(objc_arc)
        if (crlValsEncodable) [crlValsEncodable release]; crlValsEncodable = nil;
#endif
    }
    if (self.ocspVals) {
        ASN1Encodable *ocspValsEncodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:1 paramASN1Encodable:self.ocspVals];
        [localASN1EncodableVector add:ocspValsEncodable];
#if !__has_feature(objc_arc)
        if (ocspValsEncodable) [ocspValsEncodable release]; ocspValsEncodable = nil;
#endif
    }
    if (self.otherRevVals) {
        ASN1Encodable *otherRevValsEncodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:2 paramASN1Encodable:[self.otherRevVals toASN1Primitive]];
        [localASN1EncodableVector add:otherRevValsEncodable];
#if !__has_feature(objc_arc)
        if (otherRevValsEncodable) [otherRevValsEncodable release]; otherRevValsEncodable = nil;
#endif
    }
    ASN1Primitive *primitive  = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
