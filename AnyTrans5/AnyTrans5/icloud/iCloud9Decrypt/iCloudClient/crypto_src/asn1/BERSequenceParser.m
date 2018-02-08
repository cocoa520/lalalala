//
//  BERSequenceParser.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "BERSequenceParser.h"
#import "BERSequence.h"

@interface BERSequenceParser ()

@property (nonatomic, readwrite, retain) ASN1StreamParser *parser;

@end

@implementation BERSequenceParser
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
    return [[[BERSequence alloc] initBERParamASn1EncodableVector:[self.parser readVector]] autorelease];
}

- (ASN1Primitive *)toASN1Primitive {
    @try {
        return [self getLoadedObject];
    }
    @catch (NSException *exception) {
        @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"%@", exception.description] userInfo:nil];
    }
}

@end
