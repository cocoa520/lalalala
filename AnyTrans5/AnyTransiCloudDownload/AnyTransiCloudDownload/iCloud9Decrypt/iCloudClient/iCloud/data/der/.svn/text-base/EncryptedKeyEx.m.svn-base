//
//  EncryptedKey.m
//  
//
//  Created by Pallas on 7/30/16.
//
//  Complete

#import "EncryptedKeyEx.h"
#import "Arrays.h"
#import "ASN1Primitive.h"
#import "ASN1Integer.h"
#import "ASN1EncodableVector.h"
#import "BigInteger.h"
#import "DER.h"
#import "DERIterator.h"
#import "DEROctetString.h"
#import "DERSequence.h"
#import "NOS.h"

@interface EncryptedKeyEx ()

@property (nonatomic, readwrite, retain) NOS *masterKey;
@property (nonatomic, readwrite, retain) NSMutableData *wrappedKey;
@property (nonatomic, readwrite, retain) NSNumber *flags;

@end

@implementation EncryptedKeyEx
@synthesize masterKey = _masterKey;
@synthesize wrappedKey = _wrappedKey;
@synthesize flags = _flags;

- (id)initWithMasterKey:(NOS*)masterKey withWrappedKey:(NSMutableData*)wrappedKey withFlags:(NSNumber*)flags {
    if (self = [super init]) {
        [self setMasterKey:masterKey];
        [self setWrappedKey:wrappedKey];
        [self setFlags:flags];
        return self;
    } else {
        return nil;
    }
}

- (id)initWithASN1Primitive:(ASN1Primitive*)primitive {
    if (self = [super init]) {
        DERIterator *i = [DER asSequence:primitive];
        
        NOS *nos = [[NOS alloc] initWithASN1Primitive:[i next]];
        [self setMasterKey:nos];
        
        [self setWrappedKey:[(DEROctetString*)[DER as:[DEROctetString class] withEncodable:i] getOctets]];
        ASN1Primitive *primitive = [i next];
        if (primitive) {
            [self setFlags:@([[(ASN1Integer*)[DER as:[ASN1Integer class] withEncodable:primitive] getValue] intValue])];
        }
#if !__has_feature(objc_arc)
        if (nos != nil) [nos release]; nos = nil;
#endif
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_masterKey != nil) [_masterKey release]; _masterKey = nil;
    if (_wrappedKey != nil) [_wrappedKey release]; _wrappedKey = nil;
    if (_flags != nil) [_flags release]; _flags = nil;
    [super dealloc];
#endif
}

- (NSNumber*)getFlags {
    return [self flags];
}

- (NOS*)getMasterKey {
    return [self masterKey];
}

- (NSMutableData*)getWrappedKey {
    NSMutableData *retData = nil;
    if ([self wrappedKey]) {
        retData = [Arrays copyOfWithData:[self wrappedKey] withNewLength:(int)([self wrappedKey].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (ASN1Primitive*)toASN1Primitive {
    ASN1Integer *asn1IntegerFlags = nil;
    if ([self flags] != nil) {
        asn1IntegerFlags = [[ASN1Integer alloc] initLong:[[self getFlags] intValue]];
    }
    DEROctetString *wrappedKeyString = [[DEROctetString alloc] initDEROctetString:[self getWrappedKey]];
    
    ASN1EncodableVector *vector = nil;
    if (asn1IntegerFlags != nil) {
        vector = [DER vector:[self getMasterKey], wrappedKeyString, asn1IntegerFlags, nil];
    } else {
        vector = [DER vector:[self getMasterKey], asn1IntegerFlags, nil];
    }
    DERSequence *retVal = [[[DERSequence alloc] initDERParamASN1EncodableVector:vector] autorelease];
#if !__has_feature(objc_arc)
    if (asn1IntegerFlags != nil) [asn1IntegerFlags release]; asn1IntegerFlags = nil;
    if (wrappedKeyString != nil) [wrappedKeyString release]; wrappedKeyString = nil;
#endif
    return retVal;
}

@end
