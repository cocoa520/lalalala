//
//  DERIterator.h
//  
//
//  Created by Pallas on 7/29/16.
//
//  Complete

#import "ASN1Encodable.h"

@class ASN1Primitive;

@interface DERIterator : ASN1Encodable {
@private
    NSMutableDictionary *                               _derTaggedObjects;
    NSMutableArray *                                    _list;
    NSEnumerator *                                      _iterator;
    ASN1Primitive *                                     _peek;
    int                                                 _currCount;
}

- (id)initWithEnumeration:(NSEnumerator*)enumeration;

- (BOOL)hasNext;
- (ASN1Primitive*)next;
- (ASN1Primitive*)getPeek;
- (id)nextIf:(Class)is;
- (NSMutableDictionary*)getDerTaggedObjects;

@end
