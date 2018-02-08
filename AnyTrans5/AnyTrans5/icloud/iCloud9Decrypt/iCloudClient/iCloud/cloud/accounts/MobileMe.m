//
//  MobileMe.m
//  
//
//  Created by Pallas on 4/11/16.
//
//  Complete

#import "MobileMe.h"

@interface MobileMe ()

@property (nonatomic, readwrite, retain) NSDictionary *mobileMe;

@end

@implementation MobileMe
@synthesize mobileMe = _mobileMe;

- (id)init:(NSDictionary*)mobileMe_ {
    if (self = [super init]) {
        [self setMobileMe:mobileMe_];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_mobileMe != nil) [_mobileMe release]; _mobileMe = nil;
    [super dealloc];
#endif
}

- (NSString*)get:(NSString*)domain withKey:(NSString*)key {
    if ([self.mobileMe.allKeys containsObject:domain]) {
        id obj = [self.mobileMe objectForKey:domain];
        if (obj && [obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *tmpDict = (NSDictionary*)obj;
            if ([tmpDict.allKeys containsObject:key]) {
                obj = [tmpDict objectForKey:key];
                if (obj && [obj isKindOfClass:[NSString class]]) {
                    return (NSString*)obj;
                }
            }
        }
    }
    return nil;
}

@end
