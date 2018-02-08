//
//  Tokens.m
//  
//
//  Created by Pallas on 1/7/16.
//
//  Complete

#import "Tokens.h"
#import "CategoryExtend.h"

@interface Tokens ()

@property (nonatomic, readwrite, retain) NSDictionary *tokens;

@end

@implementation Tokens
@synthesize tokens = _tokens;

- (id)init:(NSDictionary*)tokens_ {
    if (self = [super init]) {
        [self setTokens:tokens_];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_tokens != nil) [_tokens release]; _tokens = nil;
    [super dealloc];
#endif
}

- (NSString*)get:(TokenEnum)token {
    NSString *key = TokenIdentifier(token);
    if ([NSString isNilOrEmpty:key]) {
        return nil;
    }
    id objVal = [self.tokens objectForKey:key];
    if (objVal != nil && [objVal isKindOfClass:[NSString class]]) {
        return (NSString*)objVal;
    }
    return nil;
}

@end
