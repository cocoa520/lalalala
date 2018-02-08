//
//  DERIterator.m
//  
//
//  Created by Pallas on 7/29/16.
//
//  Complete

#import "DERIterator.h"
#import "CategoryExtend.h"
#import "ASN1Primitive.h"
#import "DERTaggedObject.h"
#import "DER.h"

@interface DERIterator ()

@property (nonatomic, readwrite, retain) NSMutableDictionary *derTaggedObjects;
@property (nonatomic, readwrite, retain) NSMutableArray *list;
@property (nonatomic, readwrite, retain) NSEnumerator *iterator;
@property (nonatomic, readwrite, retain) ASN1Primitive *peek;
@property (nonatomic, readwrite, assign) int currCount;

@end

@implementation DERIterator
@synthesize derTaggedObjects = _derTaggedObjects;
@synthesize list = _list;
@synthesize iterator = _iterator;
@synthesize peek = _peek;
@synthesize currCount = _currCount;

- (id)initWithEnumeration:(NSEnumerator*)enumeration {
    if (self = [super init]) {
        NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] init];
        [self setDerTaggedObjects:tmpDict];
        NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
        [self setList:tmpArray];
#if !__has_feature(objc_arc)
        if (tmpDict != nil) [tmpDict release]; tmpDict = nil;
        if (tmpArray != nil) [tmpArray release]; tmpArray = nil;
#endif
        id value = nil;
        while (value = [enumeration nextObject]) {
            ASN1Primitive *primitive = (ASN1Primitive*)value;
            if ([primitive isKindOfClass:[DERTaggedObject class]]) {
                DERTaggedObject *tagged = (DERTaggedObject*)primitive;
                [[self derTaggedObjects] setObject:[tagged getObject] forKey:[NSString stringWithFormat:@"%d", [tagged getTagNo]]];
            } else {
                [[self list] addObject:primitive];
            }
        }
        [self setIterator:[[self list] objectEnumerator]];
        [self setCurrCount:(int)([self list].count)];
        return self;
    } else {
        return nil;
    }
}

- (BOOL)hasNext {
    return [self peek] != nil || self.currCount > 0;
}

- (ASN1Primitive*)next {
    if ([self peek] != nil) {
        ASN1Primitive *ref = [self peek];
        [self setPeek:nil];
        return ref;
    }
    
    if (![self hasNext]) {
        return nil;
    } else {
        ASN1Primitive *primitive = [[self iterator] nextObject];
        self.currCount--;
        return primitive;
    }
}

- (ASN1Primitive*)getPeek {
    if ([self peek] == nil) {
        [self setPeek:[self next]];
    }
    return [self peek];
}

- (id)nextIf:(Class)is {
    if ([self hasNext] == NO) {
        return nil;
    }
    
    ASN1Primitive *primitive = [DER asPrimitive:[self getPeek]];
    if ([primitive isKindOfClass:is]) {
        [self next];
        return primitive;
    } else {
        return nil;
    }
}

- (NSMutableDictionary*)getDerTaggedObjects {
    return [[self derTaggedObjects] mutableDeepCopy];
}

- (ASN1Primitive*)toASN1Primitive {
    return [self next];
}

@end
