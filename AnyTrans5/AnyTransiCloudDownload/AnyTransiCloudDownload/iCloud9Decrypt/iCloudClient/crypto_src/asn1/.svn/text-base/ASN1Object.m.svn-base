//
//  ASN1Object.m
//  crypto
//
//  Created by JGehry on 5/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1OutputStream.h"
#import "DEROutputStream.h"
#import "DLOutputStream.h"
#import "Arrays.h"

@implementation ASN1Object

+ (BOOL)hasEncodedTagValue:(id)paramObject paramInt:(int)paramInt {
    return ([paramObject isKindOfClass:[NSMutableData class]]);
}

- (NSMutableData *)getEncoded {
    MemoryStreamEx *localMemoryStream = [MemoryStreamEx memoryStreamEx];
    ASN1OutputStream *localASN1OutputStream = [[ASN1OutputStream alloc] initASN1OutputStream:localMemoryStream];
    [localASN1OutputStream writeObject:self];
    NSMutableData *data = [localMemoryStream availableData];
    NSMutableData *mutData = [Arrays copyOfWithData:data withNewLength:(int)[data length]];
#if !__has_feature(objc_arc)
    if (localASN1OutputStream) [localASN1OutputStream release]; localASN1OutputStream = nil;
#endif
    return (mutData ? [mutData autorelease] : nil);
}

- (NSMutableData *)getEncoded:(NSString *)paramString {
    MemoryStreamEx *localMemoryStream = nil;
    if ([paramString isEqualToString:@"DER"]) {
        localMemoryStream = [MemoryStreamEx memoryStreamEx];
        DEROutputStream *dOut = [[DEROutputStream alloc] initDERParamOutputStream:localMemoryStream];
        [dOut writeObject:self];
        NSMutableData *data = [localMemoryStream availableData];
        NSMutableData *mutData = [Arrays copyOfWithData:data withNewLength:(int)[data length]];
#if !__has_feature(objc_arc)
        if (dOut) [dOut release]; dOut = nil;
#endif
        return (mutData ? [mutData autorelease] : nil);
    }
    if ([paramString isEqualToString:@"DL"]) {
        localMemoryStream = [MemoryStreamEx memoryStreamEx];
        DLOutputStream *dOut = [[DLOutputStream alloc] initDLParamOutputStream:localMemoryStream];
        [dOut writeObject:self];
        NSMutableData *data = [localMemoryStream availableData];
        NSMutableData *mutData = [Arrays copyOfWithData:data withNewLength:(int)[data length]];
#if !__has_feature(objc_arc)
        if (dOut) [dOut release]; dOut = nil;
#endif
        return (mutData ? [mutData autorelease] : nil);
    }
    return [self getEncoded];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[ASN1Encodable class]]) {
        return NO;
    }
    ASN1Encodable *localASN1Encodable = (ASN1Encodable *)object;
    return [[self toASN1Primitive] isEqual:[localASN1Encodable toASN1Primitive]];
}

- (ASN1Primitive *)toASN1Object {
    return [self toASN1Primitive];
}

- (ASN1Primitive *)toASN1Primitive {
    return nil;
}

- (NSUInteger)hash {
    return [[self toASN1Primitive] hash];
}

@end
