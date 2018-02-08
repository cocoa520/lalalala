//
//  GeneralSubtree.m
//  crypto
//
//  Created by JGehry on 7/11/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "GeneralSubtree.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"
#import "DERTaggedObject.h"

@interface GeneralSubtree ()

@property (nonatomic, readwrite, retain) GeneralName *base;
@property (nonatomic, readwrite, retain) ASN1Integer *minimum;
@property (nonatomic, readwrite, retain) ASN1Integer *maximum;

@end

@implementation GeneralSubtree
@synthesize base = _base;
@synthesize minimum = _minimum;
@synthesize maximum = _maximum;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_base) {
        [_base release];
        _base = nil;
    }
    if (_minimum) {
        [_minimum release];
        _minimum = nil;
    }
    if (_maximum) {
        [_maximum release];
        _maximum = nil;
    }
    [super dealloc];
#endif
}

+ (BigInteger *)ZERO {
    static BigInteger *_ZERO = nil;
    @synchronized(self) {
        if (!_ZERO) {
            _ZERO = [BigInteger Zero];
        }
    }
    return _ZERO;
}

+ (GeneralSubtree *)getInstance:(id)paramObject {
    if (!paramObject) {
        return nil;
    }
    if ([paramObject isKindOfClass:[GeneralSubtree class]]) {
        return (GeneralSubtree *)paramObject;
    }
    return [[[GeneralSubtree alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
}

+ (GeneralSubtree *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [[[GeneralSubtree alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]] autorelease];
}

- (instancetype)initParamGeneralName:(GeneralName *)paramGeneralName
{
    if (self = [super init]) {
        [self initParamGeneralName:paramGeneralName paramBigInteger1:nil paramBigInteger2:nil];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamGeneralName:(GeneralName *)paramGeneralName paramBigInteger1:(BigInteger *)paramBigInteger1 paramBigInteger2:(BigInteger *)paramBigInteger2
{
    if (self = [super init]) {
        self.base = paramGeneralName;
        if (paramBigInteger2) {
            ASN1Integer *maxInteger = [[ASN1Integer alloc] initBI:paramBigInteger2];
            self.maximum = maxInteger;
#if !__has_feature(objc_arc)
    if (maxInteger) [maxInteger release]; maxInteger = nil;
#endif
        }
        if (!paramBigInteger1) {
            self.minimum = nil;
        }else {
            ASN1Integer *minInteger = [[ASN1Integer alloc] initBI:paramBigInteger1];
            self.minimum = minInteger;
#if !__has_feature(objc_arc)
            if (minInteger) [minInteger release]; minInteger = nil;
#endif
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.base = [GeneralName getInstance:[paramASN1Sequence getObjectAt:0]];
        switch ([paramASN1Sequence size]) {
            case 1:
                break;
            case 2: {
                ASN1TaggedObject *localASN1TaggedObject1 = [ASN1TaggedObject getInstance:[paramASN1Sequence getObjectAt:1]];
                switch ([localASN1TaggedObject1 getTagNo]) {
                    case 0:
                        self.minimum = [ASN1Integer getInstance:localASN1TaggedObject1 paramBoolean:NO];
                        break;
                    case 1:
                        self.maximum = [ASN1Integer getInstance:localASN1TaggedObject1 paramBoolean:NO];
                        break;
                    default:
                        @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad tag number: %d", [localASN1TaggedObject1 getTagNo]] userInfo:nil];
                        break;
                }
            }
                break;
            case 3: {
                ASN1TaggedObject *localASN1TaggedObject2 = [ASN1TaggedObject getInstance:[paramASN1Sequence getObjectAt:1]];
                if ([localASN1TaggedObject2 getTagNo]) {
                    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad tag number for 'minimum': %d", [localASN1TaggedObject2 getTagNo]] userInfo:nil];
                }
                self.minimum = [ASN1Integer getInstance:localASN1TaggedObject2 paramBoolean:NO];
                localASN1TaggedObject2 = [ASN1TaggedObject getInstance:[paramASN1Sequence getObjectAt:2]];
                if ([localASN1TaggedObject2 getTagNo] != 1) {
                    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad tag number for 'maximum': %d", [localASN1TaggedObject2 getTagNo]] userInfo:nil];
                }
                self.maximum = [ASN1Integer getInstance:localASN1TaggedObject2 paramBoolean:NO];
            }
                break;
            default:
                @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
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

- (GeneralName *)getBase {
    return self.base;
}

- (BigInteger *)getMinimum {
    if (!self.minimum) {
        return [GeneralSubtree ZERO];
    }
    return [self.minimum getValue];
}

- (BigInteger *)getMaximum {
    if (!self.maximum) {
        return nil;
    }
    return [self.maximum getValue];
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.base];
    if (self.minimum && (![[self.minimum getValue] isEqual:[GeneralSubtree ZERO]])) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:0 paramASN1Encodable:self.minimum];
        [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
    if (self.maximum) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:1 paramASN1Encodable:self.maximum];
        [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}


@end
