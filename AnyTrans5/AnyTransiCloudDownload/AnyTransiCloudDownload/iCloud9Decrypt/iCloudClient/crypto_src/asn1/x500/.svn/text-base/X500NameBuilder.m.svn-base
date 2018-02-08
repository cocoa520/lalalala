//
//  X500NameBuilder.m
//  crypto
//
//  Created by JGehry on 6/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "X500NameBuilder.h"
#import "BCStyle.h"
#import "CategoryExtend.h"

@interface X500NameBuilder ()

@property (nonatomic, readwrite, retain) X500NameStyle *template;

@end

@implementation X500NameBuilder
@synthesize template = _template;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_template) {
        [_template release];
        _template = nil;
    }
    [super dealloc];
#endif
}

+ (NSMutableArray *)rdns {
    static NSMutableArray *_rdns = nil;
    @synchronized(self) {
        if (!_rdns) {
            _rdns = [[NSMutableArray alloc] init];
        }
    }
    return _rdns;
}

- (instancetype)init
{
    if (self = [super init]) {
        [BCStyle INSTANCE];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamX500NameStyle:(X500NameStyle *)paramX500NameStyle
{
    if (self = [super init]) {
        self.template = paramX500NameStyle;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (X500NameBuilder *)addRDNParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramString:(NSString *)paramString {
    [self addRDNParamASN1ObjectIdentifier:paramASN1ObjectIdentifier paramASN1Encodable:[self.template stringToValue:paramASN1ObjectIdentifier paramString:paramString]];
    return self;
}

- (X500NameBuilder *)addRDNParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable {
    RDN *rdn = [[RDN alloc] initParamASN1ObjectIdentifier:paramASN1ObjectIdentifier paramASN1Encodable:paramASN1Encodable];
    [[X500NameBuilder rdns] addObject:rdn];
#if !__has_feature(objc_arc)
    if (rdn) [rdn release]; rdn = nil;
#endif
    return self;
}

- (X500NameBuilder *)addRDNParamAttributeTypeAndValue:(AttributeTypeAndValue *)paramAttributeTypeAndValue {
    RDN *rdn = [[RDN alloc] initParamAttributeTypeAndValue:paramAttributeTypeAndValue];
    [[X500NameBuilder rdns] addObject:rdn];
#if !__has_feature(objc_arc)
    if (rdn) [rdn release]; rdn = nil;
#endif
    return self;
}

- (X500NameBuilder *)addMultiValueRDNParamArrayOfASN1ObjectIdentifier:(NSMutableArray *)paramArrayOfASN1ObjectIdentifier paramArrayOfString:(NSMutableArray *)paramArrayOfString {
    NSMutableArray *arrayOfASN1Encodable = [[[NSMutableArray alloc] initWithSize:(int)paramArrayOfString.count] autorelease];
    for (int i = 0; i != arrayOfASN1Encodable.count; i++) {
        arrayOfASN1Encodable[i] = [self.template stringToValue:paramArrayOfASN1ObjectIdentifier[i] paramString:paramArrayOfString[i]];
    }
    return [self addMultiValueRDNParamArrayOfASN1ObjectIdentifier:paramArrayOfASN1ObjectIdentifier paramArrayOfASN1Encodable:arrayOfASN1Encodable];
}

- (X500NameBuilder *)addMultiValueRDNParamArrayOfASN1ObjectIdentifier:(NSMutableArray *)paramArrayOfASN1ObjectIdentifier paramArrayOfASN1Encodable:(NSMutableArray *)paramArrayOfASN1Encodable {
    NSMutableArray *arrayOfAttributeTypeAndValue = [[[NSMutableArray alloc] initWithSize:(int)paramArrayOfASN1ObjectIdentifier.count] autorelease];
    for (int i = 0; i != paramArrayOfASN1ObjectIdentifier.count; i++) {
        arrayOfAttributeTypeAndValue[i] = [self.template stringToValue:paramArrayOfASN1ObjectIdentifier[i] paramString:paramArrayOfASN1Encodable[i]];
    }
    return [self addMultiValueRDNParamArrayOfAttributeTypeAndValue:arrayOfAttributeTypeAndValue];
}


- (X500NameBuilder *)addMultiValueRDNParamArrayOfAttributeTypeAndValue:(NSMutableArray *)paramArrayOfAttributeTypeAndValue {
    RDN *rdn = [[RDN alloc] initParamArrayOfAttributeTypeAndValue:paramArrayOfAttributeTypeAndValue];
    [[X500NameBuilder rdns] addObject:rdn];
#if !__has_feature(objc_arc)
    if (rdn) [rdn release]; rdn = nil;
#endif
    return self;
}

- (X500Name *)build {
    NSMutableArray *arrayOfRDN = [[NSMutableArray alloc] initWithSize:(int)[[X500NameBuilder rdns] count]];
    for (int i = 0; i != arrayOfRDN.count; i++) {
        arrayOfRDN[i] = (RDN *)[[X500NameBuilder rdns] objectAtIndex:i];
    }
    X500Name *name = [[[X500Name alloc] initParamX500NameStyle:self.template paramArrayOfRDN:arrayOfRDN] autorelease];
#if !__has_feature(objc_arc)
    if (arrayOfRDN) [arrayOfRDN release]; arrayOfRDN = nil;
#endif
    return name;
}

@end
