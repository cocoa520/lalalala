//
//  BERTaggedObjectParser.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "BERTaggedObjectParser.h"
#import "ASN1ParsingException.h"

@interface BERTaggedObjectParser ()

@property (nonatomic, assign) BOOL constructed;
@property (nonatomic, assign) int tagNumber;
@property (nonatomic, readwrite, retain) ASN1StreamParser *parser;

@end

@implementation BERTaggedObjectParser
@synthesize constructed = _constructed;
@synthesize tagNumber = _tagNumber;
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

- (instancetype)initParamBoolean:(BOOL)paramBoolean paramInt:(int)paramInt paramASN1StreamParser:(ASN1StreamParser *)paramASN1StreamParser
{
    if (self = [super init]) {
        self.constructed = paramBoolean;
        self.tagNumber = paramInt;
        self.parser = paramASN1StreamParser;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (BOOL)isConstructed {
    return self.constructed;
}

- (int)getTagNo {
    return self.tagNumber;
}

- (ASN1Encodable *)getObjectParser:(int)paramInt paramBoolean:(BOOL)paramBoolean {
    if (paramBoolean) {
        if (!self.constructed) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"Explicit tags must be constructed (see X.690 8.14.2)" userInfo:nil];
        }
        return [self.parser readObject];
    }
    return [self.parser readImplicit:self.constructed paramInt:paramInt];
}

- (ASN1Primitive *)getLoadedObject {
    return [self.parser readTaggedObject:self.constructed paramInt:self.tagNumber];
}

- (ASN1Primitive *)toASN1Primitive {
    @try {
        return [self getLoadedObject];
    }
    @catch (NSException *exception) {
        @throw [[[ASN1ParsingException alloc] initParamString:exception.description] autorelease];
    }
}

@end
