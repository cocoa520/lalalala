//
//  DistributionPoint.m
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DistributionPoint.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"

@implementation DistributionPoint
@synthesize distributionPoint = _distributionPoint;
@synthesize reasons = _reasons;
@synthesize cRLIssuer = _cRLIssuer;

+ (DistributionPoint *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[DistributionPoint class]]) {
        return (DistributionPoint *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1Sequence class]]) {
        return [[[DistributionPoint alloc] initParamASN1Sequence:(ASN1Sequence *)paramObject] autorelease];
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"%s", object_getClassName(paramObject)] userInfo:nil];
}

+ (DistributionPoint *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [DistributionPoint getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        for (int i = 0; i != [paramASN1Sequence size]; i++) {
            ASN1TaggedObject *localASN1TaggedObject = [ASN1TaggedObject getInstance:[paramASN1Sequence getObjectAt:i]];
            switch ([localASN1TaggedObject getTagNo]) {
                case 0:
                    self.distributionPoint = [DistributionPointName getInstance:localASN1TaggedObject paramBoolean:YES];
                    break;
                case 1: {
                    ReasonFlags *flags = [[ReasonFlags alloc] initParamDERBitString:[DERBitString getInstance:localASN1TaggedObject paramBoolean:NO]];
                    self.reasons = flags;
#if !__has_feature(objc_arc)
    if (flags) [flags release]; flags = nil;
#endif
                    break;
                }
                case 2:
                    self.cRLIssuer = [GeneralNames getInstance:localASN1TaggedObject paramBoolean:NO];
                default:
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

- (instancetype)initParamDistributionPointName:(DistributionPointName *)paramDistributionPointName paramReasonFlags:(ReasonFlags *)paramReasonFlags paramGeneralNames:(GeneralNames *)paramGeneralNames
{
    if (self = [super init]) {
        self.distributionPoint = paramDistributionPointName;
        self.reasons = paramReasonFlags;
        self.cRLIssuer = paramGeneralNames;
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
    [self setDistributionPoint:nil];
    [self setReasons:nil];
    [self setCRLIssuer:nil];
    [super dealloc];
}

- (DistributionPointName *)getDistributionPoint {
    return self.distributionPoint;
}

- (ReasonFlags *)getReasons {
    return self.reasons;
}

- (GeneralNames *)getCRLIssuer {
    return self.cRLIssuer;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if (self.distributionPoint) {
        ASN1Encodable *distributionEncodable = [[DERTaggedObject alloc] initParamInt:0 paramASN1Encodable:self.distributionPoint];
        [localASN1EncodableVector add:distributionEncodable];
#if !__has_feature(objc_arc)
        if (distributionEncodable) [distributionEncodable release]; distributionEncodable = nil;
#endif
    }
    if (self.reasons) {
        ASN1Encodable *reasonsEncodable = [[DERTaggedObject alloc] initParamBoolean:false paramInt:1 paramASN1Encodable:self.reasons];
        [localASN1EncodableVector add:reasonsEncodable];
#if !__has_feature(objc_arc)
        if (reasonsEncodable) [reasonsEncodable release]; reasonsEncodable = nil;
#endif
    }
    if (self.cRLIssuer) {
        ASN1Encodable *cRLissuerEncodable = [[DERTaggedObject alloc] initParamBoolean:false paramInt:2 paramASN1Encodable:self.cRLIssuer];
        [localASN1EncodableVector add:cRLissuerEncodable];
#if !__has_feature(objc_arc)
        if (cRLissuerEncodable) [cRLissuerEncodable release]; cRLissuerEncodable = nil;
#endif
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

- (NSString *)toString {
    NSString *str = nil;
    NSMutableString *localStringBuffer = [[NSMutableString alloc] init];
    [localStringBuffer appendString:@"DistributionPoint: ["];
    [localStringBuffer appendString:str];
    if (self.distributionPoint) {
        [self appendObject:localStringBuffer paramString1:str paramString2:@"distributionPoint" paramString3:[self.distributionPoint toString]];
    }
    if (self.reasons) {
        [self appendObject:localStringBuffer paramString1:str paramString2:@"reasons" paramString3:[self.reasons toString]];
    }
    if (self.cRLIssuer) {
        [self appendObject:localStringBuffer paramString1:str paramString2:@"cRLIssuer" paramString3:[self.cRLIssuer toString]];
    }
    [localStringBuffer appendString:@"]"];
    [localStringBuffer appendString:str];
    NSString *tmpLocalStringBuffer = localStringBuffer.description;
    return [NSString stringWithFormat:@"%@", tmpLocalStringBuffer];
}

- (void)appendObject:(NSMutableString *)paramStringBuffer paramString1:(NSString *)paramString1 paramString2:(NSString *)paramString2 paramString3:(NSString *)paramString3 {
    NSString *str = @"   ";
    [paramStringBuffer appendString:str];
    [paramStringBuffer appendString:paramString2];
    [paramStringBuffer appendString:@":"];
    [paramStringBuffer appendString:paramString1];
    [paramStringBuffer appendString:str];
    [paramStringBuffer appendString:str];
    [paramStringBuffer appendString:paramString3];
    [paramStringBuffer appendString:paramString1];
}

@end
