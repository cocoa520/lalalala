//
//  ECKeyImport.h
//  
//
//  Created by Pallas on 8/3/16.
//
//  Complete

#import <Foundation/Foundation.h>

@interface ECKeyImport : NSObject

- (id)importKey:(NSString*)curveName withData:(NSMutableData*)data;
/**
 * Returns the elliptic curve field length corresponding to the supplied export data length, otherwise -1.
 *
 * @param dataLength
 * @return the elliptic curve field length corresponding to the supplied export data length, otherwise -1.
 */
- (int)fieldLength:(int)dataLength;
- (id)importKey:(NSMutableData*)exportedData withCurveNames:(NSArray*)curveNames;

@end
