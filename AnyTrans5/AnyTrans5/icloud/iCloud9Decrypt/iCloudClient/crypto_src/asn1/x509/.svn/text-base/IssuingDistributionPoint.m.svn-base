//
//  IssuingDistributionPoint.m
//  crypto
//
//  Created by JGehry on 7/11/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "IssuingDistributionPoint.h"
#import "ASN1Boolean.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"

@interface IssuingDistributionPoint ()

@property (nonatomic, readwrite, retain) DistributionPointName *distributionPoint;
@property (nonatomic, assign) BOOL onlyContainsUserCerts;
@property (nonatomic, assign) BOOL onlyContainsCACerts;
@property (nonatomic, readwrite, retain) ReasonFlags *onlySomeReasons;
@property (nonatomic, assign) BOOL indirectCRL;
@property (nonatomic, assign) BOOL onlyContainsAttributeCerts;
@property (nonatomic, readwrite, retain) ASN1Sequence *seq;

@end

@implementation IssuingDistributionPoint
@synthesize distributionPoint = _distributionPoint;
@synthesize onlyContainsUserCerts = _onlyContainsUserCerts;
@synthesize onlyContainsCACerts = _onlyContainsCACerts;
@synthesize onlySomeReasons = _onlySomeReasons;
@synthesize indirectCRL = _indirectCRL;
@synthesize onlyContainsAttributeCerts = _onlyContainsAttributeCerts;
@synthesize seq = _seq;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_distributionPoint) {
        [_distributionPoint release];
        _distributionPoint = nil;
    }
    if (_onlySomeReasons) {
        [_onlySomeReasons release];
        _onlySomeReasons = nil;
    }
    if (_seq) {
        [_seq release];
        _seq = nil;
    }
    [super dealloc];
#endif
}

+ (IssuingDistributionPoint *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[IssuingDistributionPoint class]]) {
        return (IssuingDistributionPoint *)paramObject;
    }
    if (paramObject) {
        return [[[IssuingDistributionPoint alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (IssuingDistributionPoint *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [IssuingDistributionPoint getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.seq = paramASN1Sequence;
        for (int i = 0; i != [paramASN1Sequence size]; i++) {
            ASN1TaggedObject *localASN1TaggedObject = [ASN1TaggedObject getInstance:[paramASN1Sequence getObjectAt:i]];
            switch ([localASN1TaggedObject getTagNo]) {
                case 0:
                    self.distributionPoint = [DistributionPointName getInstance:localASN1TaggedObject paramBoolean:YES];
                    break;
                case 1:
                    self.onlyContainsUserCerts = [[ASN1Boolean getInstance:localASN1TaggedObject paramBoolean:NO] isTrue];
                    break;
                case 2:
                    self.onlyContainsCACerts = [[ASN1Boolean getInstance:localASN1TaggedObject paramBoolean:NO] isTrue];
                    break;
                case 3: {
                    ReasonFlags *flags = [[ReasonFlags alloc] initParamDERBitString:[ReasonFlags getInstance:localASN1TaggedObject paramBoolean:NO]];
                    self.onlySomeReasons = flags;
#if !__has_feature(objc_arc)
    if (flags) [flags release]; flags = nil;
#endif
                }
                    break;
                case 4:
                    self.indirectCRL = [[ASN1Boolean getInstance:localASN1TaggedObject paramBoolean:NO] isTrue];
                    break;
                case 5:
                    self.onlyContainsAttributeCerts = [[ASN1Boolean getInstance:localASN1TaggedObject paramBoolean:YES] isTrue];
                    break;
                default:
                    @throw [NSException exceptionWithName:NSGenericException reason:@"unknown tag in IssuingDistributionPoint" userInfo:nil];
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

- (instancetype)initParamDistributionPointName:(DistributionPointName *)paramDistributionPointName paramBoolean1:(BOOL)paramBoolean1 paramBoolean2:(BOOL)paramBoolean2
{
    if (self = [super init]) {
        [self initParamDistributionPointName:paramDistributionPointName paramBoolean1:NO paramBoolean2:NO paramReasonFlags:nil paramBoolean3:paramBoolean1 paramBoolean4:paramBoolean2];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamDistributionPointName:(DistributionPointName *)paramDistributionPointName paramBoolean1:(BOOL)paramBoolean1 paramBoolean2:(BOOL)paramBoolean2 paramReasonFlags:(ReasonFlags *)paramReasonFlags paramBoolean3:(BOOL)paramBoolean3 paramBoolean4:(BOOL)paramBoolean4
{
    if (self = [super init]) {
        self.distributionPoint = paramDistributionPointName;
        self.indirectCRL = paramBoolean3;
        self.onlyContainsAttributeCerts = paramBoolean4;
        self.onlyContainsCACerts = paramBoolean2;
        self.onlyContainsUserCerts = paramBoolean1;
        self.onlySomeReasons = paramReasonFlags;
        ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
        if (paramDistributionPointName) {
            ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:0 paramASN1Encodable:paramDistributionPointName];
            [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
            if (encodable) [encodable release]; encodable = nil;
#endif
        }
        if (paramBoolean1) {
            ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:1 paramASN1Encodable:[ASN1Boolean getInstanceBoolean:YES]];
            [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
            if (encodable) [encodable release]; encodable = nil;
#endif
        }
        if (paramBoolean2) {
            ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:2 paramASN1Encodable:[ASN1Boolean getInstanceBoolean:YES]];
            [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
            if (encodable) [encodable release]; encodable = nil;
#endif
        }
        if (paramReasonFlags) {
            ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:3 paramASN1Encodable:paramReasonFlags];
            [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
            if (encodable) [encodable release]; encodable = nil;
#endif
        }
        if (paramBoolean3) {
            ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:4 paramASN1Encodable:[ASN1Boolean getInstanceBoolean:YES]];
            [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
            if (encodable) [encodable release]; encodable = nil;
#endif
        }
        if (paramBoolean4) {
            ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:5 paramASN1Encodable:[ASN1Boolean getInstanceBoolean:YES]];
            [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
            if (encodable) [encodable release]; encodable = nil;
#endif
        }
        ASN1Sequence *sequence = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector];
        self.seq = sequence;
#if !__has_feature(objc_arc)
        if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
        if (sequence) [sequence release]; sequence = nil;
#endif
    }
    return self;
}

- (BOOL)onlyContainsUserCerts {
    return self.onlyContainsUserCerts;
}

- (BOOL)onlyContainsCACerts {
    return self.onlyContainsCACerts;
}

- (BOOL)isIndirectCRL {
    return self.indirectCRL;
}

- (BOOL)onlyContainsAttributeCerts {
    return self.onlyContainsAttributeCerts;
}

- (DistributionPointName *)getDistributionPoint {
    return self.distributionPoint;
}

- (ReasonFlags *)getOnlySomeReasons {
    return self.onlySomeReasons;
}

- (ASN1Primitive *)toASN1Primitive {
    return self.seq;
}

- (NSString *)toString {
    NSString *str = nil;
    NSMutableString *localStringBuffer = [[NSMutableString alloc] init];
    [localStringBuffer appendString:@"IssuingDistributionPoint: ["];
    [localStringBuffer appendString:str];
    if ([self distributionPoint]) {
        [self appendObject:localStringBuffer paramString1:str paramString2:@"distributionPoint" paramString3:[self.distributionPoint toString]];
    }
    if ([self onlyContainsUserCerts]) {
        [self appendObject:localStringBuffer paramString1:str paramString2:@"onlyContainsUserCerts" paramString3:[self booleanToString:[self onlyContainsUserCerts]]];
    }
    if ([self onlyContainsCACerts]) {
        [self appendObject:localStringBuffer paramString1:str paramString2:@"onlyContainsCACerts" paramString3:[self booleanToString:[self onlyContainsCACerts]]];
    }
    if ([self onlySomeReasons]) {
        [self appendObject:localStringBuffer paramString1:str paramString2:@"onlySomeReasons" paramString3:[self.onlySomeReasons toString]];
    }
    if ([self onlyContainsAttributeCerts]) {
        [self appendObject:localStringBuffer paramString1:str paramString2:@"onlyContainsAttributeCerts" paramString3:[self booleanToString:[self onlyContainsAttributeCerts]]];
    }
    if (self.indirectCRL) {
        [self appendObject:localStringBuffer paramString1:str paramString2:@"indirectCRL" paramString3:[self booleanToString:[self indirectCRL]]];
    }
    [localStringBuffer appendString:@"]"];
    [localStringBuffer appendString:str];
    NSString *tmpLocalStringBuffer = localStringBuffer.description;
#if !__has_feature(objc_arc)
    if (localStringBuffer) [localStringBuffer release]; localStringBuffer = nil;
#endif
    return [NSString stringWithFormat:@"%@", tmpLocalStringBuffer];
}

- (void)appendObject:(NSMutableString *)paramStringBuffer paramString1:(NSString *)paramString1 paramString2:(NSString *)paramString2 paramString3:(NSString *)paramString3 {
    NSString *str = @"    ";
    [paramStringBuffer appendString:str];
    [paramStringBuffer appendString:paramString2];
    [paramStringBuffer appendString:@":"];
    [paramStringBuffer appendString:paramString1];
    [paramStringBuffer appendString:str];
    [paramStringBuffer appendString:str];
    [paramStringBuffer appendString:paramString3];
    [paramStringBuffer appendString:paramString1];
}

- (NSString *)booleanToString:(BOOL)paramBoolean {
    return paramBoolean ? @"true" : @"false";
}

@end
