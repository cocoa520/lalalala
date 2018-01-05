//
//  Device.m
//
//
//  Created by JGehry on 8/2/16.
//
//  Complete

#import "Device.h"

@interface Device ()

@property (nonatomic, readwrite, retain) NSMutableArray *snapshots;

@end

@implementation Device
@synthesize snapshots = _snapshots;

+ (NSString *)DOMAIN_HMAC {
    static NSString *_domain_hmac = nil;
    @synchronized(self) {
        if (_domain_hmac == nil) {
            _domain_hmac = [@"domainHMAC" retain];
        }
    }
    return _domain_hmac;
}

+ (NSString *)KEYBAG_UUID {
    static NSString *_keybag_uuid = nil;
    @synchronized(self) {
        if (_keybag_uuid == nil) {
            _keybag_uuid = [@"currentKeybagUUID" retain];
        }
    }
    return _keybag_uuid;
}

- (id)initWithSnapshots:(NSArray *)snapshots record:(Record *)record {
    if (self = [super initWithRecord:record]) {
        NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:snapshots];
        [self setSnapshots:tmpArray];
#if !__has_feature(objc_arc)
        if (tmpArray != nil) [tmpArray release]; tmpArray = nil;
#endif
        return self;
    } else {
        return nil;
    }
}

- (id)copyWithZone:(NSZone*)zone {
    return [self retain];
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setSnapshots:nil];
    [super dealloc];
#endif
}

- (NSMutableArray*)getSnapshots {
    return [[[NSMutableArray alloc] initWithArray:[self snapshots]] autorelease];
}

- (NSMutableDictionary*)snapshotTimestampMap {
    NSMutableDictionary *returnDict = [[[NSMutableDictionary alloc] init] autorelease];
    for (SnapshotID *snapshotID in [self snapshots]) {
        [returnDict setValue:@([snapshotID timestamp]) forKey:[snapshotID iD]];
    }
    return returnDict;
}

- (NSString *)domainHMAC {
    return [[self recordFieldValue:[Device DOMAIN_HMAC]] stringValue];
}

- (NSString *)currentKeybagUUID {
    return [[self recordFieldValue:[Device KEYBAG_UUID]] stringValue];
}

- (NSString *)deviceClass {
    NSString *str = [[self recordFieldValue:@"deviceClass"] stringValue];
    if (str) {
        return str;
    }else {
        return @"";
    }
}

- (NSString *)hardwareModel {
    NSString *str = [[self recordFieldValue:@"hardwareModel"] stringValue];
    if (str) {
        return str;
    }else {
        return @"";
    }
}

- (NSString *)marketingName {
    NSString *str = [[self recordFieldValue:@"marketingName"] stringValue];
    if (str) {
        return str;
    }else {
        return @"";
    }
}

- (NSString *)productType {
    NSString *str = [[self recordFieldValue:@"productType"] stringValue];
    if (str) {
        return str;
    }else {
        return @"";
    }
}

- (NSString *)serialNumber {
    NSString *str = [[self recordFieldValue:@"serialNumber"] stringValue];
    if (str) {
        return str;
    }else {
        return @"";
    }
}

- (NSString *)uuid {
    NSArray *split = [[self name] componentsSeparatedByString:@":"];
    if ([split count] < 2) {
        return [self name];
    }
    return [(NSString *)[split objectAtIndex:1] uppercaseString];
}

- (NSString *)info {
    return [NSString stringWithFormat:@"%@ %@ %@", [self uuid], [self productType], [self hardwareModel]];
}

@end
