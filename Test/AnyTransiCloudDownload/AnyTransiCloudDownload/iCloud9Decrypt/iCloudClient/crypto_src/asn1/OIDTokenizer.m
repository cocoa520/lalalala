//
//  OIDTokenizer.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "OIDTokenizer.h"

@interface OIDTokenizer ()

@property (nonatomic, readwrite, retain) NSString *oid;
@property (nonatomic, assign) int index;

@end

@implementation OIDTokenizer
@synthesize oid = _oid;
@synthesize index = _index;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_oid) {
        [_oid release];
        _oid = nil;
    }
    [super dealloc];
#endif
}

- (instancetype)initParamString:(NSString *)paramString
{
    if (self = [super init]) {
        self.oid = paramString;
        self.index = 0;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (BOOL)hasMoreTokens {
    return self.index != -1;
}

- (NSString *)nextToken {
    if (self.index == -1) {
        return nil;
    }
   NSRange range =  [self.oid rangeOfString:@"." options:NSCaseInsensitiveSearch range:NSMakeRange(self.index, self.oid.length -  self.index)];
    int i  = -1;
    if (range.location != NSNotFound) {
        i = (int)(range.location);
    }
    if (i == -1) {
        NSString *str = [self.oid substringFromIndex:self.index];
        self.index = -1;
        return str;
    }
    NSString *str = [self.oid substringWithRange:NSMakeRange(self.index, i - self.index)];
    self.index = (i + 1);
    return str;
}

@end
