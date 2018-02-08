//
//  KeyID.m
//  
//
//  Created by Pallas on 4/27/16.
//
//  Complete

#import "KeyID.h"
#import "Arrays.h"
#import "CategoryExtend.h"
#import "Digest.h"
#import "Sha256Digest.h"
#import "Hex.h"

@interface KeyID ()

@property (nonatomic, readwrite, retain) NSMutableData *kID;

@end

@implementation KeyID
@synthesize kID = _kID;

+ (KeyID*)importKeyID:(NSMutableData*)data {
    NSMutableData *mutData = [Arrays copyOfWithData:data withNewLength:(int)(data.length)];
    KeyID *key = [[KeyID alloc] initWithID:mutData];
#if !__has_feature(objc_arc)
    if (mutData) [mutData release]; mutData = nil;
#endif
    return (key ? [key autorelease] : nil);
}

+ (KeyID*)of:(NSMutableData*)publicExportData {
    NSMutableData *iD = [KeyID iD:publicExportData];
    return [[[KeyID alloc] initWithID:iD] autorelease];
}

+ (NSMutableData*)iD:(NSMutableData*)data {
    // SHA256 truncated to 20 bytes.
    Digest *digest = [[Sha256Digest alloc] init];
    NSMutableData *outBytes = [[NSMutableData alloc] initWithSize:[digest getDigestSize]];
    
    [digest blockUpdate:data withInOff:0 withLength:(int)(data.length)];
    [digest doFinal:outBytes withOutOff:0];
    
    NSMutableData *retData = nil;
    if (outBytes) {
        retData = [Arrays copyOfWithData:outBytes withNewLength:20];
    }
#if !__has_feature(objc_arc)
    if (digest != nil) [digest release]; digest = nil;
    if (outBytes != nil) [outBytes release]; outBytes = nil;
#endif
    return (retData ? [retData autorelease] : nil);
}

- (id)initWithID:(NSMutableData*)kid {
    if (self = [super init]) {
        [self setKID:kid];
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
    [self setKID:nil];
    [super dealloc];
#endif
}

- (NSMutableData*)bytes {
    NSMutableData *retData = nil;
    if ([self kID]) {
        retData = [Arrays copyOfWithData:[self kID] withNewLength:(int)([self kID].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (NSUInteger)hash {
    int hash = 3;
    hash = 23 * hash + [Arrays getHashCodeWithByteArray:[self kID]];
    return hash;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (object == nil) {
        return NO;
    }
    
    if ([self class] != [object class]) {
        return NO;
    }
    
    KeyID *other = (KeyID*)object;
    return [Arrays areEqualWithByteArray:[self kID] withB:[other kID]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"KeyID{ 0x%@ }", [NSString dataToHex:[self kID]]];
}

@end
