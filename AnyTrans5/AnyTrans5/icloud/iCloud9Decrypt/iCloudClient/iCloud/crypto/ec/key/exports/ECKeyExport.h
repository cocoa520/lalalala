//
//  ECKeyExport.h
//  
//
//  Created by Pallas on 8/3/16.
//
//  Complete

#import <Foundation/Foundation.h>

@interface ECKeyExport : NSObject

- (NSMutableData*)exportKey:(id)keyData;

@end