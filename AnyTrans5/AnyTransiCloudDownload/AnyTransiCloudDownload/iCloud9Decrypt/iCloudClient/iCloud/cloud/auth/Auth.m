//
//  Auth.m
//  
//
//  Created by Pallas on 1/7/16.
//
//  Complete

#import "Auth.h"

@interface Auth ()

@property (nonatomic, readwrite, retain) NSString *dsPrsID;
@property (nonatomic, readwrite, retain) NSString *mmeAuthToken;

@end

@implementation Auth
@synthesize dsPrsID = _dsPrsID;
@synthesize mmeAuthToken = _mmeAuthToken;

- (id)init:(NSString*)token {
    if (self = [super init]) {
        NSArray *split = [token componentsSeparatedByString:@":"];
        if (split == nil || split.count != 2) {
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setDsPrsID:(NSString*)split[0]];
        [self setMmeAuthToken:(NSString*)split[1]];
        return self;
    } else {
        return nil;
    }
}

- (id)init:(NSString*)dsPrsID withMmeAuthToken:(NSString*)mmeAuthToken {
    self = [super init];
    if (!self) {
        return nil;
    }
    [self setDsPrsID:dsPrsID];
    [self setMmeAuthToken:mmeAuthToken];
    return self;
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_dsPrsID != nil) [_dsPrsID release]; _dsPrsID = nil;
    if (_mmeAuthToken != nil) [_mmeAuthToken release]; _mmeAuthToken = nil;
    [super dealloc];
#endif
}

@end
