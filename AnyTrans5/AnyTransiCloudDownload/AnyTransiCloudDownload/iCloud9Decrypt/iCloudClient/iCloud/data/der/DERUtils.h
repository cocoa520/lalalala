//
//  DERUtils.h
//  
//
//  Created by Pallas on 7/27/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class ASN1Primitive;

@interface DERUtils : NSObject

+ (id)parseWithData:(NSMutableData*)data withClassType:(Class)classType withSel:(SEL)sel withFunction:(IMP)function;
+ (id)parseWithASN1Primitive:(ASN1Primitive*)primitive withClassType:(Class)classType withSel:(SEL)sel withFunction:(IMP)function;

@end
