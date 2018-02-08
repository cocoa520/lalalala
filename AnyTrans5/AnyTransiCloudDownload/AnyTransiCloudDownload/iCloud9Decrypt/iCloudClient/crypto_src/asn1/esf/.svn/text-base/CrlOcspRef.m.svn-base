//
//  CrlOcspRef.m
//  crypto
//
//  Created by JGehry on 7/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CrlOcspRef.h"
#import "ASN1Sequence.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"

@interface CrlOcspRef ()

@property (nonatomic, readwrite, retain) CrlListID *crlids;
@property (nonatomic, readwrite, retain) OcspListID *ocspids;
@property (nonatomic, readwrite, retain) OtherRevRefs *otherRev;

@end

@implementation CrlOcspRef
@synthesize crlids = _crlids;
@synthesize ocspids = _ocspids;
@synthesize otherRev = _otherRev;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_crlids) {
        [_crlids release];
        _crlids = nil;
    }
    if (_ocspids) {
        [_ocspids release];
        _ocspids = nil;
    }
    if (_otherRev) {
        [_otherRev release];
        _otherRev = nil;
    }
    [super dealloc];
#endif
}

+ (CrlOcspRef *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[CrlOcspRef class]]) {
        return (CrlOcspRef *)paramObject;
    }
    if (paramObject) {
        return [[[CrlOcspRef alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        DERTaggedObject *localDERTaggedObject = nil;
        while (localDERTaggedObject = [localEnumeration nextObject]) {
            switch ([localDERTaggedObject getTagNo]) {
                case 0:
                    self.crlids = [CrlListID getInstance:[localDERTaggedObject getObject]];
                    break;
                case 1:
                    self.ocspids = [OcspListID getInstance:[localDERTaggedObject getObject]];
                    break;
                case 2:
                    self.otherRev = [OtherRevRefs getInstance:[localDERTaggedObject getObject]];
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

- (instancetype)initParamCrlListID:(CrlListID *)paramCrlListID paramOcspListID:(OcspListID *)paramOcspListID paramOtherRevRefs:(OtherRevRefs *)paramOtherRevRefs
{
    if (self = [super init]) {
        self.crlids = paramCrlListID;
        self.ocspids = paramOcspListID;
        self.otherRev = paramOtherRevRefs;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (CrlListID *)getCrlids {
    return self.crlids;
}

- (OcspListID *)getOcspids {
    return self.ocspids;
}

- (OtherRevRefs *)getOtherRev {
    return self.otherRev;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if (self.crlids) {
        ASN1Encodable *crlidsEncodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:0 paramASN1Encodable:[self.crlids toASN1Primitive]];
        [localASN1EncodableVector add:crlidsEncodable];
#if !__has_feature(objc_arc)
        if (crlidsEncodable) [crlidsEncodable release]; crlidsEncodable = nil;
#endif
    }
    if (self.ocspids) {
        ASN1Encodable *ocspids = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:1 paramASN1Encodable:[self.ocspids toASN1Primitive]];
        [localASN1EncodableVector add:ocspids];
#if !__has_feature(objc_arc)
        if (ocspids) [ocspids release]; ocspids = nil;
#endif
    }
    if (self.otherRev) {
        ASN1Encodable *otherRev = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:2 paramASN1Encodable:[self.otherRev toASN1Primitive]];
        [localASN1EncodableVector add:otherRev];
#if !__has_feature(objc_arc)
        if (otherRev) [otherRev release]; otherRev = nil;
#endif
   }
    ASN1Primitive *primitive =  [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
