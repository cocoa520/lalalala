//
//  ASN1Null.m
//  crypto
//
//  Created by JGehry on 5/31/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Null.h"

@implementation ASN1Null

+ (ASN1Null *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[ASN1Null class]]) {
        return (ASN1Null *)paramObject;
    }
    if (paramObject) {
        @try {
            return [ASN1Null getInstance:[ASN1Primitive fromByteArray:(NSMutableData *)paramObject]];
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"failed to construct NULL from byte[]: %@", exception.description] userInfo:nil];
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"unknown object in getInstance(): %s", object_getClassName(paramObject)] userInfo:nil];
        }
    }
    return nil;
}

- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive {
    return [paramASN1Primitive isKindOfClass:[ASN1Null class]];
}

- (void)encode:(ASN1OutputStream *)paramASN1OutputStream {
}

- (NSString *)toString {
    return @"NULL";
}

- (NSUInteger)hash {
    return -1;
}

@end
