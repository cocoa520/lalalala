//
//  PrivateKey.m
//  
//
//  Created by Pallas on 7/30/16.
//
//  Complete

#import "PrivateKey.h"
#import "Arrays.h"
#import "ASN1Primitive.h"
#import "DER.h"
#import "DERIterator.h"
#import "DEROctetString.h"
#import "DERSequence.h"
#import "PublicKeyInfo.h"

@interface PrivateKey ()

@property (nonatomic, readwrite, retain) NSMutableData *privateKey;
@property (nonatomic, readwrite, retain) PublicKeyInfo *publicKeyInfo;

@end

@implementation PrivateKey
@synthesize privateKey = _privateKey;
@synthesize publicKeyInfo = _publicKeyInfo;

- (id)initWithPrivateKey:(NSMutableData*)privateKey withPublicKeyInfo:(PublicKeyInfo*)publicKeyInfo {
    if (self = [super init]) {
        NSMutableData *tmpData = [Arrays copyOfWithData:privateKey withNewLength:(int)(privateKey.length)];
        [self setPrivateKey:tmpData];
#if !__has_feature(objc_arc)
        if (tmpData) [tmpData release]; tmpData = nil;
#endif
        [self setPublicKeyInfo:publicKeyInfo];
        return self;
    } else {
        return nil;
    }
}

- (id)initWithASN1Primitive:(ASN1Primitive*)primitive {
    if (self = [super init]) {
        DERIterator *i = [DER asSequence:primitive];
        [self setPrivateKey:[(DEROctetString*)[DER as:[DEROctetString class] withEncodable:i] getOctets]];
        
        ASN1Primitive *asn1Obj = [i next];
        if (asn1Obj != nil) {
            PublicKeyInfo *pubKeyInfo = [[PublicKeyInfo alloc] initWithASN1Primitive:asn1Obj];
            [self setPublicKeyInfo:pubKeyInfo];
#if !__has_feature(objc_arc)
            if (pubKeyInfo != nil) [pubKeyInfo release]; pubKeyInfo = nil;
#endif
        } else {
            [self setPublicKeyInfo:nil];
        }
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_privateKey != nil) [_privateKey release]; _privateKey = nil;
    if (_publicKeyInfo != nil) [_publicKeyInfo release]; _publicKeyInfo = nil;
    [super dealloc];
#endif
}

- (NSMutableData*)getPrivateKey {
    NSMutableData *retData = nil;
    if ([self privateKey]) {
        retData = [Arrays copyOfWithData:[self privateKey] withNewLength:(int)([self privateKey].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (ASN1Primitive*)toASN1Primitive {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    DEROctetString *derOctet = [[DEROctetString alloc] initDEROctetString:[self getPrivateKey]];
    if (derOctet != nil) {
        [array addObject:derOctet];
    }
    if ([self publicKeyInfo] != nil) {
        [array addObject:[self publicKeyInfo]];
    }
    ASN1EncodableVector *vector = [DER vectorWithArray:array];
    DERSequence *retVal = [[[DERSequence alloc] initDERParamASN1EncodableVector:vector] autorelease];
#if !__has_feature(objc_arc)
    if (array != nil) [array release]; array = nil;
    if (derOctet != nil) [derOctet release]; derOctet = nil;
#endif
    return retVal;
}

@end
