//
//  OtherRevRefs.m
//  crypto
//
//  Created by JGehry on 7/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "OtherRevRefs.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface OtherRevRefs ()

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *otherRevRefType;
@property (nonatomic, readwrite, retain) ASN1Encodable *otherRevRefs;

@end

@implementation OtherRevRefs
@synthesize otherRevRefType = _otherRevRefType;
@synthesize otherRevRefs = _otherRevRefs;

+ (OtherRevRefs *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[OtherRevRefs class]]) {
        return (OtherRevRefs *)paramObject;
    }
    if (paramObject) {
        return [[[OtherRevRefs alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (void)dealloc
{
    [self setOtherRevRefType:nil];
    [self setOtherRevRefs:nil];
    [super dealloc];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if ([paramASN1Sequence size] != 2) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:[((ASN1ObjectIdentifier *)[paramASN1Sequence getObjectAt:0]) getId]];
        self.otherRevRefType = obj;
#if !__has_feature(objc_arc)
    if (obj) [obj release]; obj = nil;
#endif
        @try {
            self.otherRevRefs = [ASN1Primitive fromByteArray:[[[paramASN1Sequence getObjectAt:1] toASN1Primitive] getEncoded:@"DER"]];
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"" userInfo:nil];
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
        self.otherRevRefType = paramASN1ObjectIdentifier;
        self.otherRevRefs = paramASN1Encodable;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1ObjectIdentifier *)getOtherRevRefType {
    return self.otherRevRefType;
}

- (ASN1Encodable *)getOtherRevRefs {
    return self.otherRevRefs;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.otherRevRefType];
    [localASN1EncodableVector add:self.otherRevRefs];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
