//
//  ECKeyImport.m
//  
//
//  Created by Pallas on 8/3/16.
//
//  Complete

#import "ECKeyImport.h"
#import "CategoryExtend.h"
#import "ECAssistant.h"

@implementation ECKeyImport

- (id)importKey:(NSString*)curveName withData:(NSMutableData*)data {
    return nil;
}

/**
 * Returns the elliptic curve field length corresponding to the supplied export data length, otherwise -1.
 *
 * @param dataLength
 * @return the elliptic curve field length corresponding to the supplied export data length, otherwise -1.
 */
- (int)fieldLength:(int)dataLength {
    return 0;
}

- (id)importKey:(NSMutableData*)exportedData withCurveNames:(NSArray*)curveNames {
    id retVal = nil;
    @try {
        NSString *curveName = [ECAssistant fieldLengthToCurveName:curveNames withDataLength:[self fieldLength:((int)(exportedData.length))]];
        if ([NSString isNilOrEmpty:curveName]) {
            retVal = nil;
        } else {
            retVal = [self importKey:curveName withData:exportedData];
        }
    }
    @catch (NSException *exception) {
    }
    
    return retVal;
}

@end
