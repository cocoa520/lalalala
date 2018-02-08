//
//  CRLDistPoint.m
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CRLDistPoint.h"
#import "DistributionPoint.h"
#import "DERSequence.h"

@implementation CRLDistPoint
@synthesize seq = _seq;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_seq) {
        [_seq release];
        _seq = nil;
    }
    [super dealloc];
#endif
}

+ (CRLDistPoint *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[CRLDistPoint class]]) {
        return (CRLDistPoint *)paramObject;
    }
    if (paramObject) {
        return [[[CRLDistPoint alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (CRLDistPoint *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [CRLDistPoint getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.seq = paramASN1Sequence;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfDistributionPoint:(NSMutableArray *)paramArrayOfDistributionPoint
{
    if (self = [super init]) {
        ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
        for (int i = 0; i != paramArrayOfDistributionPoint.count; i++) {
            [localASN1EncodableVector add:paramArrayOfDistributionPoint[i]];
        }
        ASN1Sequence *sequence = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector];
        self.seq = sequence;
#if !__has_feature(objc_arc)
    if (sequence) [sequence release]; sequence = nil;
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (NSMutableArray *)getDistributionPoints {
    NSMutableArray *arrayOfDistributionPoint = [[[NSMutableArray alloc] initWithSize:(int)[self.seq size]] autorelease];
    for (int i = 0; i != [self.seq size]; i++) {
        arrayOfDistributionPoint[i] = [DistributionPoint getInstance:[self.seq getObjectAt:i]];
    }
    return arrayOfDistributionPoint;
}

- (ASN1Primitive *)toASN1Primitive {
    return self.seq;
}

- (NSString *)toString {
    NSMutableString *localStringBuffer = [[NSMutableString alloc] init];
    NSString *str = nil;
    [localStringBuffer appendString:@"CRLDistPoint:"];
    [localStringBuffer appendString:str];
    NSMutableArray *arrayOfDistributionPoint = [self getDistributionPoints];
    for (int i = 0; i != arrayOfDistributionPoint.count; i++) {
        [localStringBuffer appendString:@"    "];
        [localStringBuffer appendString:arrayOfDistributionPoint[i]];
        [localStringBuffer appendString:str];
    }
    NSString *tmpLocalStringBuffer = localStringBuffer.description;
#if !__has_feature(objc_arc)
    if (localStringBuffer) [localStringBuffer release]; localStringBuffer = nil;
#endif
    return [NSString stringWithFormat:@"%@", tmpLocalStringBuffer];
}

@end
