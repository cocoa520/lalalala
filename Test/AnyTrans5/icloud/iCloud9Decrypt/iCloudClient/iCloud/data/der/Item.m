//
//  Item.m
//  
//
//  Created by Pallas on 7/30/16.
//
//  Complete

#import "Item.h"
#import "Arrays.h"
#import "ASN1Primitive.h"
#import "ASN1Integer.h"
#import "ASN1EncodableVector.h"
#import "BigInteger.h"
#import "DER.h"
#import "DERIterator.h"
#import "DEROctetString.h"
#import "DERSequence.h"

@interface Item ()

@property (nonatomic, readwrite, assign) int version;
@property (nonatomic, readwrite, retain) NSMutableData *data;

@end

@implementation Item
@synthesize version = _version;
@synthesize data = _data;

- (id)initWithVersion:(int)version withData:(NSMutableData*)data {
    if (self = [super init]) {
        [self setVersion:version];
        NSMutableData *tmpData = [Arrays copyOfWithData:data withNewLength:(int)(data.length)];
        [self setData:tmpData];
#if !__has_feature(objc_arc)
        if (tmpData) [tmpData release]; tmpData = nil;
#endif
        return self;
    } else {
        return nil;
    }
}

- (id)initWithASN1Primitive:(ASN1Primitive*)primitive {
    if (self = [super init]) {
        DERIterator *i = [DER asSequence:primitive];
        
        [self setVersion:[[(ASN1Integer*)[DER as:[ASN1Integer class] withEncodable:i] getValue] intValue]];
        
        [self setData:[(DEROctetString*)[DER as:[DEROctetString class] withEncodable:i] getOctets]];
        return self;
    } else {
        return nil;
    }
}

- (int)getVersion {
    return self.version;
}

- (NSMutableData*)getOctets {
    NSMutableData *retData = nil;
    if ([self data]) {
        retData = [Arrays copyOfWithData:[self data] withNewLength:(int)([self data].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (ASN1Primitive*)toASN1Primitive {
    ASN1Integer *versionASN1Integer = [[ASN1Integer alloc] initLong:self.version];
    DEROctetString *octetsDerOctet = [[DEROctetString alloc] initDEROctetString:[self getOctets]];
    ASN1EncodableVector *vector =[DER vector:versionASN1Integer, octetsDerOctet, nil];
    DERSequence *retVal = [[[DERSequence alloc] initDERParamASN1EncodableVector:vector] autorelease];
#if !__has_feature(objc_arc)
    if (versionASN1Integer != nil) [versionASN1Integer release]; versionASN1Integer = nil;
    if (octetsDerOctet != nil) [octetsDerOctet release]; octetsDerOctet = nil;
#endif
    return retVal;
}

@end
