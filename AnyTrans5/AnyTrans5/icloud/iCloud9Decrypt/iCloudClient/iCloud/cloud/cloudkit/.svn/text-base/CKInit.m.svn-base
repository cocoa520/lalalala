//
//  CKInit.m
//  
//
//  Created by Pallas on 1/11/16.
//
//  Complete

#import "CKInit.h"
#import "CKContainer.h"

@interface CKInit ()

@property (nonatomic, readwrite, retain) NSString *cloudKitDeviceUrl;
@property (nonatomic, readwrite, retain) NSString *cloudKitDatabaseUrl;
@property (nonatomic, readwrite, retain) NSMutableArray *containers;
@property (nonatomic, readwrite, retain) NSString *cloudKitShareUrl;
@property (nonatomic, readwrite, retain) NSString *cloudKitUserId;

@end

@implementation CKInit
@synthesize cloudKitDeviceUrl = _cloudKitDeviceUrl;
@synthesize cloudKitDatabaseUrl = _cloudKitDatabaseUrl;
@synthesize containers = _containers;
@synthesize cloudKitShareUrl = _cloudKitShareUrl;
@synthesize cloudKitUserId = _cloudKitUserId;

- (id)init:(NSString*)cloudKitDeviceUrl withCloudKitDatabaseUrl:(NSString*)cloudKitDatabaseUrl withContainers:(NSArray*)containers withCloudKitShareUrl:(NSString*)cloudKitShareUrl withCloudKitUserId:(NSString*)cloudKitUserId {
    self = [super init];
    if (!self) {
        return nil;
    }
    [self setCloudKitDeviceUrl:cloudKitDeviceUrl];
    [self setCloudKitDatabaseUrl:cloudKitDatabaseUrl];
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    [self setContainers:tmpArray];
    if (containers != nil && containers.count > 0) {
        for (NSDictionary *valueDict in containers) {
            NSArray *allKeys = valueDict.allKeys;
            NSString *ckDeviceUrl = nil;
            NSString *env = nil;
            NSString *name = nil;
            NSString *url = nil;
            if ([allKeys containsObject:@"ckDeviceUrl"]) {
                ckDeviceUrl = (NSString*)[valueDict objectForKey:@"ckDeviceUrl"];
            } else {
                ckDeviceUrl = @"";
            }
            if ([allKeys containsObject:@"env"]) {
                env = (NSString*)[valueDict objectForKey:@"env"];
            } else {
                env = @"";
            }
            if ([allKeys containsObject:@"name"]) {
                name = (NSString*)[valueDict objectForKey:@"name"];
            } else {
                name = @"";
            }
            if ([allKeys containsObject:@"url"]) {
                url = (NSString*)[valueDict objectForKey:@"url"];
            } else {
                url = @"";
            }
            [self.containers addObject:[[[CKContainer alloc] initWithName:name withEnv:env withCkDeviceUrl:ckDeviceUrl withUrl:url] autorelease]];
        }
    }
#if !__has_feature(objc_arc)
    if (tmpArray) [tmpArray release]; tmpArray = nil;
#endif
    [self setCloudKitShareUrl:cloudKitShareUrl];
    [self setCloudKitUserId:cloudKitUserId];
    return self;
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_cloudKitDeviceUrl != nil) [_cloudKitDeviceUrl release]; _cloudKitDeviceUrl = nil;
    if (_cloudKitDatabaseUrl != nil) [_cloudKitDatabaseUrl release]; _cloudKitDatabaseUrl = nil;
    if (_containers != nil) [_containers release]; _containers = nil;
    if (_cloudKitShareUrl != nil) [_cloudKitShareUrl release]; _cloudKitShareUrl = nil;
    if (_cloudKitUserId != nil) [_cloudKitUserId release]; _cloudKitUserId = nil;
    [super dealloc];
#endif
}

- (CKContainer*)container:(NSString*)env {
    CKContainer *retVal = nil;
    @autoreleasepool {
        NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            if ([[((CKContainer*)evaluatedObject).env lowercaseString] isEqualToString:[env lowercaseString]]) {
                return YES;
            } else {
                return NO;
            }
        }];
        NSArray *tmpArray = [self.containers filteredArrayUsingPredicate:pre];
        if (tmpArray != nil && tmpArray.count > 0) {
            retVal = [tmpArray objectAtIndex:0];
        }
    }
    return retVal;
}

- (CKContainer*)production {
    return [self container:@"production"];
}

- (CKContainer*)sandbox {
    return [self container:@"sandbox"];
}

- (NSString*)cloudKitShareUrl {
    return _cloudKitShareUrl;
}

- (NSString*)cloudKitUserId {
    return _cloudKitUserId;
}

@end
