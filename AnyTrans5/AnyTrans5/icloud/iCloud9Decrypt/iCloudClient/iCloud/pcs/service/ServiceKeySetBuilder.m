//
//  ServiceKeySetBuilder.m
//  
//
//  Created by Pallas on 4/26/16.
//
//  Complete

#import "ServiceKeySetBuilder.h"
#import "ECAssistant.h"
#import "ECurves.h"
#import "Key.h"
#import "KeyID.h"
#import "KeySet.h"
#import "KeyImports.h"
#import "Service.h"
#import "ServiceKeySet.h"
#import "SignatureInfo.h"
#import "ServiceKeySetAssistant.h"
#import "PrivateKey.h"
#import "TypeData.h"
#import "Hex.h"
#import "CategoryExtend.h"

@interface ServiceKeySetBuilder ()

@property (nonatomic, readwrite, retain) NSArray *fieldLengthToCurveName;
@property (nonatomic, readwrite, assign) BOOL useCompactKeys;
@property (nonatomic, readwrite, retain) NSMutableDictionary *serviceKeyIDs;
@property (nonatomic, readwrite, retain) NSMutableArray *keys;
@property (nonatomic, readwrite, retain) SignatureInfo *signature;
@property (nonatomic, readwrite, retain) NSString *ksID;
@property (nonatomic, readwrite, retain) NSString *name;
@property (nonatomic, readwrite, assign) int flags;

@end

@implementation ServiceKeySetBuilder
@synthesize fieldLengthToCurveName = _fieldLengthToCurveName;
@synthesize useCompactKeys = _useCompactKeys;
@synthesize serviceKeyIDs = _serviceKeyIDs;
@synthesize keys = _keys;
@synthesize signature = _signature;
@synthesize ksID = _ksID;
@synthesize name = _name;
@synthesize flags = _flags;

static BOOL ServiceKeySetBuilder_USE_COMPACT_KEYS = YES;

+ (NSArray*)SECPR1 {
    static NSArray *_secpr1 = nil;
    @synchronized(self) {
        if (_secpr1 == nil) {
            _secpr1 = [[ECurves secpr1] retain];
        }
    }
    return _secpr1;
}

+ (ServiceKeySetBuilder*)builder {
    return [[[ServiceKeySetBuilder alloc] init] autorelease];
}

+ (ServiceKeySet*)buildWithKeySet:(KeySet*)keySet {
    return [[[ServiceKeySetBuilder builder] putKeySet:keySet] build];
}

- (id)init {
    if (self = [super init]) {
        [self setFieldLengthToCurveName:[ServiceKeySetBuilder SECPR1]];
        [self setUseCompactKeys:ServiceKeySetBuilder_USE_COMPACT_KEYS];
        NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] init];
        [self setServiceKeyIDs:tmpDict];
#if !__has_feature(objc_arc)
        if (tmpDict != nil) [tmpDict release]; tmpDict = nil;
#endif
        NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
        [self setKeys:tmpArray];
#if !__has_feature(objc_arc)
        if (tmpArray != nil) [tmpArray release]; tmpArray = nil;
#endif
        [self setKsID:@""];
        [self setName:@""];
        [self setFlags:0];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_fieldLengthToCurveName != nil) [_fieldLengthToCurveName release]; _fieldLengthToCurveName = nil;
    if (_serviceKeyIDs != nil) [_serviceKeyIDs release]; _serviceKeyIDs = nil;
    if (_keys != nil) [_keys release]; _keys = nil;
    if (_signature != nil) [_signature release]; _signature = nil;
    if (_ksID != nil) [_ksID release]; _ksID = nil;
    if (_name != nil) [_name release]; _name = nil;
    [super dealloc];
#endif
}

- (ServiceKeySetBuilder*)putFieldLengthToCurveName:(NSArray*)fieldLengthToCurveName {
    [self setFieldLengthToCurveName:fieldLengthToCurveName];
    return self;
}

- (ServiceKeySetBuilder*)putUseCompactKeys:(BOOL)useCompactKeys {
    [self setUseCompactKeys:useCompactKeys];
    return self;
}

- (ServiceKeySetBuilder*)putName:(NSString*)name {
    [self setName:name];
    return self;
}

- (ServiceKeySetBuilder*)addPrivateKeys:(NSSet*)keys {
    NSEnumerator *iterator = keys.objectEnumerator;
    PrivateKey *value = nil;
    while (value = [iterator nextObject]) {
        [self addPrivateKey:value];
    }
    return self;
}

- (ServiceKeySetBuilder*)addPrivateKey:(PrivateKey*)key {
    [[self keys] addObject:key];
    return self;
}

- (ServiceKeySetBuilder*)addServiceKeys:(NSSet*)serviceKeys {
    NSEnumerator *iterator = serviceKeys.objectEnumerator;
    TypeData *value = nil;
    while (value = [iterator nextObject]) {
        [self addServiceKey:value];
    }
    return self;
}

- (ServiceKeySetBuilder*)addServiceKey:(TypeData*)serviceKey {
    [self addServiceKeyWithService:[serviceKey getType] withKeyID:[KeyID importKeyID:[serviceKey getData]]];
    return self;
}

- (ServiceKeySetBuilder*)addServiceKeyWithService:(int)service withKeyID:(KeyID*)keyID {
    [[self serviceKeyIDs] setObject:keyID forKey:[NSString stringWithFormat:@"%d", service]];
    return self;
}

- (ServiceKeySetBuilder*)putChecksum:(NSData*)checksum {
    [self putKsID:[NSString dataToHex:checksum]];
    return self;
}

- (ServiceKeySetBuilder*)putKsID:(NSString*)ksID {
    [self setKsID:ksID];
    return self;
}

- (ServiceKeySetBuilder*)putFlags:(int)flags {
    [self setFlags:flags];
    return self;
}

- (ServiceKeySetBuilder*)putSignature:(SignatureInfo*)signature {
    [self setSignature:signature];
    return self;
}

- (ServiceKeySetBuilder*)putKeySet:(KeySet*)keySet {
    [self setName:[keySet name]];
    [self addPrivateKeys:[keySet getKeys]];
    [self addServiceKeys:[keySet getServiceKeyIDs]];
    [self putChecksum:[keySet getChecksum]];
    int f = [keySet flags] != nil ? [[keySet flags] intValue] : 0;
    [self setFlags:f];
    [self putSignature:[keySet signatureInfo]];
    return self;
}

- (ServiceKeySet*)build {
    BOOL isCompact = (self.flags & 0x01) == 0x01;
    
    // Import keys.
    NSMutableDictionary *privateKeys = [ServiceKeySetAssistant importPrivateKeys:[self keys] withFieldLengthToCurveName:[self fieldLengthToCurveName] withUseCompactKeys:self.useCompactKeys];
    
    // If a single key with service 0/ null return basic Identity.
    if ([privateKeys count] == 1) {
        Key *key = [[privateKeys allValues] objectAtIndex:0];
        NSNumber *num = [key service];
        if (num == nil || [num intValue] == 0) {
            NSMutableDictionary *serviceKeys = [[NSMutableDictionary alloc] init];
            [serviceKeys setObject:key forKey:[NSString stringWithFormat:@"%d", 0]];
            ServiceKeySet *serviceKeySet = [[[ServiceKeySet alloc] initWithServiceKeys:serviceKeys withName:[self name] withKsID:[self ksID] withIsCompact:isCompact] autorelease];
#if !__has_feature(objc_arc)
            if (serviceKeys != nil) [serviceKeys release]; serviceKeys = nil;
#endif
            return serviceKeySet;
        }
    }
    
    Key *masterKeyOptional = [ServiceKeySetAssistant keyForService:[privateKeys allValues] withService:MASTER];
    if (masterKeyOptional == nil) {
        //NSLog(@"-- build() - master key not found: {}");
        return nil;
    }
    
    // Key verification.
    Key *masterKey = [masterKeyOptional selfVerify];
    [privateKeys addEntriesFromDictionary:[ServiceKeySetAssistant verifyKeys:[privateKeys allValues] withMasterKey:masterKey]];
    
    NSMutableArray *untrustedKeys = [ServiceKeySetAssistant untrustedKeys:[privateKeys allValues]];
    if (untrustedKeys != nil && untrustedKeys.count > 0) {
        //NSLog(@"-- build() - untrusted keys: %@", [untrustedKeys description]);
    }
  
    // Service to Key.
    NSMutableDictionary *serviceKeys = [ServiceKeySetAssistant serviceKeys:[self serviceKeyIDs] withPrivateKeys:privateKeys];
    
    // Test for but leave in unreferenced keys.
//    NSMutableArray *unreferencedKeys = [ServiceKeySetAssistant unreferencedKeys:[self serviceKeyIDs] withPrivateKeys:privateKeys];
    
    // Test for but leave in incongruent keys (for now).
//    NSMutableDictionary *incongruentKeys = [ServiceKeySetAssistant incongruentKeys:serviceKeys];
    
    // Debug information.
    //NSLog(@"-- build() - name: %@", [self name]);
    //NSLog(@"-- build() - ksID: %@", [self ksID]);
    //NSLog(@"-- build() - flags: %d", [self flags]);
    //NSLog(@"-- build() - key: %@", [[masterKey keyID] description]);
    //NSLog(@"-- build() - unreferenced keys: %@", [unreferencedKeys description]);
    //NSLog(@"-- build() - incongruent keys: %@", [incongruentKeys description]);
    
//    NSEnumerator *iterator = [[self serviceKeyIDs] keyEnumerator];
//    NSNumber *key = nil;
//    while (key = [iterator nextObject]) {
//        KeyID *value = [[self serviceKeyIDs] objectForKey:key];
//        //NSLog(@"-- build() - service: %@ key id: %@", key, [value description]);
//    }
    
//    iterator = [privateKeys keyEnumerator];
//    KeyID *key1 = nil;
//    while (key1 = [iterator nextObject]) {
//        Key *value = [privateKeys objectForKey:key1];
//        //NSLog(@"-- build() - key id: %@ trusted: %@ public export: 0x%@", [key1 description], ([value isTrusted] ? @"YES" : @"NO"), [Hex toHexString:[value exportPublicData]]);
//    }
    
    // Build.
    ServiceKeySet *serviceKeySet = [[[ServiceKeySet alloc] initWithServiceKeys:serviceKeys withName:[self name] withKsID:[self ksID] withIsCompact:isCompact] autorelease];
    return serviceKeySet;
}

@end
