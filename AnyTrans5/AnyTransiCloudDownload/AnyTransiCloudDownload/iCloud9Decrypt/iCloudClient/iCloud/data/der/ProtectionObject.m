//
//  ProtectionObject.m
//  
//
//  Created by Pallas on 7/30/16.
//
//  Complete

#import "ProtectionObject.h"
#import "ASN1Primitive.h"
#import "ASN1OctetString.h"
#import "DER.h"
#import "DERIterator.h"
#import "DEROctetString.h"
#import "NOS.h"
#import <objc/runtime.h>

@interface ProtectionObject ()

@property (nonatomic, readwrite, retain) NSMutableSet *xSet;
@property (nonatomic, readwrite, retain) NOS *masterKey;
@property (nonatomic, readwrite, retain) NSMutableSet *masterKeySet;

@end

@implementation ProtectionObject
@synthesize xSet = _xSet;
@synthesize masterKey = _masterKey;
@synthesize masterKeySet = _masterKeySet;

static int ProtectionObject_CONT0 = 0;
static int ProtectionObject_CONT1 = 1;
static int ProtectionObject_CONT2 = 2;

- (id)initWithXSet:(NSMutableSet*)xSet withMasterKey:(NOS*)masterKey withMasterKeySet:(NSMutableSet*)masterKeySet {
    if (self = [super init]) {
        if (xSet != nil && xSet.count > 0) {
            [self setXSet:xSet];
        } else {
            [self setXSet:nil];
        }
        [self setMasterKey:masterKey];
        if (masterKeySet != nil && masterKeySet.count > 0) {
            [self setMasterKeySet:masterKeySet];
        } else {
            [self setMasterKeySet:nil];
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
        
        NSMutableSet *tmpSet = [[NSMutableSet alloc] init];
        NSArray *allkeys = tagged.allKeys;
        NSString *cont0Str = [NSString stringWithFormat:@"%d", ProtectionObject_CONT0];
        if ([allkeys containsObject:cont0Str]) {
            ASN1Primitive *asn1Obj = (ASN1Primitive*)[tagged objectForKey:cont0Str];
            if (asn1Obj != nil) {
                SEL selector = @selector(initDEROctetASN1Encodable:);
                Class classType = [DEROctetString class];
                IMP imp = class_getMethodImplementation(classType, selector);
                NSMutableSet *deroctetSet = [DER asSet:asn1Obj withClassType:classType withSel:selector withFunction:imp];
                [deroctetSet enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
                    [tmpSet addObject:[(DEROctetString*)obj getOctets]];
                }];
            }
        }
        if (tmpSet.count > 0) {
            [self setXSet:tmpSet];
        } else {
            [self setXSet:nil];
        }
#if !__has_feature(objc_arc)
        if (tmpSet != nil) [tmpSet release]; tmpSet = nil;
#endif
        NSString *cont1Str = [NSString stringWithFormat:@"%d", ProtectionObject_CONT1];
        if ([allkeys containsObject:cont1Str]) {
            ASN1Primitive *asn1Obj = (ASN1Primitive*)[tagged objectForKey:cont1Str];
            if (asn1Obj != nil) {
                NOS *nos = [[NOS alloc] initWithASN1Primitive:asn1Obj];
                [self setMasterKey:nos];
#if !__has_feature(objc_arc)
                if (nos != nil) [nos release]; nos = nil;
#endif
            } else {
                [self setMasterKey:nil];
            }
        } else {
            [self setMasterKey:nil];
        }
        NSString *cont2Str = [NSString stringWithFormat:@"%d", ProtectionObject_CONT2];
        if ([allkeys containsObject:cont2Str]) {
            ASN1Primitive *asn1Obj = (ASN1Primitive*)[tagged objectForKey:cont2Str];
            if (asn1Obj != nil) {
                SEL selector = @selector(initWithASN1Primitive:);
                Class classType = [NOS class];
                IMP imp = class_getMethodImplementation(classType, selector);
                [self setMasterKeySet:[DER asSet:asn1Obj withClassType:classType withSel:selector withFunction:imp]];
            } else {
                [self setMasterKeySet:nil];
            }
        } else {
            [self setMasterKeySet:nil];
        }
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_xSet != nil) [_xSet release]; _xSet = nil;
    if (_masterKey != nil) [_masterKey release]; _masterKey = nil;
    if (_masterKeySet != nil) [_masterKeySet release]; _masterKeySet = nil;
    [super dealloc];
#endif
}

- (NSMutableSet*)getXSet {
    @throw [NSException exceptionWithName:@"UnsupportedOperation" reason:@"TODO" userInfo:nil];
}

- (NOS*)getMasterKey {
    return [self masterKey];
}

- (NSMutableSet*)getMasterKeySet {
    if ([self masterKeySet] != nil) {
        return [[[NSMutableSet alloc] initWithSet:[self masterKeySet]] autorelease];
    } else {
        return nil;
    }
}

- (ASN1Primitive*)toASN1Primitive {
    @throw [NSException exceptionWithName:@"UnsupportedOperation" reason:@"TODO" userInfo:nil];
}

@end
