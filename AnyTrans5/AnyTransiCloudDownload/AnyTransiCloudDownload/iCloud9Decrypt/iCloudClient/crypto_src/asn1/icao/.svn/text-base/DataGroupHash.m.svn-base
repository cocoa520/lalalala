//
//  DataGroupHash.m
//  crypto
//
//  Created by JGehry on 6/15/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DataGroupHash.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"

@interface DataGroupHash ()

@property (nonatomic, readwrite, retain) ASN1Integer *dataGroupNumber;
@property (nonatomic, readwrite, retain) ASN1OctetString *dataGroupHashValue;

@end

@implementation DataGroupHash
@synthesize dataGroupNumber = _dataGroupNumber;
@synthesize dataGroupHashValue = _dataGroupHashValue;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_dataGroupNumber) {
        [_dataGroupNumber release];
        _dataGroupNumber = nil;
    }
    if (_dataGroupHashValue) {
        [_dataGroupHashValue release];
        _dataGroupHashValue = nil;
    }
    [super dealloc];
#endif
}

+ (DataGroupHash *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[DataGroupHash class]]) {
        return (DataGroupHash *)paramObject;
    }
    if (paramObject) {
        return [[[DataGroupHash alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        self.dataGroupNumber = [ASN1Integer getInstance:localEnumeration.nextObject];
        self.dataGroupHashValue = [ASN1OctetString getInstance:localEnumeration.nextObject];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamInt:(int)paramInt paramASN1OctecString:(ASN1OctetString *)paramASN1OctetString
{
    if (self = [super init]) {
        ASN1Integer *integer = [[ASN1Integer alloc] initLong:paramInt];
        self.dataGroupNumber = integer;
        self.dataGroupHashValue = paramASN1OctetString;
#if !__has_feature(objc_arc)
    if (integer) [integer release]; integer = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (int)getDataGroupNumber {
    return [[self.dataGroupNumber getValue] intValue];
}

- (ASN1OctetString *)getDataGroupHashValue {
    return self.dataGroupHashValue;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.dataGroupNumber];
    [localASN1EncodableVector add:self.dataGroupHashValue];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
