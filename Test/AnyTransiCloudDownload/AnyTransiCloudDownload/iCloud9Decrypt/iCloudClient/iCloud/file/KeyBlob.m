//
//  KeyBlob.m
//  
//
//  Created by Pallas on 8/29/16.
//
//  Complete

#import "KeyBlob.h"
#import "Arrays.h"
#import "CategoryExtend.h"

@interface KeyBlob ()

@property (nonatomic, readwrite, retain) NSMutableData *uuid;
@property (nonatomic, readwrite, retain) NSMutableData *publicKey;
@property (nonatomic, readwrite, retain) NSMutableData *wrappedKey;
@property (nonatomic, readwrite, assign) int protectionClass;
@property (nonatomic, readwrite, assign) int u1;
@property (nonatomic, readwrite, assign) int u2;
@property (nonatomic, readwrite, assign) int u3;

@end

@implementation KeyBlob
@synthesize uuid = _uuid;
@synthesize publicKey = _publicKey;
@synthesize wrappedKey = _wrappedKey;
@synthesize protectionClass = _protectionClass;
@synthesize u1 = _u1;
@synthesize u2 = _u2;
@synthesize u3 = _u3;

+ (NSMutableData*)uuid:(NSMutableData*)data {
    NSMutableData *retData = nil;
    if (data && data.length >= 0x10) {
        retData = [Arrays copyOfRangeWithByteArray:data withFrom:0 withTo:0x10];
    }
    return (retData ? [retData autorelease] : nil);
}

+ (KeyBlob*)create:(NSMutableData*)data {
    if (data.length < 36) {
        return nil;
    }
    
    DataStream *buffer = [DataStream wrapWithData:data];
    NSMutableData *uuid = [[NSMutableData alloc] initWithSize:0x10];
    [buffer getWithMutableData:uuid];
    int u1 = [buffer getInt];
    int u2 = [buffer getInt];
    int protectionClass = [buffer getInt];
    int u3 = [buffer getInt];
    int length = [buffer getInt];
    if (length != 0x48) {
        return nil;
    }

    /**
     *  changed by Gehry
     */
    if ([buffer remaining] < 0x48) {
        return nil;
    }
//    if ([buffer remaining] != 0x48) {
//        return nil;
//    }
    
    NSMutableData *publicKey = [[NSMutableData alloc] initWithSize:0x20];
    NSMutableData *wrappedKey = [[NSMutableData alloc] initWithSize:0x28];
    [buffer getWithMutableData:publicKey];
    [buffer getWithMutableData:wrappedKey];
    
    KeyBlob *blob = [[[KeyBlob alloc] initWithUuid:uuid withPublicKey:publicKey withWrappedKey:wrappedKey withProtectionClass:protectionClass withU1:u1 withU2:u2 withU3:u3] autorelease];
#if !__has_feature(objc_arc)
    if (uuid) [uuid release]; uuid = nil;
    if (publicKey) [publicKey release]; publicKey = nil;
    if (wrappedKey) [wrappedKey release]; wrappedKey = nil;
#endif
    return blob;
}

- (id)initWithUuid:(NSMutableData*)uuid withPublicKey:(NSMutableData*)publicKey withWrappedKey:(NSMutableData*)wrappedKey withProtectionClass:(int)protectionClass withU1:(int)u1 withU2:(int)u2 withU3:(int)u3 {
    if (self = [super init]) {
        NSMutableData *tmpData = [Arrays copyOfWithData:uuid withNewLength:(int)(uuid.length)];
        [self setUuid:tmpData];
#if !__has_feature(objc_arc)
        if (tmpData) [tmpData release]; tmpData = nil;
#endif
        tmpData = [Arrays copyOfWithData:publicKey withNewLength:(int)(publicKey.length)];
        [self setPublicKey:tmpData];
#if !__has_feature(objc_arc)
        if (tmpData) [tmpData release]; tmpData = nil;
#endif
        tmpData = [Arrays copyOfWithData:wrappedKey withNewLength:(int)(wrappedKey.length)];
        [self setWrappedKey:tmpData];
#if !__has_feature(objc_arc)
        if (tmpData) [tmpData release]; tmpData = nil;
#endif
        [self setProtectionClass:protectionClass];
        [self setU1:u1];
        [self setU2:u2];
        [self setU3:u3];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setUuid:nil];
    [self setPublicKey:nil];
    [self setWrappedKey:nil];
    [super dealloc];
#endif
}

- (NSMutableData*)getUuid {
    NSMutableData *retData = nil;
    if ([self uuid]) {
        retData = [Arrays copyOfWithData:[self uuid] withNewLength:(int)([self uuid].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (NSString*)uuidBase64 {
    return [Base64Codec base64StringFromData:[self uuid]];
}

- (NSMutableData*)getPublicKey {
    NSMutableData *retData = nil;
    if ([self publicKey]) {
        retData = [Arrays copyOfWithData:[self publicKey] withNewLength:(int)([self publicKey].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (NSMutableData*)getWrappedKey {
    NSMutableData *retData = nil;
    if ([self wrappedKey]) {
        retData = [Arrays copyOfWithData:[self wrappedKey] withNewLength:(int)([self wrappedKey].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (NSUInteger)hash {
    int hash = 3;
    hash = 97 * hash + [Arrays getHashCodeWithByteArray:[self uuid]];
    hash = 97 * hash + [Arrays getHashCodeWithByteArray:[self publicKey]];
    hash = 97 * hash + [Arrays getHashCodeWithByteArray:[self wrappedKey]];
    hash = 97 * hash + self.protectionClass;
    hash = 97 * hash + self.u1;
    hash = 97 * hash + self.u2;
    hash = 97 * hash + self.u3;
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
    KeyBlob *other = (KeyBlob*)object;
    if (self.protectionClass != other.protectionClass) {
        return NO;
    }
    if (self.u1 != other.u1) {
        return NO;
    }
    if (self.u2 != other.u2) {
        return NO;
    }
    if (self.u3 != other.u3) {
        return NO;
    }
    if (![Arrays areEqualWithByteArray:[self uuid] withB:[other uuid]]) {
        return NO;
    }
    if (![Arrays areEqualWithByteArray:[self publicKey] withB:[other publicKey]]) {
        return NO;
    }
    if (![Arrays areEqualWithByteArray:[self wrappedKey] withB:[other wrappedKey]]) {
        return NO;
    }
    return YES;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"FileKeyBlob{ uuid = 0x%@, publicKey = 0x%@, wrappedKey = 0x%@, protectionClass = %d, u1 = 0x%@, u2 = 0x%@, u3 = 0x%@", [NSString dataToHex:[self uuid]], [NSString dataToHex:[self publicKey]], [NSString dataToHex:[self wrappedKey]], self.protectionClass, [NSString intToHex:self.u1], [NSString intToHex:self.u2], [NSString intToHex:self.u3]];
}

@end
