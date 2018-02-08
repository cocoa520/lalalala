//
//  OriginatorInfo.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "OriginatorInfo.h"
#import "ASN1Sequence.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"

@interface OriginatorInfo ()

@property (nonatomic, readwrite, retain) ASN1Set *certs;
@property (nonatomic, readwrite, retain) ASN1Set *crls;

@end

@implementation OriginatorInfo
@synthesize certs = _certs;
@synthesize crls = _crls;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_certs) {
        [_certs release];
        _certs = nil;
    }
    if (_crls) {
        [_crls release];
        _crls = nil;
    }
    [super dealloc];
#endif
}

+ (OriginatorInfo *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[OriginatorInfo class]]) {
        return (OriginatorInfo *)paramObject;
    }
    if (paramObject) {
        return [[[OriginatorInfo alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (OriginatorInfo *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [OriginatorInfo getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        switch ([paramASN1Sequence size]) {
            case 0:
                break;
            case 1: {
                ASN1TaggedObject *localASN1TaggedObject = (ASN1TaggedObject *)[paramASN1Sequence getObjectAt:0];
                switch ([localASN1TaggedObject getTagNo]) {
                    case 0:
                        self.certs = [ASN1Set getInstance:localASN1TaggedObject paramBoolean:NO];
                        break;
                    case 1:
                        self.crls = [ASN1Set getInstance:localASN1TaggedObject paramBoolean:NO];
                        break;
                    default:
                        @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad tag in OriginatorInfo: %d", [localASN1TaggedObject getTagNo]] userInfo:nil];
                        break;
                }
            }
                break;
            case 2: {
                self.certs = [ASN1Set getInstance:(ASN1TaggedObject *)[paramASN1Sequence getObjectAt:0] paramBoolean:NO];
                self.crls = [ASN1Set getInstance:(ASN1TaggedObject *)[paramASN1Sequence getObjectAt:1] paramBoolean:NO];
            }
                break;
            default:
                @throw [NSException exceptionWithName:NSGenericException reason:@"OriginatorInfo too big" userInfo:nil];
                break;
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1Set1:(ASN1Set *)paramASN1Set1 paramASN1Set2:(ASN1Set *)paramASN1Set2
{
    if (self = [super init]) {
        self.certs = paramASN1Set1;
        self.crls = paramASN1Set2;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1Set *)getCertificates {
    return self.certs;
}

- (ASN1Set *)getCRLs {
    return self.crls;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if (self.certs) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:0 paramASN1Encodable:self.certs];
        [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
    if (self.crls) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:1 paramASN1Encodable:self.crls];
        [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
    ASN1Primitive *primitive =  [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
