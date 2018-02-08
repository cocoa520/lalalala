//
//  DERExternal.m
//  crypto
//
//  Created by JGehry on 6/13/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DERExternal.h"
#import "ASN1TaggedObject.h"
#import "CategoryExtend.h"
#import "Arrays.h"

@interface DERExternal ()

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *directReference;
@property (nonatomic, readwrite, retain) ASN1Integer *indirectReference;
@property (nonatomic, readwrite, retain) ASN1Primitive *dataValueDescriptor;
@property (nonatomic, assign) int encoding;
@property (nonatomic, readwrite, retain) ASN1Primitive *externalContent;

@end

@implementation DERExternal
@synthesize directReference = _directReference;
@synthesize indirectReference = _indirectReference;
@synthesize dataValueDescriptor = _dataValueDescriptor;
@synthesize encoding = _encoding;
@synthesize externalContent = _externalContent;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_directReference) {
        [_directReference release];
        _directReference = nil;
    }
    if (_indirectReference) {
        [_indirectReference release];
        _indirectReference = nil;
    }
    if (_dataValueDescriptor) {
        [_dataValueDescriptor release];
        _dataValueDescriptor = nil;
    }
    if (_externalContent) {
        [_externalContent release];
        _externalContent = nil;
    }
    [super dealloc];
#endif
}

- (instancetype)initParamASN1EncodableVector:(ASN1EncodableVector *)paramASN1EncodableVecotr
{
    if (self = [super init]) {
        int i = 0;
        ASN1Primitive *localASN1Primitive = [self getObjFromVector:paramASN1EncodableVecotr paramInt:i];
        if ([localASN1Primitive isKindOfClass:[ASN1ObjectIdentifier class]]) {
            self.directReference = (ASN1ObjectIdentifier *)localASN1Primitive;
            i++;
            localASN1Primitive = [self getObjFromVector:paramASN1EncodableVecotr paramInt:i];
        }
        if ([localASN1Primitive isKindOfClass:[ASN1Integer class]]) {
            self.indirectReference = (ASN1Integer *)localASN1Primitive;
            i++;
            localASN1Primitive = [self getObjFromVector:paramASN1EncodableVecotr paramInt:i];
        }
        if (![localASN1Primitive isKindOfClass:[ASN1TaggedObject class]]) {
            self.dataValueDescriptor = localASN1Primitive;
            i++;
            localASN1Primitive = [self getObjFromVector:paramASN1EncodableVecotr paramInt:i];
        }
        if ([paramASN1EncodableVecotr size] != i + 1) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"input vector too large" userInfo:nil];
        }
        if (![localASN1Primitive isKindOfClass:[ASN1TaggedObject class]]) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"No tagged object found in vector. Structure doesn't seem to be of type External" userInfo:nil];
        }
        ASN1TaggedObject *localASN1TaggedObject = (ASN1TaggedObject *)localASN1Primitive;
        [self setEncoding:[localASN1TaggedObject getTagNo]];
        self.externalContent = [localASN1TaggedObject getObject];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1Primitive *)getObjFromVector:(ASN1EncodableVector *)paramASN1EncodableVector paramInt:(int)paramInt {
    if ([paramASN1EncodableVector size] <= paramInt) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"too few objects in input vector" userInfo:nil];
    }
    return [[paramASN1EncodableVector get:paramInt] toASN1Primitive];
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Integer:(ASN1Integer *)paramASN1Integer paramASN1Primitive:(ASN1Primitive *)paramASN1Primitive paramDERTaggedObject:(DERTaggedObject *)paramDERTaggedObject
{
    if (self = [super init]) {
        [self initParamASN1ObjectIdentifier:paramASN1ObjectIdentifier paramASN1Integer:paramASN1Integer paramASN1Primitive:paramASN1Primitive paramInt:[paramDERTaggedObject getTagNo] paramDERTaggedObject:[paramDERTaggedObject toASN1Primitive]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Integer:(ASN1Integer *)paramASN1Integer paramASN1Primitive:(ASN1Primitive *)paramASN1Primitive1 paramInt:(int)paramInt paramDERTaggedObject:(ASN1Primitive *)paramASN1Primitive2
{
    if (self = [super init]) {
        [self setDirectReference:paramASN1ObjectIdentifier];
        [self setIndirectReference:paramASN1Integer];
        [self setDataValueDescriptor:paramASN1Primitive1];
        [self setEncoding:paramInt];
        [self setExternalContent:[paramASN1Primitive2 toASN1Primitive]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (BOOL)isConstructed {
    return YES;
}

- (int)encodedLength {
    return (int)[self getEncoded].length;
}

- (void)encode:(ASN1OutputStream *)paramASN1OutputStream {
    MemoryStreamEx *localMemoryStream = [MemoryStreamEx memoryStreamEx];
    if (self.directReference) {
        [localMemoryStream write:[self.directReference getEncoded:@"DER"]];
    }
    if (self.indirectReference) {
        [localMemoryStream write:[self.indirectReference getEncoded:@"DER"]];
    }
    if (self.dataValueDescriptor) {
        [localMemoryStream write:[self.dataValueDescriptor getEncoded:@"DER"]];
    }
    DERTaggedObject *localDERTaggedObject = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:self.encoding paramASN1Encodable:self.externalContent];
    [localMemoryStream write:[localDERTaggedObject getEncoded:@"DER"]];
    NSMutableData *data = [localMemoryStream availableData];
#if !__has_feature(objc_arc)
    if (localDERTaggedObject) [localDERTaggedObject release]; localDERTaggedObject = nil;
#endif
    NSMutableData *mutData = [Arrays copyOfWithData:data withNewLength:(int)[data length]];
    [paramASN1OutputStream writeEncoded:32 paramInt2:8 paramArrayOfByte:mutData];
#if !__has_feature(objc_arc)
    if (mutData) [mutData release]; mutData = nil;
#endif
}

- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive {
    if (![paramASN1Primitive isKindOfClass:[DERExternal class]]) {
        return NO;
    }
    if (self == paramASN1Primitive) {
        return YES;
    }
    DERExternal *localDERExternal = (DERExternal *)paramASN1Primitive;
    if ((self.directReference) && ((!localDERExternal.directReference) || (![localDERExternal.directReference isEqual:self.directReference]))) {
        return NO;
    }
    if ((self.indirectReference) && ((!localDERExternal.indirectReference) || (![localDERExternal.indirectReference isEqual:self.indirectReference]))) {
        return NO;
    }
    if ((self.dataValueDescriptor) && ((!localDERExternal.dataValueDescriptor) || (![localDERExternal.dataValueDescriptor isEqual:self.dataValueDescriptor]))) {
        return NO;
    }
    return [self.externalContent isEqual:localDERExternal.externalContent];
}

- (ASN1ObjectIdentifier *)getDirectReference {
    return self.directReference;
}

- (ASN1Integer *)getIndirectReference {
    return self.indirectReference;
}

- (ASN1Primitive *)getDataValueDescriptor {
    return self.dataValueDescriptor;
}

- (int)getEncoding {
    return self.encoding;
}

- (ASN1Primitive *)getExternalContent {
    return self.externalContent;
}

- (void)setDataValueDescriptor:(ASN1Primitive *)paramASN1Primitive {
    self.dataValueDescriptor = paramASN1Primitive;
}

- (void)setDirectReference:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier {
    self.directReference = paramASN1ObjectIdentifier;
}

- (void)setEncoding:(int)paramInt {
    if ((paramInt < 0) || (paramInt > 2)) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"invalid encoding value: %d", paramInt] userInfo:nil];
    }
    self.encoding = paramInt;
}

- (void)setExternalContent:(ASN1Primitive *)paramASN1Primitive {
    self.externalContent = paramASN1Primitive;
}

- (void)setIndirectReference:(ASN1Integer *)paramASN1Integer {
    self.indirectReference = paramASN1Integer;
}

- (NSUInteger)hash {
    int ret = 0;
    if (self.directReference) {
        ret = [self.directReference hash];
    }
    if (self.indirectReference) {
        ret ^= [self.indirectReference hash];
    }
    if (self.dataValueDescriptor) {
        ret ^= [self.dataValueDescriptor hash];
    }
    ret ^= [self.externalContent hash];
    return ret;
}

@end
