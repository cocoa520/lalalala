//
//  DER.m
//  
//
//  Created by Pallas on 7/29/16.
//
//  Complete

#import "DER.h"
#import "ASN1Primitive.h"
#import "ASN1Encodable.h"
#import "ASN1Sequence.h"
#import "DERIterator.h"
#import "ASN1Set.h"
#import "DERApplicationSpecific.h"
#import "ASN1EncodableVector.h"
#import "DERSet.h"
#import "DERSequence.h"
#import "DLSet.h"

#define FUNCINFO [NSString stringWithFormat:@"Method: %s, Line: %d", __func__, __LINE__]

@implementation DER

+ (ASN1Primitive*)asPrimitive:(ASN1Encodable*)encodable {
    return [encodable isKindOfClass:[ASN1Primitive class]] ? (ASN1Primitive*)encodable : [encodable toASN1Primitive];
}

+ (id)asOptional:(Class)to withEncodable:(ASN1Encodable*)encodable {
    if (encodable == nil) {
        return nil;
    }
    
    ASN1Primitive *primitive = [DER asPrimitive:encodable];
    if ([primitive isKindOfClass:to]) {
        return primitive;
    } else {
        return nil;
    }
}

+ (id)as:(Class)to withEncodable:(ASN1Encodable*)encodable {
    id retVal = [DER asOptional:to withEncodable:encodable];
    if (retVal == nil) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:[NSString stringWithFormat:@"bad class, expected %@ got %@", to, [encodable className]] userInfo:nil];
    }
    return retVal;
}

+ (DERIterator*)asSequence:(ASN1Encodable*)encodable {
    return [[[DERIterator alloc] initWithEnumeration:[[DER as:[ASN1Sequence class] withEncodable:[DER asPrimitive:encodable]] getObjects]] autorelease];
}

+ (NSMutableSet*)asPrimitiveSet:(ASN1Encodable*)encodable {
    NSEnumerator *enumeration = [[DER as:[ASN1Set class] withEncodable:encodable] getObjects];
    NSMutableSet *set = [[[NSMutableSet alloc] init] autorelease];
    id value = nil;
    while (value = [enumeration nextObject]) {
        ASN1Encodable *element = (ASN1Encodable*)value;
        ASN1Primitive *primitive = [DER asPrimitive:element];
        [set addObject:primitive];
    }
    return set;
}

+ (NSMutableSet*)asSet:(ASN1Encodable*)encodable withClassType:(Class)classType withSel:(SEL)sel withFunction:(IMP)function {
    NSMutableSet *retSet = [[[NSMutableSet alloc] init] autorelease];
    @autoreleasepool {
        NSMutableSet *priSet = [DER asPrimitiveSet:encodable];
        typedef id (*MethodName)(id, SEL, ASN1Primitive*);
        MethodName methodName = (MethodName)function;
        NSEnumerator *enumeration = [priSet objectEnumerator];
        ASN1Primitive *obj = nil;
        while (obj = [enumeration nextObject]) {
            id classobj = [classType alloc];
            id pK0bj = methodName(classobj, sel, obj);
            if (pK0bj && [pK0bj isKindOfClass:classType]) {
                [retSet addObject:pK0bj];
            }
#if !__has_feature(objc_arc)
            if (classobj) [classobj release]; classobj = nil;
#endif
        }
    }
    return retSet;
}

+ (ASN1Primitive*)asApplicationSpecific:(int)tag withEncodable:(ASN1Encodable*)encodable {
    @try {
        DERApplicationSpecific *specific = [DER as:[DERApplicationSpecific class] withEncodable:encodable];
        
        if ([specific getApplicationTag] == tag) {
            return [specific getObject];
        } else {
            @throw [NSException exceptionWithName:@"IllegalArgument" reason:[NSString stringWithFormat:@"tag mismatch, expected %d got %d", tag, [specific getApplicationTag]] userInfo:nil];
        }
    }
    @catch (NSException *exception) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:[exception reason] userInfo:nil];
    }
}

+ (ASN1EncodableVector*)vectorWithSet:(NSSet*)collection {
    if (collection == nil || collection.count <= 0) {
        return nil;
    }
    ASN1EncodableVector *retVector = [[[ASN1EncodableVector alloc] init] autorelease];
    for (id obj in collection) {
            [retVector add:obj];
    }
    return retVector;
}

+ (ASN1EncodableVector*)vectorWithArray:(NSArray*)collection {
    if (collection == nil || collection.count <= 0) {
        return nil;
    }
    ASN1EncodableVector *retVector = [[[ASN1EncodableVector alloc] init] autorelease];
    for (id obj in collection) {
        [retVector add:obj];
    }
    return retVector;
}

+ (ASN1EncodableVector*)vector:(ASN1Encodable*)encodable,... {
    NSMutableArray *argArray = [[NSMutableArray alloc] init];
    va_list argList;
    ASN1Encodable *arg = nil;
    if (encodable != nil) {
        va_start(argList, encodable);
        [argArray addObject:encodable];
        while((arg = va_arg(argList, ASN1Encodable*))) {
            [argArray addObject:arg];
        }
        va_end(argList);
    }
    ASN1EncodableVector *retVector = [DER vectorWithArray:argArray];
#if !__has_feature(objc_arc)
    if (argArray != nil) [argArray release]; argArray = nil;
#endif
    return retVector;
}

+ (DERApplicationSpecific*)toApplicationSpecific:(int)tag withEncodable:(ASN1Encodable*)encodable {
    @try {
        return [[[DERApplicationSpecific alloc] initParamInt:tag paramASN1Encodable:encodable] autorelease];
    }
    @catch (NSException *exception) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:[exception reason] userInfo:nil];
    }
}



+ (DERSet*)toSet:(NSSet*)collection {
    return [[[DERSet alloc] initDERParamASN1EncodableVector:[DER vectorWithSet:collection]] autorelease];
}

+ (DERSequence*)toSequence:(NSArray*)collection {
    return [[[DERSequence alloc] initDERParamASN1EncodableVector:[DER vectorWithArray:collection]] autorelease];
}

@end
