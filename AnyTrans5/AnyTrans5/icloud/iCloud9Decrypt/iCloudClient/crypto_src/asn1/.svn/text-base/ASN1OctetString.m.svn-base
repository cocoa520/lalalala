//
//  ASN1OctetString.m
//  crypto
//
//  Created by JGehry on 5/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1OctetString.h"
#import "ASN1Encodable.h"
#import "BEROctetString.h"
#import "DEROctetString.h"
#import "Arrays.h"
#import "Hex.h"

@implementation ASN1OctetString
@synthesize string = _string;

+ (ASN1OctetString *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[ASN1OctetString class]]) {
        return (ASN1OctetString *)paramObject;
    }
    if ([paramObject isKindOfClass:[NSMutableData class]]) {
        @try {
            return [ASN1OctetString getInstance:[ASN1Primitive fromByteArray:(NSMutableData *)paramObject]];
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"failed to construct OCTET STRING from byte[]: %@", exception.description] userInfo:nil];
        }
    }
    if ([paramObject isKindOfClass:[ASN1Encodable class]]) {
        ASN1Primitive *localPrimitive = [((ASN1Encodable *)paramObject) toASN1Primitive];
        if ([localPrimitive isKindOfClass:[ASN1OctetString class]]) {
            return (ASN1OctetString *)localPrimitive;
        }
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"illegal object in getInstance: %s", object_getClassName(paramObject)] userInfo:nil];
}

+ (ASN1OctetString *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    ASN1Primitive *localASN1Primitive = [paramASN1TaggedObject getObject];
    if (paramBoolean || [localASN1Primitive isKindOfClass:[ASN1OctetString class]]) {
        return [ASN1OctetString getInstance:localASN1Primitive];
    }
    return [BEROctetString fromSequence:[ASN1Sequence getInstance:localASN1Primitive]];
}

- (instancetype)initWithParamAOB:(NSMutableData *)paramArrayOfByte
{
    if (self = [super init]) {
        if (!paramArrayOfByte) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"string cannot be null" userInfo:nil];
        }
        self.string = paramArrayOfByte;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (void)dealloc
{
    [self setString:nil];
    [super dealloc];
}

- (ASN1OctetStringParser *)parser {
    return self;
}

- (NSMutableData *)getOctets {
    return self.string;
}

- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive {
    if (![paramASN1Primitive isKindOfClass:[ASN1OctetString class]]) {
        return NO;
    }
    ASN1OctetString *localASN1OctetString = (ASN1OctetString *)paramASN1Primitive;
    return [Arrays areEqualWithByteArray:self.string withB:[localASN1OctetString string]];
}

- (ASN1Primitive *)getLoadedObject {
    return [self toASN1Primitive];
}

- (ASN1Primitive *)toDERObject {
    return [[[DEROctetString alloc] initDEROctetString:self.string] autorelease];
}

- (ASN1Primitive *)toDLObject {
    return [[[DEROctetString alloc] initDEROctetString:self.string] autorelease];
}

- (void)encode:(ASN1OutputStream *)paramASN1OutputStream {
}

- (NSString *)toString {
    NSString *dataStr = [[NSString alloc] initWithData:[Hex encode:self.string] encoding:NSUTF8StringEncoding];
    NSString *returnStr = [NSString stringWithFormat:@"#%@", dataStr];
#if !__has_feature(objc_arc)
    if (dataStr) [dataStr release]; dataStr = nil;
#endif
    return returnStr;
}

- (NSUInteger)hash {
    return [Arrays getHashCodeWithByteArray:self.getOctets];
}

@end
