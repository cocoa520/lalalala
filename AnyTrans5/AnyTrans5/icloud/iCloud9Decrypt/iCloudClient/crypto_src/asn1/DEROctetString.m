//
//  DEROctetString.m
//  crypto
//
//  Created by JGehry on 5/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DEROctetString.h"
#import "StreamUtil.h"

@implementation DEROctetString

+ (void)encode:(DEROutputStream *)paramDEROutputStream paramArrayOfByte:(NSMutableData *)paramArrayOfByte {
    [paramDEROutputStream writeEncoded:4 paramArrayOfByte:paramArrayOfByte];
}

- (instancetype)initDEROctetString:(NSMutableData *)paramArrayOfByte
{
    if (self = [super initWithParamAOB:paramArrayOfByte]) {
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initDEROctetASN1Encodable:(ASN1Encodable *)paramASN1Encodable
{
    if (self = [super initWithParamAOB:[[paramASN1Encodable toASN1Primitive] getEncoded:@"DER"]]) {
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (BOOL)isConstructed {
    return NO;
}

- (int)encodedLength {
    return 1 + [StreamUtil calculateBodyLength:(int)[self.string length]] + (int)[self.string length];
}

- (void)encode:(ASN1OutputStream *)paramASN1OutputStream {
    [paramASN1OutputStream writeEncoded:4 paramArrayOfByte:self.string];
}

@end
