//
//  NameConstraints.m
//  crypto
//
//  Created by JGehry on 7/11/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "NameConstraints.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"
#import "DERTaggedObject.h"
#import "GeneralSubtree.h"

@interface NameConstraints ()

@property (nonatomic, readwrite, retain) NSMutableArray *permitted;
@property (nonatomic, readwrite, retain) NSMutableArray *excluded;

@end

@implementation NameConstraints
@synthesize permitted = _permitted;
@synthesize excluded = _excluded;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_permitted) {
        [_permitted release];
        _permitted = nil;
    }
    if (_excluded) {
        [_excluded release];
        _excluded = nil;
    }
    [super dealloc];
#endif
}

+ (NameConstraints *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[NameConstraints class]]) {
        return (NameConstraints *)paramObject;
    }
    if (paramObject) {
        return [[[NameConstraints alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        id localObject = nil;
        while (localObject = [localEnumeration nextObject]) {
            ASN1TaggedObject *localASN1TaggedObject = [ASN1TaggedObject getInstance:localObject];
            switch ([localASN1TaggedObject getTagNo]) {
                case 0:
                    self.permitted = [self createArray:[ASN1Sequence getInstance:localASN1TaggedObject paramBoolean:NO]];
                    break;
                case 1:
                    self.excluded = [self createArray:[ASN1Sequence getInstance:localASN1TaggedObject paramBoolean:NO]];
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

- (instancetype)initParamArrayOfGeneralSubtree1:(NSMutableArray *)paramArrayOfGeneralSubtree1 paramArrayOfGeneralSubtree2:(NSMutableArray *)paramArrayOfGeneralSubtree2
{
    if (self = [super init]) {
        if (paramArrayOfGeneralSubtree1) {
            self.permitted = paramArrayOfGeneralSubtree1;
        }
        if (paramArrayOfGeneralSubtree2) {
            self.excluded = paramArrayOfGeneralSubtree2;
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (NSMutableArray *)createArray:(ASN1Sequence *)paramASN1Sequence {
    NSMutableArray *arrayOfGeneralSubtree = [[[NSMutableArray alloc] initWithSize:(int)[paramASN1Sequence size]] autorelease];
    for (int i = 0; i != arrayOfGeneralSubtree.count; i++) {
        arrayOfGeneralSubtree[i] = [GeneralSubtree getInstance:[paramASN1Sequence getObjectAt:i]];
    }
    return arrayOfGeneralSubtree;
}

- (NSMutableArray *)getPermittedSubtrees {
    return self.permitted;
}

- (NSMutableArray *)getExcludedSubtrees {
    return self.excluded;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if (self.permitted) {
        ASN1Encodable *derSequenceEncodable = [[DERSequence alloc] initDERparamArrayOfASN1Encodable:self.permitted];
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:0 paramASN1Encodable:derSequenceEncodable];
        [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
        if (derSequenceEncodable) [derSequenceEncodable release]; derSequenceEncodable = nil;
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
    if (self.excluded) {
        ASN1Encodable *derSequenceEncodable = [[DERSequence alloc] initDERparamArrayOfASN1Encodable:self.excluded];
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:1 paramASN1Encodable:derSequenceEncodable];
        [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
        if (derSequenceEncodable) [derSequenceEncodable release]; derSequenceEncodable = nil;
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
