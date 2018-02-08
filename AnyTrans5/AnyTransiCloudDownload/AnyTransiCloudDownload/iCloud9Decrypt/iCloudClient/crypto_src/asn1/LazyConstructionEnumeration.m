//
//  LazyConstructionEnumeration.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "LazyConstructionEnumeration.h"
#import "ASN1ParsingException.h"

@interface LazyConstructionEnumeration ()

@property (nonatomic, readwrite, retain) ASN1InputStream *aIn;
@property (nonatomic, readwrite, retain) id nextObj;

@end

@implementation LazyConstructionEnumeration
@synthesize aIn = _aIn;
@synthesize nextObj = _nextObj;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_aIn) {
        [_aIn release];
        _aIn = nil;
    }
    if (_nextObj) {
        [_nextObj release];
        _nextObj = nil;
    }
    [super dealloc];
#endif
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte
{
    if (self = [super init]) {
        ASN1InputStream *inputStream = [[ASN1InputStream alloc] initParamArrayOfByte:paramArrayOfByte paramBoolean:YES];
        self.aIn = inputStream;
#if !__has_feature(objc_arc)
    if (inputStream) [inputStream release]; inputStream = nil;
#endif
        self.nextObj = [self readObject];
    }
    return self;
}

- (BOOL)hasMoreElements {
    return self.nextObj != nil;
}

- (id)nextElement {
    id localObject = self.nextObj;
    self.nextObj = [self readObject];
    return localObject;
}

- (id)readObject {
    @try {
        return [self.aIn readObject];
    }
    @catch (NSException *exception) {
        @throw [[ASN1ParsingException alloc] initParamString:[NSString stringWithFormat:@"malformed DER construction: %@", exception] paramThrowable:nil];
    }
}

@end
