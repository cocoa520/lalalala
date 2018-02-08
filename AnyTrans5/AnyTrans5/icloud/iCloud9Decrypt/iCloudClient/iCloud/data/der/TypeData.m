//
//  TypeData.m
//  
//
//  Created by Pallas on 7/29/16.
//
//  Complete

#import "TypeData.h"
#import "Arrays.h"
#import "ASN1Primitive.h"
#import "ASN1Integer.h"
#import "BigInteger.h"
#import "DER.h"
#import "DERIterator.h"
#import "DEROctetString.h"
#import "DERSequence.h"

@interface TypeData ()

@property (nonatomic, readwrite, assign) int type;
@property (nonatomic, readwrite, retain) NSMutableData *data;

@end

@implementation TypeData
@synthesize type = _type;
@synthesize data = _data;

- (id)initWithType:(int)type withData:(NSMutableData*)data {
    if (self = [super init]) {
        [self setType:type];
        [self setData:data];
        return self;
    } else {
        return nil;
    }
}

- (id)initWithASN1Primitive:(ASN1Primitive*)primitive {
    if (self = [super init]) {
        DERIterator *i = [DER asSequence:primitive];
        
        [self setType:[[(ASN1Integer*)[DER as:[ASN1Integer class] withEncodable:i] getValue] intValue]];
        [self setData:[(DEROctetString*)[DER as:[DEROctetString class] withEncodable:i] getOctets]];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_data != nil) [_data release]; _data = nil;
    [super dealloc];
#endif
}

- (int)getType {
    return self.type;
}

- (NSMutableData*)getData {
    NSMutableData *retData = nil;
    if ([self data]) {
        retData = [Arrays copyOfWithData:[self data] withNewLength:(int)([self data].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (ASN1Primitive*)toASN1Primitive {
    ASN1Integer *typeInteger = [[ASN1Integer alloc] initLong:self.type];
    DEROctetString *dataString = [[DEROctetString alloc] initDEROctetString:[self data]];
    ASN1EncodableVector *vector = [DER vector:typeInteger, dataString, nil];
    DERSequence *retVal = [[[DERSequence alloc] initDERParamASN1EncodableVector:vector] autorelease];
#if !__has_feature(objc_arc)
    if (typeInteger != nil) [typeInteger release]; typeInteger = nil;
    if (dataString != nil) [dataString release]; dataString = nil;
#endif
    return retVal;
}

@end
