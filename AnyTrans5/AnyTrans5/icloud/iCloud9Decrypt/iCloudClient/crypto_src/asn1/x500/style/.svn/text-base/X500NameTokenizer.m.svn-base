//
//  X500NameTokenizer.m
//  crypto
//
//  Created by JGehry on 6/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "X500NameTokenizer.h"

@interface X500NameTokenizer ()

@property (nonatomic, readwrite, retain) NSString *value;
@property (nonatomic, assign) int index;
@property (nonatomic, assign) char *separator;

@end

@implementation X500NameTokenizer
@synthesize value = _value;
@synthesize index = _index;
@synthesize separator = _separator;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_value) {
        [_value release];
        _value = nil;
    }
    [super dealloc];
#endif
}

- (NSString *)buf {
    NSString *_buf = nil;
    @synchronized(self) {
        if (!_buf) {
            _buf = [[[NSString alloc] init] autorelease];
        }
    }
    return _buf;
}

- (instancetype)initParamString:(NSString *)paramString
{
    if (self = [super init]) {
        [self initParamString:paramString paramChar:(char *)[@"," cStringUsingEncoding:NSUTF8StringEncoding]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamString:(NSString *)paramString paramChar:(char *)paramChar
{
    if (self = [super init]) {
        self.value = paramString;
        self.index = -1;
        self.separator = paramChar;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (BOOL)hasMoreTokens {
    return self.index != self.value.length;
}

- (NSString *)nextToken {
    if (self.index == self.value.length) {
        return nil;
    }
    int i = self.index + 1;
    int j = 0;
    int k = 0;
    [[self buf] setValue:0];
    while (i != self.value.length) {
        char *c = [self.value characterAtIndex:i];
        if (c == (char *)[@"""" cStringUsingEncoding:NSUTF8StringEncoding]) {
            if (k == 0) {
                j = j == 0 ? 1 : 0;
            }
            NSString *str = [[NSString alloc] initWithCString:c encoding:NSUTF8StringEncoding];
            [[self buf] stringByAppendingString:str];
            k = 0;
#if !__has_feature(objc_arc)
    if (str) [str release]; str = nil;
#endif
        }else if ((k != 0) || (j != 0)) {
            NSString *str = [[NSString alloc] initWithCString:c encoding:NSUTF8StringEncoding];
            [[self buf] stringByAppendingString:str];
            k = 0;
#if !__has_feature(objc_arc)
            if (str) [str release]; str = nil;
#endif
        }else if (c == (char *)[@"\\" cStringUsingEncoding:NSUTF8StringEncoding]) {
            NSString *str = [[NSString alloc] initWithCString:c encoding:NSUTF8StringEncoding];
            [[self buf] stringByAppendingString:str];
            k = 1;
#if !__has_feature(objc_arc)
            if (str) [str release]; str = nil;
#endif
        }else {
            if (c == self.separator) {
                break;
            }
            NSString *str = [[NSString alloc] initWithCString:c encoding:NSUTF8StringEncoding];
            [[self buf] stringByAppendingString:str];
#if !__has_feature(objc_arc)
            if (str) [str release]; str = nil;
#endif
        }
        i++;
    }
    self.index = i;
    return [self buf];
}

@end
