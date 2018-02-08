
//
//  OtherRevVals.m
//  crypto
//
//  Created by JGehry on 7/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "OtherRevVals.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface OtherRevVals ()

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *otherRevValType;
@property (nonatomic, readwrite, retain) ASN1Encodable *otherRevVals;

@end

@implementation OtherRevVals
@synthesize otherRevValType = _otherRevValType;
@synthesize otherRevVals = _otherRevVals;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_otherRevValType) {
        [_otherRevValType release];
        _otherRevValType = nil;
    }
    if (_otherRevVals) {
        [_otherRevVals release];
        _otherRevVals = nil;
    }
    [super dealloc];
#endif
}

+ (OtherRevVals *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[OtherRevVals class]]) {
        return (OtherRevVals *)paramObject;
    }
    if (paramObject) {
        return [[[OtherRevVals alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if ([paramASN1Sequence size] != 2) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        self.otherRevValType = (ASN1ObjectIdentifier *)[paramASN1Sequence getObjectAt:0];
        @try {
            self.otherRevVals = [ASN1Primitive fromByteArray:[[[paramASN1Sequence getObjectAt:1] toASN1Primitive] getEncoded:@"DER"]];
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
        self.otherRevValType = paramASN1ObjectIdentifier;
        self.otherRevVals = paramASN1Encodable;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1ObjectIdentifier *)getOtherRevValType {
    return self.otherRevValType;
}

- (ASN1Encodable *)getOtherRevVals {
    return self.otherRevVals;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.otherRevValType];
    [localASN1EncodableVector add:self.otherRevVals];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
