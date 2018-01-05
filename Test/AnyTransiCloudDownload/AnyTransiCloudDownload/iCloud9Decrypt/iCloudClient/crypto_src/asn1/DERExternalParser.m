//
//  DERExternalParser.m
//  crypto
//
//  Created by JGehry on 7/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DERExternalParser.h"
#import "DERExternal.h"
#import "ASN1Exception.h"
#import "ASN1ParsingException.h"

@interface DERExternalParser ()

@property (nonatomic, readwrite, retain) ASN1StreamParser *parser;

@end

@implementation DERExternalParser
@synthesize parser = _parser;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_parser) {
        [_parser release];
        _parser = nil;
    }
    [super dealloc];
#endif
}

- (instancetype)initParamASN1StreamParser:(ASN1StreamParser *)paramASN1StreamParser
{
    if (self = [super init]) {
        self.parser = paramASN1StreamParser;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1Encodable *)readObject {
    return [self.parser readObject];
}

- (ASN1Primitive *)getLoadedObject {
    @try {
        return [[[DERExternal alloc] initParamASN1EncodableVector:[self.parser readVector]] autorelease];
    }
    @catch (NSException *exception) {
        @throw [[[ASN1Exception alloc] initParamString:exception.description paramThrowable:exception] autorelease];
    }
}

- (ASN1Primitive *)toASN1Primitive {
    @try {
        return [self getLoadedObject];
    }
    @catch (NSException *exception) {
        @throw [[ASN1ParsingException alloc] initParamString:@"unable to get DER object" paramThrowable:exception];
    }
}

@end
