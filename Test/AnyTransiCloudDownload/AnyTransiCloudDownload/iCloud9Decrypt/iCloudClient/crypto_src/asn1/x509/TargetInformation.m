//
//  TargetInformation.m
//  crypto
//
//  Created by JGehry on 7/14/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "TargetInformation.h"
#import "DERSequence.h"

@interface TargetInformation ()

@property (nonatomic, readwrite, retain) ASN1Sequence *targets;

@end

@implementation TargetInformation
@synthesize targets = _targets;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_targets) {
        [_targets release];
        _targets = nil;
    }
    [super dealloc];
#endif
}

+ (TargetInformation *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[TargetInformation class]]) {
        return (TargetInformation *)paramObject;
    }
    if (paramObject) {
        return [[[TargetInformation alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.targets = paramASN1Sequence;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamTargets:(Targets *)paramTargets
{
    if (self = [super init]) {
        ASN1Sequence *sequence = [[DERSequence alloc] initDERParamASN1Encodable:paramTargets];
        self.targets = sequence;
#if !__has_feature(objc_arc)
    if (sequence) [sequence release]; sequence = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfTarget:(NSMutableArray *)paramArrayOfTarget
{
    if (self = [super init]) {
        Targets *targets = [[Targets alloc] initParamArrayOfTarget:paramArrayOfTarget];
        [self initParamTargets:targets];
#if !__has_feature(objc_arc)
        if (targets) [targets release]; targets = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (NSMutableArray *)getTargetsObjects {
    NSMutableArray *arrayOfTargets = [[[NSMutableArray alloc] initWithSize:(int)[self.targets size]] autorelease];
    int i = 0;
    NSEnumerator *localEnumeration = [self.targets getObjects];
    id localObject = nil;
    while (localObject = [localEnumeration nextObject]) {
        arrayOfTargets[i++] = [Targets getInstance:localObject];
    }
    return arrayOfTargets;
}

- (ASN1Primitive *)toASN1Primitive {
    return self.targets;
}

@end
