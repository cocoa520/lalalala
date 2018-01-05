//
//  SafeBag.m
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "SafeBag.h"
#import "ASN1Sequence.h"
#import "ASN1TaggedObject.h"
#import "DLTaggedObject.h"
#import "DLSequence.h"

@interface SafeBag ()

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *bagId;
@property (nonatomic, readwrite, retain) ASN1Encodable *bagValue;
@property (nonatomic, readwrite, retain) ASN1Set *bagAttributes;

@end

@implementation SafeBag
@synthesize bagId = _bagId;
@synthesize bagValue = _bagValue;
@synthesize bagAttributes = _bagAttributes;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_bagId) {
        [_bagId release];
        _bagId = nil;
    }
    if (_bagValue) {
        [_bagValue release];
        _bagValue = nil;
    }
    if (_bagAttributes) {
        [_bagAttributes release];
        _bagAttributes = nil;
    }
    [super dealloc];
#endif
}

+ (SafeBag *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[SafeBag class]]) {
        return (SafeBag *)paramObject;
    }
    if (paramObject) {
        return [[[SafeBag alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.bagId = (ASN1ObjectIdentifier *)[paramASN1Sequence getObjectAt:0];
        self.bagValue = [(ASN1TaggedObject *)[paramASN1Sequence getObjectAt:1] getObject];
        if ([paramASN1Sequence size] == 3) {
            self.bagAttributes = (ASN1Set *)[paramASN1Sequence getObjectAt:2];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable
{
    if (self = [super init]) {
        self.bagId = paramASN1ObjectIdentifier;
        self.bagValue = paramASN1Encodable;
        self.bagAttributes = nil;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable paramASN1Set:(ASN1Set *)paramASN1Set
{
    if (self = [super init]) {
        self.bagId = paramASN1ObjectIdentifier;
        self.bagValue = paramASN1Encodable;
        self.bagAttributes = paramASN1Set;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (ASN1ObjectIdentifier *)getBagId {
    return self.bagId;
}

- (ASN1Encodable *)getBagValue {
    return self.bagValue;
}

- (ASN1Set *)getBagAttributes {
    return self.bagAttributes;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.bagId];
    ASN1Encodable *encodable = [[DLTaggedObject alloc] initParamBoolean:YES paramInt:0 paramASN1Encodable:self.bagValue];
    [localASN1EncodableVector add:encodable];
    if (self.bagAttributes) {
        [localASN1EncodableVector add:self.bagAttributes];
    }
    ASN1Primitive *primitive = [[[DLSequence alloc] initDLParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (encodable) [encodable release]; encodable = nil;
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
