//
//  X9ECParametersHolder.h
//  crypto
//
//  Created by JGehry on 5/31/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "X9ECParameters.h"

@interface X9ECParametersHolder : ASN1Object {
    X9ECParameters *_params;
}

- (X9ECParameters *)getParameters:(NSString *)string;

- (X9ECParameters *)createParametersPrime192v1;
- (X9ECParameters *)createParametersPrime192v2;
- (X9ECParameters *)createParametersPrime192v3;
- (X9ECParameters *)createParametersPrime239v1;
- (X9ECParameters *)createParametersPrime239v2;
- (X9ECParameters *)createParametersPrime239v3;
- (X9ECParameters *)createParametersPrime256v1;
- (X9ECParameters *)createParametersC2pnb163v1;
- (X9ECParameters *)createParametersC2pnb163v2;
- (X9ECParameters *)createParametersC2pnb163v3;
- (X9ECParameters *)createParametersC2pnb176w1;
- (X9ECParameters *)createParametersC2tnb191v1;
- (X9ECParameters *)createParametersC2tnb191v2;
- (X9ECParameters *)createParametersC2tnb191v3;
- (X9ECParameters *)createParametersC2pnb208w1;
- (X9ECParameters *)createParametersC2tnb239v1;
- (X9ECParameters *)createParametersC2tnb239v2;
- (X9ECParameters *)createParametersC2tnb239v3;
- (X9ECParameters *)createParametersC2pnb272w1;
- (X9ECParameters *)createParametersC2pnb304w1;
- (X9ECParameters *)createParametersC2tnb359v1;
- (X9ECParameters *)createParametersC2pnb368w1;
- (X9ECParameters *)createParametersC2tnb431r1;

- (X9ECParameters *)createParametersFRP256v1;

- (X9ECParameters *)createParametersSecp112r1;
- (X9ECParameters *)createParametersSecp112r2;
- (X9ECParameters *)createParametersSecp128r1;
- (X9ECParameters *)createParametersSecp128r2;
- (X9ECParameters *)createParametersSecp160k1;
- (X9ECParameters *)createParametersSecp160r1;
- (X9ECParameters *)createParametersSecp160r2;
- (X9ECParameters *)createParametersSecp192k1;
- (X9ECParameters *)createParametersSecp192r1;
- (X9ECParameters *)createParametersSecp224k1;
- (X9ECParameters *)createParametersSecp224r1;
- (X9ECParameters *)createParametersSecp256k1;
- (X9ECParameters *)createParametersSecp256r1;
- (X9ECParameters *)createParametersSecp384r1;
- (X9ECParameters *)createParametersSecp521r1;
- (X9ECParameters *)createParametersSect113r1;
- (X9ECParameters *)createParametersSect113r2;
- (X9ECParameters *)createParametersSect131r1;
- (X9ECParameters *)createParametersSect131r2;
- (X9ECParameters *)createParametersSect163k1;
- (X9ECParameters *)createParametersSect163r1;
- (X9ECParameters *)createParametersSect163r2;
- (X9ECParameters *)createParametersSect193r1;
- (X9ECParameters *)createParametersSect193r2;
- (X9ECParameters *)createParametersSect233k1;
- (X9ECParameters *)createParametersSect233r1;
- (X9ECParameters *)createParametersSect239k1;
- (X9ECParameters *)createParametersSect283k1;
- (X9ECParameters *)createParametersSect283r1;
- (X9ECParameters *)createParametersSect409k1;
- (X9ECParameters *)createParametersSect409r1;
- (X9ECParameters *)createParametersSect571k1;
- (X9ECParameters *)createParametersSect571r1;

- (X9ECParameters *)createParametersBrainpoolP160r1;
- (X9ECParameters *)createParametersBrainpoolP160t1;
- (X9ECParameters *)createParametersBrainpoolP192r1;
- (X9ECParameters *)createParametersBrainpoolP192t1;
- (X9ECParameters *)createParametersBrainpoolP224r1;
- (X9ECParameters *)createParametersBrainpoolP224t1;
- (X9ECParameters *)createParametersBrainpoolP256r1;
- (X9ECParameters *)createParametersBrainpoolP256t1;
- (X9ECParameters *)createParametersBrainpoolP320r1;
- (X9ECParameters *)createParametersBrainpoolP320t1;
- (X9ECParameters *)createParametersBrainpoolP384r1;
- (X9ECParameters *)createParametersBrainpoolP384t1;
- (X9ECParameters *)createParametersBrainpoolP512r1;
- (X9ECParameters *)createParametersBrainpoolP512t1;


@end
