//
//  ASN1StreamParser.m
//  crypto
//
//  Created by JGehry on 7/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1StreamParser.h"
#import "StreamUtil.h"
#import "DERExternalParser.h"
#import "BEROctetStringParser.h"
#import "BERSequenceParser.h"
#import "BERSetParser.h"
#import "ASN1Exception.h"
#import "IndefiniteLengthInputStream.h"
#import "DERSetParser.h"
#import "DERSequenceParser.h"
#import "DEROctetString.h"
#import "DEROctetStringParser.h"
#import "DERTaggedObject.h"
#import "BERTaggedObject.h"
#import "BERFactory.h"
#import "DERFactory.h"
#import "ASN1InputStream.h"
#import "BERApplicationSpecificParser.h"
#import "BERTaggedObjectParser.h"
#import "DERApplicationSpecific.h"
#import "InMemoryRepresentable.h"

@interface ASN1StreamParser ()

@property (nonatomic, readwrite, retain) Stream *iN;
@property (nonatomic, assign) int limit;
@property (nonatomic, readwrite, retain) NSMutableArray *tmpBuffers;

@end

@implementation ASN1StreamParser
@synthesize iN = _iN;
@synthesize limit = _limit;
@synthesize tmpBuffers = _tmpBuffers;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_iN) {
        [_iN release];
        _iN = nil;
    }
    if (_tmpBuffers) {
        [_tmpBuffers release];
        _tmpBuffers = nil;
    }
    [super dealloc];
#endif
}

- (instancetype)initParamInputStream:(Stream *)paramInputStream
{
    if (self = [super init]) {
        [self initParamInputStream:paramInputStream paramInt:[StreamUtil findLimit:paramInputStream]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamInputStream:(Stream *)paramInputStream paramInt:(int)paramInt
{
    if (self = [super init]) {
        self.iN = paramInputStream;
        self.limit = paramInt;
        NSMutableArray *tmpBufferAry = [[NSMutableArray alloc] init];
        [self setTmpBuffers:tmpBufferAry];
#if !__has_feature(objc_arc)
        if (tmpBufferAry) [tmpBufferAry release]; tmpBufferAry = nil;
#endif
        for (int i = 0; i < 11; i++) {
            NSMutableData *tmpData = [[NSMutableData alloc] init];
            [[self tmpBuffers] addObject:tmpData];
#if !__has_feature(objc_arc)
            if (tmpData) [tmpData release]; tmpData = nil;
#endif
        }
        [[self tmpBuffers] setFixedSize:11];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte
{
    if (self = [super init]) {
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1Encodable *)readIndef:(int)paramInt {
    switch (paramInt) {
        case 8:
            return [[[DERExternalParser alloc] initParamASN1StreamParser:self] autorelease];
        case 4:
            return [[[BEROctetStringParser alloc] initParamASN1StreamParser:self] autorelease];
        case 16:
            return [[[BERSequenceParser alloc] initParamASN1StreamParser:self] autorelease];
        case 17:
            return [[[BERSetParser alloc] initParamASN1StreamParser:self] autorelease];
        default:
            break;
    }
    @throw [[ASN1Exception alloc] initParamString:[NSString stringWithFormat:@"unknown BER object encountered: 0x"]];
}

- (ASN1Encodable *)readImplicit:(BOOL)paramBoolean paramInt:(int)paramInt {
    if ([self.iN isKindOfClass:[IndefiniteLengthInputStream class]]) {
        if (!paramBoolean) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"indefinite-length primitive encoding encountered" userInfo:nil];
        }
        return [self readIndef:paramInt];
    }
    if (paramBoolean) {
        switch (paramInt) {
            case 17:
                return [[[DERSetParser alloc] initParamASN1StreamParser:self] autorelease];
            case 16:
                return [[[DERSequenceParser alloc] initParamASN1StreamParser:self] autorelease];
            case 4:
                return [[[BEROctetStringParser alloc] initParamASN1StreamParser:self] autorelease];
            default:
                break;
        }
    }else {
        switch (paramInt) {
            case 17:
                @throw [[ASN1Exception alloc] initParamString:@"sequences must use constructed encoding (see X.690 8.9.1/8.10.1)"];
            case 16:
                @throw [[ASN1Exception alloc] initParamString:@"sets must use constructed encoding (see X.690 8.11.1/8.12.1)"];
            case 4:
                @throw [[DEROctetStringParser alloc] initParamDefiniteLengthInputStream:(DefiniteLengthInputStream *)self.iN];
            default:
                break;
        }
    }
    @throw [[ASN1Exception alloc] initParamString:@"implicit tagging not implemented"];
}

- (ASN1Primitive *)readTaggedObject:(BOOL)paramBoolean paramInt:(int)paramInt {
    if (!paramBoolean) {
        DefiniteLengthInputStream *defIn = (DefiniteLengthInputStream *)self.iN;
        DEROctetString *encodable = [[DEROctetString alloc] initDEROctetString:[defIn toByteArray]];
        ASN1Primitive *primitive = [[[DERTaggedObject alloc] initParamBoolean:NO paramInt:paramInt paramASN1Encodable:encodable] autorelease];
#if !__has_feature(objc_arc)
    if (encodable) [encodable release]; encodable = nil;
#endif
        return primitive;
    }
    ASN1EncodableVector *encodableVector = [self readVector];
    if ([self.iN isKindOfClass:[IndefiniteLengthInputStream class]]) {
        BERTaggedObject *berTagged1 = [[[BERTaggedObject alloc] initParamBoolean:YES paramInt:paramInt paramASN1Encodable:[encodableVector get:0]] autorelease];
        BERTaggedObject *berTagged2 = [[[BERTaggedObject alloc] initParamBoolean:NO paramInt:paramInt paramASN1Encodable:[BERFactory createSequence:encodableVector]] autorelease];
        return [encodableVector size] == 1 ? berTagged1 : berTagged2;
    }
    DERTaggedObject *derTagged1 = [[[DERTaggedObject alloc] initParamBoolean:YES paramInt:paramInt paramASN1Encodable:[encodableVector get:0]] autorelease];
    DERTaggedObject *derTagged2 = [[[DERTaggedObject alloc] initParamBoolean:NO paramInt:paramInt paramASN1Encodable:[DERFactory createSequence:encodableVector]] autorelease];
    return [encodableVector size] == 1 ? derTagged1 : derTagged2;
}

- (ASN1Encodable *)readObject {
    int i = [self.iN read];
    if (i == -1) {
        return nil;
    }
    [self set00Check:NO];
    int j = [ASN1InputStream readTagNumber:self.iN paramInt:i];
    BOOL isBool = (i & 0x20) != 0;
    int k = [ASN1InputStream readLength:self.iN paramInt:self.limit];
    if (k < 0) {
        if (!isBool) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"indefinite-length primitive encoding encountered" userInfo:nil];
        }
        IndefiniteLengthInputStream *indefiniteLengthInputStream = [[IndefiniteLengthInputStream alloc] initParamInputStream:self.iN paramInt:self.limit];
        ASN1StreamParser *localASN1StreamParser = [[ASN1StreamParser alloc] initParamInputStream:indefiniteLengthInputStream paramInt:self.limit];
#if !__has_feature(objc_arc)
    if (indefiniteLengthInputStream) [indefiniteLengthInputStream release]; indefiniteLengthInputStream = nil;
#endif
        if ((i & 0x40) != 0) {
            ASN1Encodable *encodable = [[[BERApplicationSpecificParser alloc] initParamInt:j paramASN1StreamParser:localASN1StreamParser] autorelease];
#if !__has_feature(objc_arc)
            if (localASN1StreamParser) [localASN1StreamParser release]; localASN1StreamParser = nil;
#endif
            return encodable;
        }
        if ((i & 0x80) != 0) {
            ASN1Encodable *encodable = [[[BERTaggedObjectParser alloc] initParamBoolean:YES paramInt:j paramASN1StreamParser:localASN1StreamParser] autorelease];
#if !__has_feature(objc_arc)
            if (localASN1StreamParser) [localASN1StreamParser release]; localASN1StreamParser = nil;
#endif
            return encodable;
        }
        ASN1Encodable *encodable = [localASN1StreamParser readIndef:j];
#if !__has_feature(objc_arc)
        if (localASN1StreamParser) [localASN1StreamParser release]; localASN1StreamParser = nil;
#endif
        return encodable;
    }
    DefiniteLengthInputStream *definiteLengthInputStream = [[DefiniteLengthInputStream alloc] initParamInputStream:self.iN paramInt:k];
    if ((i & 0x40) != 0) {
        ASN1Encodable *encodable = [[[DERApplicationSpecific alloc] initParamBoolean:isBool paramInt:j paramArrayOfByte:[definiteLengthInputStream toByteArray]] autorelease];
#if !__has_feature(objc_arc)
        if (definiteLengthInputStream) [definiteLengthInputStream release]; definiteLengthInputStream = nil;
#endif
        return encodable;
    }
    if ((i & 0x80) != 0) {
        ASN1StreamParser *parser = [[ASN1StreamParser alloc] initParamInputStream:definiteLengthInputStream];
        ASN1Encodable *encodable = [[[BERTaggedObjectParser alloc] initParamBoolean:isBool paramInt:j paramASN1StreamParser:parser] autorelease];
#if !__has_feature(objc_arc)
        if (definiteLengthInputStream) [definiteLengthInputStream release]; definiteLengthInputStream = nil;
        if (parser) [parser release]; parser = nil;
#endif
        return encodable;
    }
    if (isBool) {
        switch (j) {
            case 4: {
                ASN1StreamParser *parser = [[ASN1StreamParser alloc] initParamInputStream:definiteLengthInputStream];
                ASN1Encodable *encodable = [[[BEROctetStringParser alloc] initParamASN1StreamParser:parser] autorelease];
#if !__has_feature(objc_arc)
                if (definiteLengthInputStream) [definiteLengthInputStream release]; definiteLengthInputStream = nil;
                if (parser) [parser release]; parser = nil;
#endif
                return encodable;
            }
            case 16: {
                ASN1StreamParser *parser = [[ASN1StreamParser alloc] initParamInputStream:definiteLengthInputStream];
                ASN1Encodable *encodable = [[[DERSequenceParser alloc] initParamASN1StreamParser:parser] autorelease];
#if !__has_feature(objc_arc)
                if (definiteLengthInputStream) [definiteLengthInputStream release]; definiteLengthInputStream = nil;
                if (parser) [parser release]; parser = nil;
#endif
                return encodable;
            }
            case 17: {
                ASN1StreamParser *parser = [[ASN1StreamParser alloc] initParamInputStream:definiteLengthInputStream];
                ASN1Encodable *encodable = [[[DERSetParser alloc] initParamASN1StreamParser:parser] autorelease];
#if !__has_feature(objc_arc)
                if (definiteLengthInputStream) [definiteLengthInputStream release]; definiteLengthInputStream = nil;
                if (parser) [parser release]; parser = nil;
#endif
                return encodable;
            }
            case 8: {
                ASN1StreamParser *parser = [[ASN1StreamParser alloc] initParamInputStream:definiteLengthInputStream];
                ASN1Encodable *encodable = [[[DERExternalParser alloc] initParamASN1StreamParser:parser] autorelease];
#if !__has_feature(objc_arc)
                if (definiteLengthInputStream) [definiteLengthInputStream release]; definiteLengthInputStream = nil;
                if (parser) [parser release]; parser = nil;
#endif
                return encodable;
            }
            default:
                break;
        }
        @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"unknown tag %d encountered", j] userInfo:nil];
    }
    switch (j) {
        case 4: {
            ASN1Encodable *encodable = [[[DEROctetStringParser alloc] initParamDefiniteLengthInputStream:definiteLengthInputStream] autorelease];
#if !__has_feature(objc_arc)
            if (definiteLengthInputStream) [definiteLengthInputStream release]; definiteLengthInputStream = nil;
#endif
            return encodable;
        }
        default:
            break;
    }
    @try {
        return [ASN1InputStream createPrimitiveDERObject:j paramDefiniteLengthInputStream:definiteLengthInputStream paramArrayOfByte:self.tmpBuffers];
    }
    @catch (NSException *exception) {
        @throw [[ASN1Exception alloc] initParamString:@"corrupted stream detected" paramThrowable:exception];
    }
}

- (void)set00Check:(BOOL)paramBoolean {
    if ([self.iN isKindOfClass:[IndefiniteLengthInputStream class]]) {
        [((IndefiniteLengthInputStream *)self.iN) setEofOn00:paramBoolean];
    }
}

- (ASN1EncodableVector *)readVector {
    ASN1EncodableVector *localASN1EncodableVector = [[[ASN1EncodableVector alloc] init] autorelease];
    ASN1Encodable *localASN1Encodable = nil;
    @autoreleasepool {
        while ((localASN1Encodable = [self readObject])) {
            if ([localASN1Encodable isKindOfClass:[InMemoryRepresentable class]]) {
                [localASN1EncodableVector add:[((InMemoryRepresentable *)localASN1Encodable) getLoadedObject]];
            }else {
                [localASN1EncodableVector add:[localASN1Encodable toASN1Primitive]];
            }
        }
    }
    return localASN1EncodableVector;
}

@end
