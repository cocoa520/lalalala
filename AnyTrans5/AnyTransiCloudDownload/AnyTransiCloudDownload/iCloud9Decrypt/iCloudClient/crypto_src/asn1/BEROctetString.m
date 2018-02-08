//
//  BEROctetString.m
//  crypto
//
//  Created by iMobie on 6/1/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "BEROctetString.h"
#import "DEROctetString.h"
#import "ASN1OutputStream.h"
#import "Arrays.h"

@interface BEROctetString ()

@property (nonatomic, readwrite, retain) NSMutableArray *octs;

@end

@implementation BEROctetString
@synthesize octs = _octs;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_octs) {
        [_octs release];
        _octs = nil;
    }
    [super dealloc];
#endif
}

+ (NSMutableData *)toByte:(NSMutableArray *)paramArrayOfASN1OctetString {
    MemoryStreamEx *localMemoryStream = [MemoryStreamEx memoryStreamEx];
    for (int i = 0; i != paramArrayOfASN1OctetString.count; i++) {
        @try {
            DEROctetString *localDEROctetString = (DEROctetString *)paramArrayOfASN1OctetString[i];
            [localMemoryStream write:[localDEROctetString getOctets]];
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s found in input should only contain DEROctetString", object_getClassName(paramArrayOfASN1OctetString[i])] userInfo:nil];
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"exception converting octets %@", exception.description] userInfo:nil];
        }
    }
    
    NSMutableData *data = [localMemoryStream availableData];
    NSMutableData *retData = nil;
    if (data) {
        retData = [Arrays copyOfWithData:data withNewLength:(int)[data length]];
    }
    return (retData ? [retData autorelease] : nil);
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte
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

- (instancetype)initParamArrayOfASN1OctetString:(NSMutableArray *)paramArrayOfASN1OctetString
{
    if (self = [super init]) {
        [BEROctetString toByte:paramArrayOfASN1OctetString];
        self.octs = paramArrayOfASN1OctetString;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (NSMutableData *)getOctets {
    return self.string;
}

- (NSEnumerator *)getObjects {
    if (!self.octs) {
        return [[self generateOcts] objectEnumerator];
    }
    int counter = 0;
    [self hasMoreElements:counter];
    [self nextElement:counter];
    return nil;
}

- (BOOL)hasMoreElements:(int)counter {
    return counter < self.octs.count;
}

- (id)nextElement:(int)counter {
    return self.octs[counter++];
}

- (NSMutableArray *)generateOcts {
    NSMutableArray *localVector = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < self.string.length; i += 1000) {
        int j;
        if (i + 1000 > self.string.length) {
            j = (int)self.string.length;
        }else {
            j = i + 1000;
        }
        NSMutableData *arrayOfByte = [[NSMutableData alloc] initWithSize:(j - i)];
        [arrayOfByte copyFromIndex:0 withSource:self.string withSourceIndex:i withLength:(int)[arrayOfByte length]];
        DEROctetString *octetString = [[DEROctetString alloc] initDEROctetString:arrayOfByte];
        [localVector addObject:octetString];
#if !__has_feature(objc_arc)
    if (octetString) [octetString release]; octetString = nil;
    if (arrayOfByte) [arrayOfByte release]; arrayOfByte = nil;
#endif
    }
    return localVector;
}

- (BOOL)isConstructed {
    return YES;
}

- (int)encodedLength {
    int i = 0;
    NSEnumerator *localEnumeration = [self getObjects];
    ASN1Encodable *encodable = nil;
    while (encodable = [localEnumeration nextObject]) {
        i += [[encodable toASN1Primitive] encodedLength];
    }
    return 2 + i + 2;
}

- (void)encode:(ASN1OutputStream *)paramASN1OutputStream {
    [paramASN1OutputStream write:36];
    [paramASN1OutputStream write:128];
    NSEnumerator *localEnumeration = [self getObjects];
    ASN1Encodable *encodable = nil;
    while (encodable = [localEnumeration nextObject]) {
        [paramASN1OutputStream writeObject:encodable];
    }
    [paramASN1OutputStream write:0];
    [paramASN1OutputStream write:0];
}

+ (BEROctetString *)fromSequence:(ASN1Sequence *)paramASN1Sequence {
    NSMutableArray *arrayOfASN1OctetString = [[NSMutableArray alloc] initWithSize:(int)[paramASN1Sequence size]];
    NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
    int i = 0;
    ASN1OctetString *asn1OctetString = nil;
    while (asn1OctetString = [localEnumeration nextObject]) {
        arrayOfASN1OctetString[i++] = asn1OctetString;
    }
    BEROctetString *octetString = [[[BEROctetString alloc] initParamArrayOfASN1OctetString:arrayOfASN1OctetString] autorelease];
#if !__has_feature(objc_arc)
    if (arrayOfASN1OctetString) [arrayOfASN1OctetString release]; arrayOfASN1OctetString = nil;
#endif
    return octetString;
}

@end
