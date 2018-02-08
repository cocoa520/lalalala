//
//  ExtensionsGenerator.m
//  crypto
//
//  Created by JGehry on 7/25/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ExtensionsGenerator.h"
#import "DEROctetString.h"

@interface ExtensionsGenerator ()

@property (nonatomic, readwrite, retain) NSMutableDictionary *extensions;
@property (nonatomic, readwrite, retain) NSMutableArray *extOrdering;

@end

@implementation ExtensionsGenerator
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
    [self addExtension:paramASN1ObjectIdentifier paramBoolean:paramBoolean paramArrayOfByte:[[paramASN1Encodable toASN1Primitive] getEncoded:@"DER"]];
}

- (void)addExtension:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramBoolean:(BOOL)paramBoolean paramArrayOfByte:(NSMutableData *)paramArrayOfByte {
    if ([self.extensions objectForKey:paramASN1ObjectIdentifier]) {
        @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"extension %@ already added", paramASN1ObjectIdentifier] userInfo:nil];
    }
    [self.extOrdering addObject:paramASN1ObjectIdentifier];
    ASN1OctetString *octetString = [[DEROctetString alloc] initDEROctetString:paramArrayOfByte];
    Extension *extension = [[Extension alloc] initParamASN1ObjectIdentifier:paramASN1ObjectIdentifier paramBoolean:paramBoolean paramASN1OctetString:octetString];
    [self.extensions setObject:extension forKey:paramASN1ObjectIdentifier];
#if !__has_feature(objc_arc)
    if (octetString) [octetString release]; octetString = nil;
    if (extension) [extension release]; extension = nil;
#endif
}

- (void)addExtension:(Extension *)paramExtension {
    if ([self.extensions objectForKey:[paramExtension getExtnId]]) {
        @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"extension %@ already added", [paramExtension getExtnId]] userInfo:nil];
    }
    [self.extOrdering addObject:[paramExtension getExtnId]];
    [self.extensions setObject:paramExtension forKey:[paramExtension getExtnId]];
}

- (BOOL)isEmpty {
    return !self.extOrdering;
}

- (Extensions *)generate {
    NSMutableArray *arrayOfExtension = [[NSMutableArray alloc] initWithSize:(int)[self.extOrdering count]];
    for (int i = 0; i != [self.extOrdering count]; i++) {
        arrayOfExtension[i] = (Extension *)[self.extensions objectForKey:[self.extOrdering objectAtIndex:i]];
    }
    Extensions *ex = [[[Extensions alloc] initParamArrayOfExtension:arrayOfExtension] autorelease];
#if !__has_feature(objc_arc)
    if (arrayOfExtension) [arrayOfExtension release]; arrayOfExtension = nil;
#endif
    return ex;
}


@end
