//
//  EncryptedKeys.m
//  
//
//  Created by Pallas on 7/30/16.
//
//  Complete

#import "EncryptedKeys.h"
#import "Arrays.h"
#import "ASN1Primitive.h"
#import "ASN1Integer.h"
#import "ASN1EncodableVector.h"
#import "BigInteger.h"
#import "DER.h"
#import "DERSet.h"
#import "DERIterator.h"
#import "DEROctetString.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"
#import "EncryptedKeyEx.h"
#import <objc/runtime.h>

@interface EncryptedKeys ()

@property (nonatomic, readwrite, assign) int x;
@property (nonatomic, readwrite, retain) NSMutableSet *encryptedKeySet;
@property (nonatomic, readwrite, retain) NSMutableData *cont0;

@end

@implementation EncryptedKeys
@synthesize x = _x;
@synthesize encryptedKeySet = _encryptedKeySet;
@synthesize cont0 = _cont0;

static int CONT0 = 0;

- (id)initWithX:(int)x withEncryptedKeySet:(NSSet*)encryptedKeySet withCont0:(NSMutableData*)cont0 {
    if (self = [super init]) {
        [self setX:x];
        [self setEncryptedKeySet:[NSMutableSet setWithSet:encryptedKeySet]];
        if (cont0 != nil) {
            NSMutableData *tmpData = [Arrays copyOfWithData:cont0 withNewLength:(int)(cont0.length)];
            [self setCont0:tmpData];
#if !__has_feature(objc_arc)
        if (tmpData) [tmpData release]; tmpData = nil;
#endif
        } else {
            [self setCont0:nil];
        }
        return self;
    } else {
        return nil;
    }
}

- (id)initWithASN1Primitive:(ASN1Primitive*)primitive {
    if (self = [super init]) {
        DERIterator *i = [DER asSequence:primitive];
        
        NSMutableDictionary *tagged = [i getDerTaggedObjects];
        [self setX:[[(ASN1Integer*)[DER as:[ASN1Integer class] withEncodable:i] getValue] intValue]];
        
        SEL selector = @selector(initWithASN1Primitive:);
        Class classType = [EncryptedKeyEx class];
        IMP imp = class_getMethodImplementation(classType, selector);
        [self setEncryptedKeySet:[DER asSet:i withClassType:classType withSel:selector withFunction:imp]];
        NSString *contoStr = [NSString stringWithFormat:@"%d", CONT0];
        if ([tagged.allKeys containsObject:contoStr]) {
            ASN1Primitive *asn1Obj = (ASN1Primitive*)[tagged objectForKey:contoStr];
            if (asn1Obj != nil) {
                [self setCont0:[(DEROctetString*)[DER as:[DEROctetString class] withEncodable:asn1Obj] getOctets]];
            } else {
                [self setCont0:nil];
            }
        } else {
            [self setCont0:nil];
        }
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_encryptedKeySet != nil) [_encryptedKeySet release]; _encryptedKeySet = nil;
    if (_cont0 != nil) [_cont0 release]; _cont0 = nil;
    [super dealloc];
#endif
}

- (int)getX {
    return self.x;
}

- (NSMutableSet*)getEncryptedKeySet {
    return [[[NSMutableSet alloc] initWithSet:[self encryptedKeySet]] autorelease];
}

- (NSMutableData*)getCont0 {
    NSMutableData *retData = nil;
    if ([self cont0] != nil) {
        retData = [Arrays copyOfWithData:[self cont0] withNewLength:(int)([self cont0].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (ASN1Primitive*)toASN1Primitive {
    DERTaggedObject *cont0Encodable = nil;
    NSMutableData *tmpCont0 = [self getCont0];
    if (tmpCont0 != nil) {
        DEROctetString *derOctet = [[DEROctetString alloc] initDEROctetString:tmpCont0];
        cont0Encodable = [[DERTaggedObject alloc] initParamInt:CONT0 paramASN1Encodable:derOctet];
#if !__has_feature(objc_arc)
        if (derOctet != nil) [derOctet release]; derOctet = nil;
#endif
    }
    ASN1Integer *xASN1Integer = [[ASN1Integer alloc] initLong:[self getX]];
    DERSet *derSet = [DER toSet:[self encryptedKeySet]];
    
    ASN1EncodableVector *vector = nil;
    if (cont0Encodable != nil) {
        vector = [DER vector:xASN1Integer, derSet, cont0Encodable, nil];
    } else {
        vector = [DER vector:xASN1Integer, derSet, nil];
    }
    DERSequence *retVal = [[[DERSequence alloc] initDERParamASN1EncodableVector:vector] autorelease];
#if !__has_feature(objc_arc)
    if (cont0Encodable != nil) [cont0Encodable release]; cont0Encodable = nil;
    if (xASN1Integer != nil) [xASN1Integer release]; xASN1Integer = nil;
#endif
    return retVal;
}

@end
