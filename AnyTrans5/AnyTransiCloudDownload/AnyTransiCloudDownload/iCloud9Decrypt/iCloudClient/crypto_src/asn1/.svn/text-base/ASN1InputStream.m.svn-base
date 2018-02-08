//
//  ASN1InputStream.m
//  crypto
//
//  Created by JGehry on 6/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1InputStream.h"
#import "StreamUtil.h"
#import "ASN1BitString.h"
#import "DERBMPString.h"
#import "ASN1Boolean.h"
#import "ASN1Enumerated.h"
#import "ASN1GeneralizedTime.h"
#import "DERGeneralString.h"
#import "DERIA5String.h"
#import "ASN1Integer.h"
#import "DERNull.h"
#import "DERNumericString.h"
#import "ASN1ObjectIdentifier.h"
#import "DEROctetString.h"
#import "DERPrintableString.h"
#import "DERT61String.h"
#import "DERUniversalString.h"
#import "ASN1UTCTime.h"
#import "DERUTF8String.h"
#import "DERVisibleString.h"
#import "DERGraphicString.h"
#import "DERVideotexString.h"
#import "IndefiniteLengthInputStream.h"
#import "ASN1StreamParser.h"
#import "BERApplicationSpecificParser.h"
#import "BERTaggedObjectParser.h"
#import "BEROctetStringParser.h"
#import "BERSequenceParser.h"
#import "BERSetParser.h"
#import "DERExternalParser.h"
#import "DERApplicationSpecific.h"
#import "BEROctetString.h"
#import "LazyEncodedSequence.h"
#import "DERFactory.h"
#import "DERExternal.h"
#import "CategoryExtend.h"

@interface ASN1InputStream ()

@property (nonatomic, readwrite, retain) Stream *iN;
@property (nonatomic, assign) int limit;
@property (nonatomic, assign) BOOL lazyEvaluate;
@property (nonatomic, readwrite, retain) NSMutableArray *tmpBuffers;

@end

@implementation ASN1InputStream
@synthesize iN = _iN;
@synthesize limit = _limit;
@synthesize lazyEvaluate = _lazyEvaluate;
@synthesize tmpBuffers = _tmpBuffers;

+ (int)readTagNumber:(Stream *)paramInputStream paramInt:(int)paramInt {
    int i = paramInt & 0x1F;
    if (i == 0x1F) {
        i = 0;
        int j = [paramInputStream read];
        if ((j & 0x7F) == 0) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"corrupted stream - invalid high tag number found" userInfo:nil];
        }
        while ((j >= 0) && ((j & 0x80) != 0)) {
            i |= j & 0x7F;
            i <<= 7;
            j = [paramInputStream read];
        }
        if (j < 0) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"EOF found inside tag value." userInfo:nil];
        }
        i |= j & 0x7F;
    }
    return i;
}

+ (int)readLength:(Stream *)paramInputStream paramInt:(int)paramInt {
    int i = [paramInputStream read];
    if (i < 0) {
        @throw [NSException exceptionWithName:NSGenericException reason:@"EOF found when length expected" userInfo:nil];
    }
    if (i == 128) {
        return -1;
    }
    if (i > 127) {
        int j = i & 0x7F;
        if (j > 4) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"DER length more than 4 bytes: %d", j] userInfo:nil];
        }
        i = 0;
        for (int k = 0; k < j; k++) {
            int m = [paramInputStream read];
            if (m < 0) {
                @throw [NSException exceptionWithName:NSGenericException reason:@"EOF found reading length" userInfo:nil];
            }
            i = ((i << 8) + m);
        }
        if (i < 0) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"corrupted stream - negative length found" userInfo:nil];
        }
        if (i >= paramInt) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"corrupted stream - out of bounds length found" userInfo:nil];
        }
    }
    return i;
}

- (void)readFully:(NSMutableData *)bytes {
    if ([Stream readFully:self withBuf:bytes] != [bytes length]) {
        @throw [NSException exceptionWithName:NSGenericException reason:@"EOF encountered in middle of object" userInfo:nil];
    }
}

+ (NSMutableData *)getBuffer:(DefiniteLengthInputStream *)paramDefiniteLengthInputStream paramArrayOfByte:(NSMutableArray *)paramArrayOfByte {
    int i = [paramDefiniteLengthInputStream getRemaining];
    if ([paramDefiniteLengthInputStream getRemaining] < [paramArrayOfByte count]) {
        NSMutableData *arrayOfByte = paramArrayOfByte[i];
        if (!arrayOfByte) {
            NSMutableData *tmpData = [[NSMutableData alloc] initWithSize:i];
            paramArrayOfByte[i] = tmpData;
            arrayOfByte = paramArrayOfByte[i];
#if !__has_feature(objc_arc)
            if (tmpData) [tmpData release]; tmpData = nil;
#endif
        }else {
            [arrayOfByte setFixedSize:i];
        }
        [Stream readFully:paramDefiniteLengthInputStream withBuf:arrayOfByte];
        return arrayOfByte;
    }
    return [paramDefiniteLengthInputStream toByteArray];
}

+ (NSMutableArray *)getBMPCharBuffer:(DefiniteLengthInputStream *)paramDefiniteLengthInputStream {
    int i = ([paramDefiniteLengthInputStream getRemaining] / 2);
    NSMutableArray *arrayOfChar = [[[NSMutableArray alloc] initWithSize:i] autorelease];
    int j = 0;
    while (j < i) {
        int k = [paramDefiniteLengthInputStream read];
        if (k < 0) {
            break;
        }
        int m = [paramDefiniteLengthInputStream read];
        if (m < 0) {
            break;
        }
        arrayOfChar[j++] = @((char)(k << 8 | (m & 0xFF)));
    }
    return arrayOfChar;
}

+ (ASN1Primitive *)createPrimitiveDERObject:(int)paramInt paramDefiniteLengthInputStream:(DefiniteLengthInputStream *)paramDefiniteLengthInputStream paramArrayOfByte:(NSMutableArray *)paramArrayOfByte {
    switch (paramInt) {
        case 3: {
            return [ASN1BitString fromInputStream:[paramDefiniteLengthInputStream getRemaining] paramInputStream:paramDefiniteLengthInputStream];
        }
        case 30: {
            return [[[DERBMPString alloc] initParamArrayOfChar:[self getBMPCharBuffer:paramDefiniteLengthInputStream]] autorelease];
        }
        case 1: {
            return [ASN1Boolean fromOctetString:[self getBuffer:paramDefiniteLengthInputStream paramArrayOfByte:paramArrayOfByte]];
        }
        case 10: {
            return [ASN1Enumerated fromOctetString:[self getBuffer:paramDefiniteLengthInputStream paramArrayOfByte:paramArrayOfByte]];
        }
        case 24: {
            return [[[ASN1GeneralizedTime alloc] initParamArrayOfByte:[paramDefiniteLengthInputStream toByteArray]] autorelease];
        }
        case 27: {
            return [[[DERGeneralString alloc] initParamArrayOfByte:[paramDefiniteLengthInputStream toByteArray]] autorelease];
        }
        case 22: {
            return [[[DERIA5String alloc] initParamArrayOfByte:[paramDefiniteLengthInputStream toByteArray]] autorelease];
        }
        case 2: {
            return [[[ASN1Integer alloc] initParamArrayOfByte:[paramDefiniteLengthInputStream toByteArray] paramBoolean:NO] autorelease];
        }
        case 5: {
            return [DERNull INSTANCE];
        }
        case 18: {
            return [[[DERNumericString alloc] initParamArrayOfByte:[paramDefiniteLengthInputStream toByteArray]] autorelease];
        }
        case 6: {
            return [ASN1ObjectIdentifier fromOctetString:[self getBuffer:paramDefiniteLengthInputStream paramArrayOfByte:paramArrayOfByte]];
        }
        case 4: {
            return [[[DEROctetString alloc] initDEROctetString:[paramDefiniteLengthInputStream toByteArray]] autorelease];
        }
        case 19: {
            return [[[DERPrintableString alloc] initParamArrayOfByte:[paramDefiniteLengthInputStream toByteArray]] autorelease];
        }
        case 20: {
            return [[[DERT61String alloc] initParamArrayOfByte:[paramDefiniteLengthInputStream toByteArray]] autorelease];
        }
        case 28: {
            return [[[DERUniversalString alloc] initParamArrayOfByte:[paramDefiniteLengthInputStream toByteArray]] autorelease];
        }
        case 23: {
            return [[[ASN1UTCTime alloc] initParamArrayOfByte:[paramDefiniteLengthInputStream toByteArray]] autorelease];
        }
        case 12: {
            return [[[DERUTF8String alloc] initParamArrayOfByte:[paramDefiniteLengthInputStream toByteArray]] autorelease];
        }
        case 26: {
            return [[[DERVisibleString alloc] initParamArrayOfByte:[paramDefiniteLengthInputStream toByteArray]] autorelease];
        }
        case 25: {
            return [[[DERGraphicString alloc] initParamArrayOfByte:[paramDefiniteLengthInputStream toByteArray]] autorelease];
        }
        case 21: {
            return [[[DERVideotexString alloc] initParamArrayOfByte:[paramDefiniteLengthInputStream toByteArray]] autorelease];
        }
 
        default:
            break;
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"unknown tag %d encountered", paramInt] userInfo:nil];
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

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte
{
    if (self = [super init]) {
        MemoryStreamEx *mem = [[MemoryStreamEx alloc] initWithData:paramArrayOfByte];
        [self initParamInputStream:mem paramInt:(int)[paramArrayOfByte length]];
#if !__has_feature(objc_arc)
        if (mem) [mem release]; mem = nil;
#endif
        return self;
    } else {
#if !__has_feature(objc_arc)
        [super dealloc];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramBoolean:(BOOL)paramBoolean
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

- (instancetype)initParamInputStream:(Stream *)paramInputStream paramInt:(int)paramInt
{
    if (self = [self initParamInputStream:paramInputStream paramInt:paramInt paramBoolean:NO]) {
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamInputStream:(Stream *)paramInputStream paramBoolean:(BOOL)paramBoolean
{
    if (self = [self initParamInputStream:paramInputStream paramInt:[StreamUtil findLimit:paramInputStream] paramBoolean:paramBoolean]) {
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamInputStream:(Stream *)paramInputStream paramInt:(int)paramInt paramBoolean:(BOOL)paramBoolean
{
    if (self = [super init]) {
        self.iN = paramInputStream;
        self.limit = paramInt;
        self.lazyEvaluate = paramBoolean;
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

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setIN:nil];
    [self setTmpBuffers:nil];
    [super dealloc];
#endif
}

- (ASN1Primitive *)readObject {
    int i =  [self.iN read];
    if (i <= 0) {
        if (i == 0) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"unexpected end-of-contents marker" userInfo:nil];
        }
        return nil;
    }
    int j = [ASN1InputStream readTagNumber:self.iN paramInt:i];
    int k = (i & 0x20) != 0 ? 1 : 0;
    int m = [ASN1InputStream readLength:self.iN paramInt:self.limit];
    if (m < 0) {
        if (k == 0) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"indefinite-length primitive encoding encountered" userInfo:nil];
        }
        IndefiniteLengthInputStream *localIndefiniteLengthInputStream = [[IndefiniteLengthInputStream alloc] initParamInputStream:self.iN paramInt:self.limit];
        ASN1StreamParser *localASN1StreamParser = [[ASN1StreamParser alloc] initParamInputStream:localIndefiniteLengthInputStream paramInt:self.limit];
#if !__has_feature(objc_arc)
    if (localIndefiniteLengthInputStream) [localIndefiniteLengthInputStream release]; localIndefiniteLengthInputStream = nil;
#endif
        
        if ((i & 0x40) != 0) {
            BERApplicationSpecificParser *berParser = [[BERApplicationSpecificParser alloc] initParamInt:j paramASN1StreamParser:localASN1StreamParser];
            ASN1Primitive *primitive = [berParser getLoadedObject];
#if !__has_feature(objc_arc)
            if (berParser) [berParser release]; berParser = nil;
#endif
            return primitive;
        }
        if ((i & 0x80) != 0) {
            BERTaggedObjectParser *berTagged = [[BERTaggedObjectParser alloc] initParamBoolean:YES paramInt:j paramASN1StreamParser:localASN1StreamParser];
            ASN1Primitive *primitive = [berTagged getLoadedObject];
#if !__has_feature(objc_arc)
    if (berTagged) [berTagged release]; berTagged = nil;
#endif
            return primitive;
        }
        switch (j) {
            case 4: {
                BEROctetStringParser *berOSP = [[BEROctetStringParser alloc] initParamASN1StreamParser:localASN1StreamParser];
                ASN1Primitive *primitive = [berOSP getLoadedObject];
#if !__has_feature(objc_arc)
                if (berOSP) [berOSP release]; berOSP = nil;
#endif
                return primitive;
            }
            case 16: {
                BERSequenceParser *berSP = [[BERSequenceParser alloc] initParamASN1StreamParser:localASN1StreamParser];
                ASN1Primitive *primitive = [berSP getLoadedObject];
#if !__has_feature(objc_arc)
                if (berSP) [berSP release]; berSP = nil;
#endif
                return primitive;
            }
            case 17: {
                BERSetParser *berSP =[[BERSetParser alloc] initParamASN1StreamParser:localASN1StreamParser];
                ASN1Primitive *primitive = [berSP getLoadedObject];
#if !__has_feature(objc_arc)
                if (berSP) [berSP release]; berSP = nil;
#endif
                return primitive;
            }
            case 8: {
                DERExternalParser *derEP = [[DERExternalParser alloc] initParamASN1StreamParser:localASN1StreamParser];
                ASN1Primitive *primitive = [derEP getLoadedObject];
#if !__has_feature(objc_arc)
                if (derEP) [derEP release]; derEP = nil;
#endif
                return primitive;
            }
            default:
                break;
        }
        @throw [NSException exceptionWithName:NSGenericException reason:@"unknown BER object encountered" userInfo:nil];
    }else {        
        @try {
            return [self buildObject:i paramInt2:j paramInt3:m];
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"corrupted stream detected %@", exception] userInfo:nil];
        }
    }
}

- (int)getLimit {
    return self.limit;
}

- (ASN1Primitive *)buildObject:(int)paramInt1 paramInt2:(int)paramInt2 paramInt3:(int)paramInt3 {
    BOOL isBool = (paramInt1 & 0x20) != 0;
    DefiniteLengthInputStream *localDefiniteLengthInputStream = [[DefiniteLengthInputStream alloc] initParamInputStream:self.iN paramInt:paramInt3];
    if ((paramInt1 & 0x40) != 0) {
        ASN1Primitive *primitive = [[[DERApplicationSpecific alloc] initParamBoolean:isBool paramInt:paramInt2 paramArrayOfByte:[localDefiniteLengthInputStream toByteArray]] autorelease];
#if !__has_feature(objc_arc)
        if (localDefiniteLengthInputStream) [localDefiniteLengthInputStream release]; localDefiniteLengthInputStream = nil;
#endif
        return primitive;
    }
    if ((paramInt1 & 0x80) != 0) {
        ASN1StreamParser *parser = [[ASN1StreamParser alloc] initParamInputStream:localDefiniteLengthInputStream];
        ASN1Primitive *primitive = [parser readTaggedObject:isBool paramInt:paramInt2];
#if !__has_feature(objc_arc)
        if (localDefiniteLengthInputStream) [localDefiniteLengthInputStream release]; localDefiniteLengthInputStream = nil;
        if (parser) [parser release]; parser = nil;
#endif
        return primitive;
    }
    if (isBool) {
        switch (paramInt2) {
            case 4: {
                ASN1EncodableVector *localASN1EncodableVector = [self buildDEREncodableVector:localDefiniteLengthInputStream];
                NSMutableArray *arrayOfASN1OctetString = [[NSMutableArray alloc] initWithSize:(int)[localASN1EncodableVector size]];
                for (int i = 0; i != [arrayOfASN1OctetString count]; i++) {
                    arrayOfASN1OctetString[i] = (ASN1OctetString *)[localASN1EncodableVector get:i];
                }
                ASN1Primitive *primitive = [[[BEROctetString alloc] initParamArrayOfASN1OctetString:arrayOfASN1OctetString] autorelease];
#if !__has_feature(objc_arc)
    if (arrayOfASN1OctetString) [arrayOfASN1OctetString release]; arrayOfASN1OctetString = nil;
#endif
                return primitive;
            }
            case 16: {
                if (self.lazyEvaluate) {
                    ASN1Primitive *primitive = [[[LazyEncodedSequence alloc] initParamArrayOfByte:[localDefiniteLengthInputStream toByteArray]] autorelease];
#if !__has_feature(objc_arc)
    if (localDefiniteLengthInputStream) [localDefiniteLengthInputStream release]; localDefiniteLengthInputStream = nil;
#endif
                    return primitive;
                }
                return [DERFactory createSequence:[self buildDEREncodableVector:localDefiniteLengthInputStream]];
            }
            case 17:
                return [DERFactory createSet:[self buildDEREncodableVector:localDefiniteLengthInputStream]];
            case 8: {
                ASN1Primitive *primitive = [[[DERExternal alloc] initParamASN1EncodableVector:[self buildDEREncodableVector:localDefiniteLengthInputStream]] autorelease];
#if !__has_feature(objc_arc)
                if (localDefiniteLengthInputStream) [localDefiniteLengthInputStream release]; localDefiniteLengthInputStream = nil;
#endif
                return primitive;
            }
            default:
                break;
        }
        @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"unknown tag %d encountered", paramInt2] userInfo:nil];
    }
    ASN1Primitive *primitive = [ASN1InputStream createPrimitiveDERObject:paramInt2 paramDefiniteLengthInputStream:localDefiniteLengthInputStream paramArrayOfByte:self.tmpBuffers];
#if !__has_feature(objc_arc)
    if (localDefiniteLengthInputStream) [localDefiniteLengthInputStream release]; localDefiniteLengthInputStream = nil;
#endif
    return primitive;
}

- (ASN1EncodableVector *)buildDEREncodableVector:(DefiniteLengthInputStream *)paramDefiniteLengthInputStream {
    ASN1InputStream *inputStream = [[ASN1InputStream alloc] initParamInputStream:paramDefiniteLengthInputStream];
    ASN1EncodableVector *vector = [inputStream buildEncodableVector];
#if !__has_feature(objc_arc)
    if (inputStream) [inputStream release]; inputStream = nil;
#endif
    return vector;
}

- (ASN1EncodableVector *)buildEncodableVector {
    ASN1EncodableVector *localASN1EncodableVector = [[[ASN1EncodableVector alloc] init] autorelease];
    ASN1Primitive *localASN1Primitive = nil;
    @autoreleasepool {
        while ((localASN1Primitive = [self readObject])) {
            [localASN1EncodableVector add:localASN1Primitive];
        }
    }
    return localASN1EncodableVector;
}

@end
