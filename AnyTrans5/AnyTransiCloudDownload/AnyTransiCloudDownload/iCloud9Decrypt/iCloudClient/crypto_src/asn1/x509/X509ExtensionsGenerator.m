//
//  X509ExtensionsGenerator.m
//  crypto
//
//  Created by JGehry on 7/12/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "X509ExtensionsGenerator.h"
#import "DEROctetString.h"
#import "X509Extension.h"

@interface X509ExtensionsGenerator ()

@property (nonatomic, readwrite, retain) NSMutableDictionary *extensions;
@property (nonatomic, readwrite, retain) NSMutableArray *extOrdering;

@end

@implementation X509ExtensionsGenerator
@synthesize extensions = _extensions;
@synthesize extOrdering = _extOrdering;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_extensions) {
        [_extensions release];
        _extensions = nil;
    }
    if (_extOrdering) {
        [_extOrdering release];
        _extOrdering = nil;
    }
    [super dealloc];
#endif
}

- (void)reset {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSMutableArray *ary = [[NSMutableArray alloc] init];
    self.extensions = dic;
    self.extOrdering = ary;
#if !__has_feature(objc_arc)
    if (dic) [dic release]; dic = nil;
    if (ary) [ary release]; ary = nil;
#endif
}

- (void)addExtension:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramBoolean:(BOOL)paramBoolean paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable {
    @try {
        [self addExtension:paramASN1ObjectIdentifier paramBoolean:paramBoolean paramArrayOfByte:[[paramASN1Encodable toASN1Primitive] getEncoded:@"DER"]];
    }
    @catch (NSException *exception) {
        @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"error encoding value: %@", exception.description] userInfo:nil];
    }
}

- (void)addExtension:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramBoolean:(BOOL)paramBoolean paramArrayOfByte:(NSMutableData *)paramArrayOfByte {
    if ([[self.extensions allKeys] containsObject:paramASN1ObjectIdentifier]) {
        @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"extension %@ already added", paramASN1ObjectIdentifier] userInfo:nil];
    }
    [self.extOrdering addObject:paramASN1ObjectIdentifier];
    ASN1OctetString *octetString = [[DEROctetString alloc] initDEROctetString:paramArrayOfByte];
    X509Extension *extension = [[X509Extension alloc] initParamBoolean:paramBoolean paramASN1OctetString:octetString];
    [self.extensions setObject:extension forKey:paramASN1ObjectIdentifier];
#if !__has_feature(objc_arc)
    if (octetString) [octetString release]; octetString = nil;
    if (extension) [extension release]; extension = nil;
#endif
}

- (BOOL)isEmpty {
    return !(self.extOrdering);
}

- (X509Extensions *)generate {
    return [[[X509Extensions alloc] initParamVector:self.extOrdering paramHashtable:self.extensions] autorelease];
}

@end
