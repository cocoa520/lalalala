//
//  Restriction.m
//  crypto
//
//  Created by JGehry on 6/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "Restriction.h"

@interface Restriction ()

@property (nonatomic, readwrite, retain) DirectoryString *restriction;

@end

@implementation Restriction
@synthesize restriction = _restriction;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_restriction) {
        [_restriction release];
        _restriction = nil;
    }
    [super dealloc];
#endif
}

+ (Restriction *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[Restriction class]]) {
        return (Restriction *)paramObject;
    }
    if (paramObject) {
        return [[[Restriction alloc] initParamDirectoryString:[DirectoryString getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamDirectoryString:(DirectoryString *)paramDirectoryString
{
    if (self = [super init]) {
        self.restriction = paramDirectoryString;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamString:(NSString *)paramString
{
    if (self = [super init]) {
        DirectoryString *direct = [[DirectoryString alloc] initParamString:paramString];
        self.restriction = direct;
#if !__has_feature(objc_arc)
    if (direct) [direct release]; direct = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (DirectoryString *)getRestriction {
    return self.restriction;
}

- (ASN1Primitive *)toASN1Primitive {
    return [self.restriction toASN1Primitive];
}

@end
