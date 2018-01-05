//
//  DEROctetStringParser.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DEROctetStringParser.h"
#import "DEROctetString.h"
#import "ASN1ParsingException.h"

@interface DEROctetStringParser ()

@property (nonatomic, readwrite, retain) DefiniteLengthInputStream *stream;

@end

@implementation DEROctetStringParser
@synthesize stream = _stream;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_stream) {
        [_stream release];
        _stream = nil;
    }
    [super dealloc];
#endif
}

- (instancetype)initParamDefiniteLengthInputStream:(DefiniteLengthInputStream *)paramDefiniteLengthInputStream
{
    if (self = [super init]) {
        self.stream = paramDefiniteLengthInputStream;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (Stream *)getOctetStream {
    return self.stream;
}

- (ASN1Primitive *)getLoadedObject {
    return [[[DEROctetString alloc] initDEROctetString:[self.stream toByteArray]] autorelease];
}

- (ASN1Primitive *)toASN1Primitive {
    @try {
        return [self getLoadedObject];
    }
    @catch (NSException *exception) {
        @throw [[ASN1ParsingException alloc] initParamString:[NSString stringWithFormat:@"IOException converting stream to byte array: %@", exception.description] paramThrowable:nil];
    }
}

@end
