//
//  ServiceKeySet.m
//  
//
//  Created by Pallas on 4/26/16.
//
//  Complete

#import "ServiceKeySet.h"
#import "CategoryExtend.h"
#import "Key.h"
#import "KeyID.h"

@interface ServiceKeySet ()

@property (nonatomic, readwrite, retain) NSMutableDictionary *serviceKeys;
@property (nonatomic, readwrite, retain) NSString *name;
@property (nonatomic, readwrite, retain) NSString *ksID;
@property (nonatomic, readwrite, assign) BOOL isCompact;

@end

@implementation ServiceKeySet
@synthesize serviceKeys = _serviceKeys;
@synthesize name = _name;
@synthesize ksID = _ksID;
@synthesize isCompact = _isCompact;

- (id)initWithServiceKeys:(NSDictionary*)serviceKeys withName:(NSString*)name withKsID:(NSString*)ksID withIsCompact:(BOOL)isCompact {
    if (self = [super init]) {
        [self setServiceKeys:[NSMutableDictionary dictionaryWithDictionary:serviceKeys]];
        [self setName:name];
        [self setKsID:ksID];
        [self setIsCompact:isCompact];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_serviceKeys != nil) [_serviceKeys release]; _serviceKeys = nil;
    if (_name != nil) [_name release]; _name = nil;
    if (_ksID != nil) [_ksID release]; _ksID = nil;
    [super dealloc];
#endif
}

- (Key*)keyWithServiceEnum:(ServiceEnum)service {
    int servInt = (int)service;
    return [self keyWithService:servInt];
}

- (Key*)keyWithService:(int)service {
    NSString *serviceStr = [NSString stringWithFormat:@"%d", service];
    if ([[self serviceKeys].allKeys containsObject:serviceStr]) {
        return [[self serviceKeys] objectForKey:serviceStr];
    }
    return nil;
}

- (Key*)keyWithKeyID:(KeyID*)keyID {
    Key *retKey = nil;
    NSArray *allValues = [[self serviceKeys] allValues];
    if (allValues != nil && allValues.count > 0) {
        for (Key *value in allValues) {
            if ([[value keyID] isEqual:keyID]) {
                retKey = value;
                break;
            }
        }
    }
    return retKey;
}

- (NSMutableDictionary*)services {
    return [[self serviceKeys] mutableDeepCopy];
}

- (NSArray*)keys {
    return [[self serviceKeys] allValues];
}

@end
