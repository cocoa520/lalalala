//
//  Targets.m
//  crypto
//
//  Created by JGehry on 7/14/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "Targets.h"
#import "DERSequence.h"

@interface Targets ()

@property (nonatomic, readwrite, retain) ASN1Sequence *targets;

@end

@implementation Targets
@synthesize targets = _taregets;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_taregets) {
        [_taregets release];
        _taregets = nil;
    }
    [super dealloc];
#endif
}

+ (Targets *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[Targets class]]) {
        return (Targets *)paramObject;
    }
    if (paramObject) {
        return [[[Targets alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
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

- (instancetype)initParamArrayOfTarget:(NSMutableArray *)paramArrayOfTarget
{
    if (self = [super init]) {
        ASN1Sequence *sequence = [[DERSequence alloc] initDERparamArrayOfASN1Encodable:paramArrayOfTarget];
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

- (NSMutableArray *)getTargets {
    NSMutableArray *arrayOfTarget = [[[NSMutableArray alloc] initWithSize:(int)[self.targets size]] autorelease];
    int i = 0;
    NSEnumerator *localEnumeration = [self.targets getObjects];
    id localObject = nil;
    while (localObject = [localEnumeration nextObject]) {
        arrayOfTarget[i++] = [Targets getInstance:localObject];
    }
    return arrayOfTarget;
}

- (ASN1Primitive *)toASN1Primitive {
    return self.targets;
}

@end
