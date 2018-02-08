//
//  BERApplicationSpecificParser.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "BERApplicationSpecificParser.h"
#import "BERApplicationSpecific.h"
#import "ASN1ParsingException.h"

@interface BERApplicationSpecificParser ()


@property (nonatomic, assign) int tag;
@property (nonatomic, readwrite, retain) ASN1StreamParser *parser;

@end

@implementation BERApplicationSpecificParser
@synthesize tag = _tag;
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

- (instancetype)initParamInt:(int)paramInt paramASN1StreamParser:(ASN1StreamParser *)paramASN1StreamParser
{
    if (self = [super init]) {
        self.tag = paramInt;
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
    return [[[BERApplicationSpecific alloc] initParamInt:self.tag paramASN1EncodableVector:[self.parser readVector]] autorelease];
}

- (ASN1Primitive *)toASN1Primitive {
    @try {
        return [self getLoadedObject];
    }
    @catch (NSException *exception) {
        @throw [[ASN1ParsingException alloc] initParamString:[NSString stringWithFormat:@"%@", exception.description] paramThrowable:nil];
    }
}

@end
