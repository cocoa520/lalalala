//
//  DER.h
//  
//
//  Created by Pallas on 7/29/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class ASN1Primitive;
@class ASN1Encodable;
@class DERIterator;
@class ASN1EncodableVector;
@class DERApplicationSpecific;
@class DERSet;
@class DERSequence;

@interface DER : NSObject

+ (ASN1Primitive*)asPrimitive:(ASN1Encodable*)encodable;
+ (id)asOptional:(Class)to withEncodable:(ASN1Encodable*)encodable;
+ (id)as:(Class)to withEncodable:(ASN1Encodable*)encodable;
+ (DERIterator*)asSequence:(ASN1Encodable*)encodable;
+ (NSMutableSet*)asPrimitiveSet:(ASN1Encodable*)encodable;
+ (NSMutableSet*)asSet:(ASN1Encodable*)encodable withClassType:(Class)classType withSel:(SEL)sel withFunction:(IMP)function;
+ (ASN1Primitive*)asApplicationSpecific:(int)tag withEncodable:(ASN1Encodable*)encodable;
+ (ASN1EncodableVector*)vectorWithSet:(NSSet*)collection;
+ (ASN1EncodableVector*)vectorWithArray:(NSArray*)collection;
+ (ASN1EncodableVector*)vector:(ASN1Encodable*)encodable,...;
+ (DERApplicationSpecific*)toApplicationSpecific:(int)tag withEncodable:(ASN1Encodable*)encodable;
+ (DERSet*)toSet:(NSSet*)collection;
+ (DERSequence*)toSequence:(NSArray*)collection;

@end
