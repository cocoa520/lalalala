//
//  NOS.m
//  
//
//  Created by Pallas on 7/30/16.
//
//  Complete

#import "NOS.h"
#import "Arrays.h"
#import "ASN1Primitive.h"
#import "ASN1Integer.h"
#import "BigInteger.h"
#import "DERIterator.h"
#import "DER.h"
#import "DEROctetString.h"
#import "DERSequence.h"

@interface NOS ()

@property (nonatomic, readwrite, assign) int x;
@property (nonatomic, readwrite, retain) NSNumber *y;
@property (nonatomic, readwrite, retain) NSMutableData *key;

@end

@implementation NOS
@synthesize x = _x;
@synthesize y = _y;
@synthesize key = _key;

- (id)initWithX:(int)x withY:(NSNumber*)y withKey:(NSMutableData*)key {
    if (self = [super init]) {
        [self setX:x];
        [self setY:y];
        NSMutableData *tmpData = [Arrays copyOfWithData:key withNewLength:(int)(key.length)];
        [self setKey:tmpData];
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
        
        [self setX:[[(ASN1Integer*)[DER as:[ASN1Integer class] withEncodable:i] getValue] intValue]];
        
        id obj = [i nextIf:[ASN1Integer class]];
        if (obj != nil) {
            [self setY:@([[(ASN1Integer*)obj getValue] intValue])];
        } else {
            [self setY:nil];
        }
        
        [self setKey:[(DEROctetString*)[DER as:[DEROctetString class] withEncodable:i] getOctets]];
        
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_y != nil) [_y release]; _y = nil;
    if (_key != nil) [_key release]; _key = nil;
    [super dealloc];
#endif
}

- (int)getX {
    return self.x;
}

- (NSNumber*)getY {
    return self.y;
}

- (NSMutableData*)getKey {
    NSMutableData *retData = nil;
    if ([self key]) {
        retData = [Arrays copyOfWithData:[self key] withNewLength:(int)([self key].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (ASN1Primitive*)toASN1Primitive {
    ASN1Integer *xASN1Integer = [[ASN1Integer alloc] initLong:self.x];
    ASN1Integer *yASN1Integer = nil;
    if ([self y] != nil) {
        yASN1Integer = [[ASN1Integer alloc] initLong:[[self y] intValue]];
    }
    DEROctetString *keyString = [[DEROctetString alloc] initDEROctetString:[self getKey]];
    ASN1EncodableVector *vector = nil;
    if (yASN1Integer != nil) {
        vector = [DER vector:xASN1Integer, yASN1Integer, keyString, nil];
    } else {
        vector = [DER vector:xASN1Integer, keyString, nil];
    }
    
    DERSequence *retVal = [[[DERSequence alloc] initDERParamASN1EncodableVector:vector] autorelease];
#if !__has_feature(objc_arc)
    if (xASN1Integer != nil) [xASN1Integer release]; xASN1Integer = nil;
    if (yASN1Integer != nil) [yASN1Integer release]; yASN1Integer = nil;
    if (keyString != nil) [keyString release]; keyString = nil;
#endif
    return retVal;
}

@end
