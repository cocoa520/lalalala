//
//  BasicConstraints.m
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "BasicConstraints.h"
#import "Extension.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"
#import "X509Extension.h"

@implementation BasicConstraints
@synthesize cA = _cA;
@synthesize pathLenConstraint = _pathLenConstraint;

+ (BasicConstraints *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[BasicConstraints class]]) {
        return (BasicConstraints *)paramObject;
    }
    if ([paramObject isKindOfClass:[X509Extension class]]) {
        return [BasicConstraints getInstance:[X509Extension convertValueToObject:(X509Extension *)paramObject]];
    }
    if (paramObject) {
        return [[[BasicConstraints alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (BasicConstraints *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [BasicConstraints getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

+ (BasicConstraints *)fromExtensions:(Extensions *)paramExtensions {
    return [BasicConstraints getInstance:[paramExtensions getExtensionParsedValue:[Extension basicConstraints]]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if ([paramASN1Sequence size] == 0) {
            self.cA = nil;
            self.pathLenConstraint = nil;
        }else {
            if ([[paramASN1Sequence getObjectAt:0] isKindOfClass:[ASN1Boolean class]]) {
                self.cA = [ASN1Boolean getInstanceObject:[paramASN1Sequence getObjectAt:0]];
            }else {
                self.cA = nil;
                self.pathLenConstraint = [ASN1Integer getInstance:[paramASN1Sequence getObjectAt:0]];
            }
            if ([paramASN1Sequence size] > 1) {
                if (self.cA) {
                    self.pathLenConstraint = [ASN1Integer getInstance:[paramASN1Sequence getObjectAt:1]];
                }else {
                    @throw [NSException exceptionWithName:NSGenericException reason:@"wrong sequence in constructor" userInfo:nil];
                }
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

- (instancetype)initParamBoolean:(BOOL)paramBoolean
{
    if (self = [super init]) {
        if (paramBoolean) {
            self.cA = [ASN1Boolean getInstanceBoolean:TRUE];
        }else {
            self.cA = nil;
        }
        self.pathLenConstraint = nil;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamInt:(int)paramInt
{
    if (self = [super init]) {
        self.cA = [ASN1Boolean getInstanceBoolean:TRUE];
        ASN1Integer *pathInteger = [[ASN1Integer alloc] initLong:paramInt];
        self.pathLenConstraint = pathInteger;
#if !__has_feature(objc_arc)
    if (pathInteger) [pathInteger release]; pathInteger = nil;
#endif
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
    [self setCA:nil];
    [self setPathLenConstraint:nil];
    [super dealloc];
}

- (BOOL)isCA {
    return ((self.cA != nil) && ([self.cA isTrue]));
}

- (BigInteger *)getPathLenConstraint {
    if (self.pathLenConstraint) {
        return [self.pathLenConstraint getValue];
    }
    return nil;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if (self.cA) {
        [localASN1EncodableVector add:self.cA];
    }
    if (self.pathLenConstraint) {
        [localASN1EncodableVector add:self.pathLenConstraint];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

- (NSString *)toString {
    if (!self.pathLenConstraint) {
        if (!self.cA) {
            return @"BasicConstraints: isCa(false)";
        }
        return [NSString stringWithFormat:@"BasicConstraints: isCa(%d)", [self isCA]];
    }
    return [NSString stringWithFormat:@"BasicConstraints: isCa(%d), pathLenConstraint = %@", [self isCA], [self.pathLenConstraint getValue]];
}

@end
