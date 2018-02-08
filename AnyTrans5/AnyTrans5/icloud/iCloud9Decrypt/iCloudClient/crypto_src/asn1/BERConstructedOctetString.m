//
//  BERConstructedOctetString.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "BERConstructedOctetString.h"
#import "DEROctetString.h"
#import "Arrays.h"

@interface BERConstructedOctetString ()

@property (nonatomic, readwrite, retain) NSMutableArray *octsChild;

@end

@implementation BERConstructedOctetString
@synthesize octsChild = _octsChild;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_octsChild) {
        [_octsChild release];
        _octsChild = nil;
    }
    [super dealloc];
#endif
}

+ (int)MAX_LENGTH {
    static int _MAX_LENGTH = 0;
    @synchronized(self) {
        if (!_MAX_LENGTH) {
            _MAX_LENGTH = 1000;
        }
    }
    return _MAX_LENGTH;
}

+ (NSMutableData *)toBytes:(NSMutableArray *)paramVector {
    MemoryStreamEx *localMemoryStream = [MemoryStreamEx memoryStreamEx];
    for (int i = 0; i != [paramVector count]; i++) {
        @try {
            DEROctetString *localDEROctetString = (DEROctetString *)[paramVector objectAtIndex:i];
            [localMemoryStream write:[localDEROctetString getOctets]];
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"%s found in input should only contain DEROctetString", object_getClassName([paramVector objectAtIndex:i])] userInfo:nil];
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"exception converting octets %@", exception.description] userInfo:nil];
        }
    }
    NSMutableData *data = [localMemoryStream availableData];
    NSMutableData *retData = nil;
    if (data) {
        retData = [Arrays copyOfWithData:data withNewLength:(int)[data length]];
    }
    return (retData ? [retData autorelease] : nil);
}

+ (NSMutableData *)toByteArray:(ASN1Primitive *)paramASN1Primitive {
    @try {
        return [paramASN1Primitive getEncoded];
    }
    @catch (NSException *exception) {
        @throw [NSException exceptionWithName:NSGenericException reason:@"Unable to encode object" userInfo:nil];
    }
}

+ (BEROctetString *)fromSequence:(ASN1Sequence *)paramASN1Sequence {
    NSMutableArray *localVector = [[NSMutableArray alloc] init];
    NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
    id localObject = nil;
    while (localObject = [localEnumeration nextObject]) {
        [localVector addObject:localObject];
    }
    BEROctetString *octetString = [[[BERConstructedOctetString alloc] initParamVector:localVector] autorelease];
#if !__has_feature(objc_arc)
    if (localVector) [localVector release]; localVector = nil;
#endif
    return octetString;
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte
{
    if (self = [super initParamArrayOfByte:paramArrayOfByte]) {
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamVector:(NSMutableArray *)paramVector
{
    if (self = [super initParamArrayOfByte:[BERConstructedOctetString toBytes:paramVector]]) {
        self.octsChild = paramVector;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1Primitive:(ASN1Primitive *)paramASN1Primitive
{
    if (self = [super initParamArrayOfByte:[BERConstructedOctetString toByteArray:paramASN1Primitive]]) {
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1Encodable:(ASN1Encodable *)paramASN1Encodable
{
    if (self = [super init]) {
        [self initParamASN1Primitive:[paramASN1Encodable toASN1Primitive]];
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
    if (!self.octsChild) {
        return [[self generateOcts] objectEnumerator];
    }
    return [self.octsChild objectEnumerator];
}

- (NSMutableArray *)generateOcts {
    NSMutableArray *localVector = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < [self.string length]; i += 1000) {
        int j;
        if ((i + 1000) > [self.string length]) {
            j = (int)[self.string length];
        }else {
            j = i + 1000;
        }
        NSMutableData *arrayOfByte = [[NSMutableData alloc] initWithSize:(j - i)];
        [arrayOfByte copyFromIndex:0 withSource:self.string withSourceIndex:i withLength:(int)[arrayOfByte length]];
        DEROctetString *octetString = [[DEROctetString alloc] initDEROctetString:arrayOfByte];
        [localVector addObject:octetString];
#if !__has_feature(objc_arc)
    if (arrayOfByte) [arrayOfByte release]; arrayOfByte = nil;
    if (octetString) [octetString release]; octetString = nil;
#endif
    }
    return localVector;
}

@end
