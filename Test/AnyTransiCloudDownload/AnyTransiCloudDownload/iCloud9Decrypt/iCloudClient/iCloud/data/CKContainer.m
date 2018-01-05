//
//  CKContainer.m
//  
//
//  Created by Pallas on 4/25/16.
//
//  Complete

#import "CKContainer.h"

@interface CKContainer ()

@property (nonatomic, readwrite, retain) NSString *name;
@property (nonatomic, readwrite, retain) NSString *env;
@property (nonatomic, readwrite, retain) NSString *ckDeviceUrl;
@property (nonatomic, readwrite, retain) NSString *url;

@end

@implementation CKContainer
@synthesize name = _name;
@synthesize env = _env;
@synthesize ckDeviceUrl = _ckDeviceUrl;
@synthesize url = _url;

- (id)initWithName:(NSString*)name withEnv:(NSString*)env withCkDeviceUrl:(NSString*)ckDeviceUrl withUrl:(NSString*)url {
    self = [super init];
    if (!self) {
        return nil;
    }
    [self setName:name];
    [self setEnv:env];
    [self setCkDeviceUrl:ckDeviceUrl];
    [self setUrl:url];
    return self;
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_name != nil) [_name release]; _name = nil;
    if (_env != nil) [_env release]; _env = nil;
    if (_ckDeviceUrl != nil) [_ckDeviceUrl release]; _ckDeviceUrl = nil;
    if (_url != nil) [_url release]; _url = nil;
    [super dealloc];
#endif
}

- (BOOL)isEqual:(id)object {
    if (object == nil) {
        return NO;
    }
    if ([self class] != [object class]) {
        return NO;
    }
    CKContainer *other = (CKContainer*)object;
    if (![[self name] isEqualToString:[other name]]) {
        return NO;
    }
    if (![[self env] isEqualToString:[other env]]) {
        return NO;
    }
    if (![[self ckDeviceUrl] isEqualToString:[other ckDeviceUrl]]) {
        return NO;
    }
    if (![[self url] isEqualToString:[other url]]) {
        return NO;
    }
    return YES;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Values{ name = %@, env = %@, ckDeviceUrl = %@, url = %@ }", [self name], [self env], [self ckDeviceUrl], [self url]];
}

@end
