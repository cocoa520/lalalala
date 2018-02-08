//
//  AccountInfo.m
//  
//
//  Created by Pallas on 1/7/16.
//
//  Complete

#import "AccountInfo.h"

@interface AccountInfo ()

@property (nonatomic, readwrite, retain) NSString *appleId;
@property (nonatomic, readwrite, retain) NSString *aDsID;
@property (nonatomic, readwrite, retain) NSString *dsPrsID;
@property (nonatomic, readwrite, retain) NSString *lastName;
@property (nonatomic, readwrite, retain) NSString *firstName;

@end

@implementation AccountInfo
@synthesize appleId = _appleId;
@synthesize aDsID = _aDsID;
@synthesize dsPrsID = _dsPrsID;
@synthesize lastName = _lastName;
@synthesize firstName = _firstName;

- (id)init:(NSString*)appleId withADsID:(NSString*)aDsID withDsPrsID:(NSString*)dsPrsID withLastName:(NSString*)lastName withFirstName:(NSString*)firstName {
    self = [super init];
    if (!self) {
        return nil;
    }
    [self setAppleId:appleId];
    [self setADsID:aDsID];
    [self setDsPrsID:dsPrsID];
    [self setLastName:lastName];
    [self setFirstName:firstName];
    return self;
}

- (id)init:(NSDictionary*)accountInfo {
    self = [super init];
    if (!self) {
        return nil;
    }
    NSArray *allKeys = accountInfo.allKeys;
    if (allKeys != nil) {
        if ([allKeys containsObject:@"appleId"]) {
            [self setAppleId:(NSString*)[accountInfo objectForKey:@"appleId"]];
        } else {
            [self setAppleId:@""];
        }
        if ([allKeys containsObject:@"aDsID"]) {
            [self setADsID:(NSString*)[accountInfo objectForKey:@"aDsID"]];
        } else {
            [self setADsID:@""];
        }
        if ([allKeys containsObject:@"dsPrsID"]) {
            [self setDsPrsID:(NSString*)[accountInfo objectForKey:@"dsPrsID"]];
        } else {
            [self setDsPrsID:@""];
        }
        if ([allKeys containsObject:@"lastName"]) {
            [self setLastName:(NSString*)[accountInfo objectForKey:@"lastName"]];
        } else {
            [self setLastName:@""];
        }
        if ([allKeys containsObject:@"firstName"]) {
            [self setFirstName:(NSString*)[accountInfo objectForKey:@"firstName"]];
        } else {
            [self setFirstName:@""];
        }
    } else {
        [self setAppleId:@""];
        [self setADsID:@""];
        [self setDsPrsID:@""];
        [self setLastName:@""];
        [self setFirstName:@""];
    }
    return self;
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_appleId != nil) [_appleId release]; _appleId = nil;
    if (_aDsID != nil) [_aDsID release]; _aDsID = nil;
    if (_dsPrsID != nil) [_dsPrsID release]; _dsPrsID = nil;
    if (_lastName != nil) [_lastName release]; _lastName = nil;
    if (_firstName != nil) [_firstName release]; _firstName = nil;
    [super dealloc];
#endif
}

@end
