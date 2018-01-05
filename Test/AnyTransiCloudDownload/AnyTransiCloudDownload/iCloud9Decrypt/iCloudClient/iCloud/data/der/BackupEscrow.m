//
//  BackupEscrow.m
//  
//
//  Created by Pallas on 7/28/16.
//
//  Complete

#import "BackupEscrow.h"
#import "Arrays.h"
#import "ASN1EncodableVector.h"
#import "ASN1Primitive.h"
#import "ASN1Integer.h"
#import "BigInteger.h"
#import "DER.h"
#import "DEROctetString.h"
#import "DERIterator.h"
#import "DERSequence.h"
#import "DERApplicationSpecific.h"

@interface BackupEscrow ()

@property (nonatomic, readwrite, retain) NSMutableData *wrappedKey;
@property (nonatomic, readwrite, retain) NSMutableData *data;
@property (nonatomic, readwrite, retain) NSMutableData *x;
@property (nonatomic, readwrite, assign) int y;
@property (nonatomic, readwrite, retain) NSMutableData *masterKeyPublic;

@end

@implementation BackupEscrow
@synthesize wrappedKey = _wrappedKey;
@synthesize data = _data;
@synthesize x = _x;
@synthesize y = _y;
@synthesize masterKeyPublic = _masterKeyPublic;


- (id)initWithWrappedKey:(NSMutableData*)wrappedKey withData:(NSMutableData*)data withX:(NSMutableData*)x withY:(int)y withMasterKeyPublic:(NSMutableData*)masterKeyPublic {
    if (self = [super init]) {
        NSMutableData *tmpData = [Arrays copyOfWithData:wrappedKey withNewLength:(int)(wrappedKey.length)];
        [self setWrappedKey:tmpData];
#if !__has_feature(objc_arc)
        if (tmpData) [tmpData release]; tmpData = nil;
#endif
        tmpData = [Arrays copyOfWithData:data withNewLength:(int)(data.length)];
        [self setData:tmpData];
#if !__has_feature(objc_arc)
        if (tmpData) [tmpData release]; tmpData = nil;
#endif
        tmpData = [Arrays copyOfWithData:x withNewLength:(int)(x.length)];
        [self setX:tmpData];
#if !__has_feature(objc_arc)
        if (tmpData) [tmpData release]; tmpData = nil;
#endif
        [self setY:y];
        tmpData = [Arrays copyOfWithData:masterKeyPublic withNewLength:(int)(masterKeyPublic.length)];
        [self setMasterKeyPublic:tmpData];
#if !__has_feature(objc_arc)
        if (tmpData) [tmpData release]; tmpData = nil;
#endif
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_wrappedKey != nil) [_wrappedKey release]; _wrappedKey = nil;
    if (_data != nil) [_data release]; _data = nil;
    if (_x != nil) [_x release]; _x = nil;
    if (_masterKeyPublic != nil) [_masterKeyPublic release]; _masterKeyPublic = nil;
    [super dealloc];
#endif
}

- (id)initWithASN1Primitive:(ASN1Primitive*)primitive {
    if (self = [super init]) {
        ASN1Primitive *app = [DER asApplicationSpecific:BackupEscrow_APPLICATION_TAG withEncodable:primitive];
        DERIterator *i = [DER asSequence:app];
        
        [self setWrappedKey:[(DEROctetString*)[DER as:[DEROctetString class] withEncodable:i] getOctets]];
        
        [self setData:[(DEROctetString*)[DER as:[DEROctetString class] withEncodable:i] getOctets]];
        
        [self setX:[(DEROctetString*)[DER as:[DEROctetString class] withEncodable:i] getOctets]];
        
        [self setY:[[(ASN1Integer*)[DER as:[ASN1Integer class] withEncodable:i] getValue] intValue]];
        
        [self setMasterKeyPublic:[(DEROctetString*)[DER as:[DEROctetString class] withEncodable:i] getOctets]];
        return self;
    } else {
        return nil;
    }
}

- (NSMutableData*)getWrappedKey {
    NSMutableData *retData = nil;
    if ([self wrappedKey]) {
        retData = [Arrays copyOfWithData:[self wrappedKey] withNewLength:(int)([self wrappedKey].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (NSMutableData*)getData {
    NSMutableData *retData = nil;
    if ([self data]) {
        retData = [Arrays copyOfWithData:[self data] withNewLength:(int)([self data].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (NSMutableData*)getX {
    NSMutableData *retData = nil;
    if ([self x]) {
        retData = [Arrays copyOfWithData:[self x] withNewLength:(int)([self x].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (int)y {
    return _y;
}

- (NSMutableData*)getMasterKeyPublic {
    NSMutableData *retData = nil;
    if ([self masterKeyPublic]) {
        retData = [Arrays copyOfWithData:[self masterKeyPublic] withNewLength:(int)([self masterKeyPublic].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (ASN1Primitive*)toASN1Primitive {
    DEROctetString *wkString = [[DEROctetString alloc] initDEROctetString:[self wrappedKey]];
    DEROctetString *dataString = [[DEROctetString alloc] initDEROctetString:[self data]];
    DEROctetString *xString = [[DEROctetString alloc] initDEROctetString:[self x]];
    ASN1Integer *yInteger = [[ASN1Integer alloc] initLong:self.y];
    DEROctetString *mkpString = [[DEROctetString alloc] initDEROctetString:[self masterKeyPublic]];
    ASN1EncodableVector *vector = [DER vector:wkString, dataString, xString, yInteger, mkpString, nil];
    DERSequence *sequence = [[DERSequence alloc] initDERParamASN1EncodableVector:vector];
    DERApplicationSpecific *retVal = [DER toApplicationSpecific:BackupEscrow_APPLICATION_TAG withEncodable:sequence];
#if !__has_feature(objc_arc)
    if (wkString != nil) [wkString release]; wkString = nil;
    if (dataString != nil) [dataString release]; dataString = nil;
    if (xString != nil) [xString release]; xString = nil;
    if (yInteger != nil) [yInteger release]; yInteger = nil;
    if (mkpString != nil) [mkpString release]; mkpString = nil;
    if (sequence != nil) [sequence release]; sequence = nil;
#endif
    return retVal;
}

@end
