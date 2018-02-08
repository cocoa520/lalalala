//
//  IDEACBCPar.m
//  crypto
//
//  Created by JGehry on 6/15/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "IDEACBCPar.h"
#import "DEROctetString.h"
#import "DERSequence.h"

@implementation IDEACBCPar
@synthesize iv = _iv;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_iv) {
        [_iv release];
        _iv = nil;
    }
    [super dealloc];
#endif
}

+ (IDEACBCPar *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[IDEACBCPar class]]) {
        return (IDEACBCPar *)paramObject;
    }
    if (paramObject) {
        return [[[IDEACBCPar alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte
{
    if (self = [super init]) {
        ASN1OctetString *octetString = [[DEROctetString alloc] initDEROctetString:paramArrayOfByte];
        self.iv = octetString;
#if !__has_feature(objc_arc)
    if (octetString) [octetString release]; octetString = nil;
#endif
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
        if ([paramASN1Sequence size] == 1) {
            self.iv = ((ASN1OctetString *)[paramASN1Sequence getObjectAt:0]);
        }else {
            self.iv = nil;
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (NSMutableData *)getIV {
    if (self.iv) {
        return [self.iv getOctets];
    }
    return nil;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector =[[ASN1EncodableVector alloc] init];
    if (self.iv) {
        [localASN1EncodableVector add:self.iv];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
