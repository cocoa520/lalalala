//
//  X500Name.m
//  crypto
//
//  Created by JGehry on 6/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "X500Name.h"
#import "ASN1Sequence.h"
#import "BCStyle.h"
#import "DERSequence.h"
#import "CategoryExtend.h"
#import "Arrays.h"

@interface X500Name ()

@property (nonatomic, assign) BOOL isHashCodeCalculated;
@property (nonatomic, assign) int hashCodeValue;
@property (nonatomic, readwrite, retain) X500NameStyle *style;
@property (nonatomic, readwrite, retain) NSMutableArray *rdns;

@end

@implementation X500Name
@synthesize isHashCodeCalculated = _isHashCodeCalculated;
@synthesize hashCodeValue = _hashCodeValue;
@synthesize style = _style;
@synthesize rdns = _rdns;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_style) {
        [_style release];
        _style = nil;
    }
    if (_rdns) {
        [_rdns release];
        _rdns = nil;
    }
    [super dealloc];
#endif
}

+ (X500NameStyle *)defaultStyle {
    static X500NameStyle *_defaultStyle = nil;
    @synchronized(self) {
        if (!_defaultStyle) {
            _defaultStyle = [[BCStyle INSTANCE] retain];
        }
    }
    return _defaultStyle;
}

+ (X500Name *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[X500Name class]]) {
        return (X500Name *)paramObject;
    }
    if (paramObject) {
        return [[[X500Name alloc] initparamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (X500Name *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [X500Name getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:YES]];
}

+ (X500Name *)getInstance:(X500NameStyle *)paramX500NameStyle paramObject:(id)paramObject {
    if ([paramObject isKindOfClass:[X500Name class]]) {
        return [[[X500Name alloc] initParamX500NameStyle:paramX500NameStyle paramX500Name:(X500Name *)paramObject] autorelease];
    }
    if (paramObject) {
        return [[[X500Name alloc] initParamX500NameStyle:paramX500NameStyle paramASN1Sequcence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (void)setDefaultStyle:(X500NameStyle *)paramX500NameStyle {
    if (!paramX500NameStyle) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"cannot set style to null" userInfo:nil];
    }
}

+ (X500NameStyle *)getDefaultStyle {
    return [self defaultStyle];
}

- (instancetype)initParamX500NameStyle:(X500NameStyle *)paramX500NameStyle paramX500Name:(X500Name *)paramX500Name
{
    if (self = [super init]) {
        self.rdns = paramX500Name.rdns;
        self.style = paramX500NameStyle;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}


- (instancetype)initparamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        [self initParamX500NameStyle:[X500Name defaultStyle] paramASN1Sequcence:paramASN1Sequence];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamX500NameStyle:(X500NameStyle *)paramX500NameStyle paramASN1Sequcence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.style = paramX500NameStyle;
        NSMutableArray *rdnsAry = [[NSMutableArray alloc] initWithSize:(int)[paramASN1Sequence size]];
        self.rdns = rdnsAry;
#if !__has_feature(objc_arc)
    if (rdnsAry) [rdnsAry release]; rdnsAry = nil;
#endif
        int i = 0;
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        id localObject = nil;
        while (localObject = [localEnumeration nextObject]) {
            self.rdns[i++] = [RDN getInstance:localObject];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfRDN:(NSMutableArray *)paramArrayOfRDN
{
    if (self = [super init]) {
        [self initParamX500NameStyle:[X500Name defaultStyle] paramArrayOfRDN:paramArrayOfRDN];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamX500NameStyle:(X500NameStyle *)paramX500NameStyle paramArrayOfRDN:(NSMutableArray *)paramArrayOfRDN
{
    if (self = [super init]) {
        self.rdns = paramArrayOfRDN;
        self.style = paramX500NameStyle;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamString:(NSString *)paramString
{
    if (self = [super init]) {
        [self initParamX500NameStyle:[X500Name defaultStyle] paramString:paramString];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamX500NameStyle:(X500NameStyle *)paramX500NameStyle paramString:(NSString *)paramString
{
    if (self = [super init]) {
        [self initParamArrayOfRDN:[paramX500NameStyle RDNFromString:paramString]];
        self.style = paramX500NameStyle;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (NSMutableArray *)getRDNS {
    NSMutableArray *arrayOfRDN = [[[NSMutableArray alloc] initWithSize:(int)self.rdns.count] autorelease];
    [arrayOfRDN copyFromIndex:0 withSource:self.rdns withSourceIndex:0 withLength:(int)[arrayOfRDN count]];
    return arrayOfRDN;
}

- (NSMutableArray *)getAttributeTypes {
    int i = 0;
    for (int j = 0; j != self.rdns.count; j++) {
        RDN *localRDN1 = self.rdns[j];
        i += [localRDN1 size];
    }
    NSMutableArray *arrayOfASN1ObjectIdentifier = [[[NSMutableArray alloc] initWithSize:(int)i] autorelease];
    i = 0;
    for (int k = 0; k != self.rdns.count; k++) {
        RDN *localRDN2 = self.rdns[k];
        if ([localRDN2 isMultiValued]) {
            NSMutableArray *arrayOfAttributeTypeAndValue = [localRDN2 getTypeAndValues];
            for (int m = 0; m != arrayOfAttributeTypeAndValue.count; m++) {
                arrayOfASN1ObjectIdentifier[i++] = [arrayOfAttributeTypeAndValue[m] getType];
            }
        }else if ([localRDN2 size] != 0) {
            arrayOfASN1ObjectIdentifier[i++] = [[localRDN2 getFirst] getType];
        }
    }
    return arrayOfASN1ObjectIdentifier;
}

- (NSMutableArray *)getRDNSParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier {
    NSMutableArray *arrayOfRDN1 = [[NSMutableArray alloc] initWithSize:(int)self.rdns.count];
    int i = 0;
    for (int j = 0; j != self.rdns.count; j++) {
        RDN *localRDN = self.rdns[j];
        if ([localRDN isMultiValued]) {
            NSMutableArray *arrayOfAttributeTypeAndValue = [[NSMutableArray alloc] initWithArray:[localRDN getTypeAndValues]];
            for (int k = 0; k != arrayOfAttributeTypeAndValue.count; k++) {
                if ([[arrayOfAttributeTypeAndValue[k] getType] isEqual:paramASN1ObjectIdentifier]) {
                    arrayOfRDN1[i++] = localRDN;
                    break;
                }
            }
#if !__has_feature(objc_arc)
    if (arrayOfAttributeTypeAndValue) [arrayOfAttributeTypeAndValue release]; arrayOfAttributeTypeAndValue = nil;
#endif
        }else if ([[[localRDN getFirst] getType] isEqual:paramASN1ObjectIdentifier]) {
            arrayOfRDN1[i++] = localRDN;
        }
    }
    NSMutableArray *arrayOfRDN2 = [[[NSMutableArray alloc] initWithSize:(int)i] autorelease];
    [arrayOfRDN2 copyFromIndex:0 withSource:arrayOfRDN1 withSourceIndex:0 withLength:(int)[arrayOfRDN2 count]];
#if !__has_feature(objc_arc)
    if (arrayOfRDN1) [arrayOfRDN1 release]; arrayOfRDN1 = nil;
#endif
    return arrayOfRDN2;
}

- (ASN1Primitive *)toASN1Primitive {
    return [[[DERSequence alloc] initDERparamArrayOfASN1Encodable:self.rdns] autorelease];
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }
    if ((![object isKindOfClass:[X500Name class]]) && (![object isKindOfClass:[ASN1Sequence class]])) {
        return NO;
    }
    ASN1Primitive *localASN1Primitive = [((ASN1Encodable *)object) toASN1Primitive];
    if ([[self toASN1Primitive] isEqual:localASN1Primitive]) {
        return YES;
    }
    @try {
        return [self.style areEqual:self paramX500Name2:[[X500Name alloc] initparamASN1Sequence:[ASN1Sequence getInstance:[((ASN1Encodable *)object) toASN1Primitive]]]];
    }
    @catch (NSException *exception) {
    }
    return NO;
}

- (NSString *)toString {
    return [self.style toString:self];
}

- (NSUInteger)hash {
    if (self.isHashCodeCalculated) {
        return self.hashCodeValue;
    }
    self.isHashCodeCalculated = YES;
    self.hashCodeValue = [self.style calculatedHashCode:self];
    return self.hashCodeValue;
}

@end
