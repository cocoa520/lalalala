//
//  ASN1Primitive.m
//  crypto
//
//  Created by JGehry on 5/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Primitive.h"
#import "ASN1Encodable.h"
#import "ASN1InputStream.h"
#import "DLSequence.h"
#import "DLSet.h"
#import "DEROctetString.h"

@implementation ASN1Primitive

+ (ASN1Primitive *)fromByteArray:(NSMutableData *)paramArrayOfByte {
    ASN1Primitive *localASN1Primitive = nil;
    @autoreleasepool {
        ASN1InputStream *localASN1InputStream = [[ASN1InputStream alloc] initParamArrayOfByte:paramArrayOfByte];
        @try {
            localASN1Primitive = [[localASN1InputStream readObject] retain];
            if ([localASN1InputStream available]) {
                @throw [NSException exceptionWithName:NSGenericException reason:@"Extra data detected in stream" userInfo:nil];
            }
#if !__has_feature(objc_arc)
            if (localASN1InputStream) [localASN1InputStream release]; localASN1InputStream = nil;
#endif
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"cannot recognise object in stream" userInfo:nil];
        }
    }
    return [localASN1Primitive autorelease];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    return ([object isKindOfClass:[ASN1Encodable class]] && [self asn1Equals:[((ASN1Encodable*)object) toASN1Primitive]]);
}

- (ASN1Primitive *)toASN1Primitive {
    return self;
}

- (ASN1Primitive *)toDERObject
{
    return self;
}

- (ASN1Primitive *)toDLObject
{
    return self;
}

- (BOOL)isConstructed {
    return NO;
}

- (int)encodedLength {
    return 0;
}

- (void)encode:(ASN1OutputStream *)paramASN1OutputStream {
}

- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive {
    return NO;
}

- (NSUInteger)hash {
    return 0;
}

@end
