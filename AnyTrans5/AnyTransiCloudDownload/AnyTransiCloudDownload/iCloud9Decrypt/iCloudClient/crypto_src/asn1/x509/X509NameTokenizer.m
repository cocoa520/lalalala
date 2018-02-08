//
//  X509NameTokenizer.m
//  crypto
//
//  Created by JGehry on 7/13/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "X509NameTokenizer.h"

@interface X509NameTokenizer ()

@property (nonatomic, readwrite, retain) NSString *value;
@property (nonatomic, assign) int index;
@property (nonatomic, assign) char separator;
@property (nonatomic, readwrite, retain) NSMutableString *buf;

@end

@implementation X509NameTokenizer
@synthesize value = _value;
@synthesize index = _index;
@synthesize separator = _separator;
@synthesize buf = _buf;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_value) {
        [_value release];
        _value = nil;
    }
    if (_buf) {
        [_buf release];
        _buf = nil;
    }
    [super dealloc];
#endif
}

- (instancetype)initParamString:(NSString *)paramString
{
    if (self = [super init]) {
        [self initParamString:paramString paramChar:(char)[@"," cStringUsingEncoding:NSUTF8StringEncoding]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamString:(NSString *)paramString paramChar:(char)paramChar
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
    return self.index != [self.value length];
}

- (NSString *)nextToken {
    if (self.index == [self.value length]) {
        return nil;
    }
    int i = self.index + 1;
    int j = 0;
    int k = 0;
    while (i != [self.value length]) {
        char c = [self.value characterAtIndex:i];
        if (c == (char)[@"""" cStringUsingEncoding:NSUTF8StringEncoding]) {
            if (k == 0) {
                j = j == 0 ? 1 : 0;
            }
            [self.buf appendString:[NSString stringWithCString:&c encoding:NSUTF8StringEncoding]];
            k = 0;
        }else if ((k != 0) || (j != 0)) {
            [self.buf appendString:[NSString stringWithCString:&c encoding:NSUTF8StringEncoding]];
            k = 0;
        }else if (c == (char)[@"\\" cStringUsingEncoding:NSUTF8StringEncoding]) {
            [self.buf appendString:[NSString stringWithCString:&c encoding:NSUTF8StringEncoding]];
            k = 1;
        }else {
            if (c == self.separator) {
                break;
            }
            [self.buf appendString:[NSString stringWithCString:&c encoding:NSUTF8StringEncoding]];
        }
        i++;
    }
    self.index = i;
    return [NSString stringWithFormat:@"%@", self.buf];
}

@end
