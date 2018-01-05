//
//  KDFCounterBytesGenerator.h
//  
//
//  Created by Pallas on 7/22/16.
//
//  Complete

#import "MacDerivationFunction.h"

@class Mac;

@interface KDFCounterBytesGenerator : MacDerivationFunction {
@private
    Mac *                                           _prf;
    int                                             _h;
    
    // fields set by init
    NSMutableData *                                 _fixedInputDataCtrPrefix;
    NSMutableData *                                 _fixedInputData_afterCtr;
    int                                             _maxSizeExcl;
    // ios is i defined as an octet string (the binary representation)
    NSMutableData *                                 _ios;
    
    // operational
    int                                             _generatedBytes;
    // k is used as buffer for all K(i) values
    NSMutableData *                                 _k;
}

- (id)initWithPrf:(Mac*)prf;

@end
