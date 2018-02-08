//
//  BEROctetStringParser.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "BEROctetStringParser.h"
#import "ConstructedOctetStream.h"
#import "BEROctetString.h"
#import "StreamUtil.h"
#import "ASN1ParsingException.h"

@interface BEROctetStringParser ()

@property (nonatomic, readwrite, retain) ASN1StreamParser *parser;

@end

@implementation BEROctetStringParser
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

- (Stream *)getOctetStream {
    return [[[ConstructedOctetStream alloc] initParamASN1StreamParser:self.parser] autorelease];
}

- (ASN1Primitive *)getLoadedObject {
    return [[[BEROctetString alloc] initParamArrayOfByte:[StreamUtil readAll:[self getOctetStream]]] autorelease];
}

- (ASN1Primitive *)toASN1Primitive {
    @try {
        return [self getLoadedObject];
    }
    @catch (NSException *exception) {
        @throw [[ASN1ParsingException alloc] initParamString:[NSString stringWithFormat:@"IOException converting stream to byte array: %@", exception.description] paramThrowable:exception];
    }
}

@end
