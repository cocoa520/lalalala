//
//  KeyImports.h
//  
//
//  Created by Pallas on 8/3/16.
//
//

#import <Foundation/Foundation.h>

@class Key;
@class PrivateKey;

@interface KeyImports : NSObject

+ (Key*)importPublicX963Key:(NSMutableData*)keyData withFieldLengthToCurveName:(NSArray*)fieldLengthToCurveName;
+ (Key*)importPublicCompactKey:(NSMutableData*)keyData withFieldLengthToCurveName:(NSArray*)fieldLengthToCurveName;
+ (Key*)importPublicKey:(NSMutableData*)keyData withFieldLengthToCurveName:(NSArray*)fieldLengthToCurveName withUseCompactKeys:(BOOL)useCompactKeys;
+ (Key*)importPrivateSECKey:(PrivateKey*)privateKey withFieldLengthToCurveName:(NSArray*)fieldLengthToCurveName;
+ (Key*)importCompactPrivateKey:(PrivateKey*)privateKey withFieldLengthToCurveName:(NSArray*)fieldLengthToCurveName;
+ (Key*)importPrivateKey:(PrivateKey*)privateKey withFieldLengthToCurveName:(NSArray*)fieldLengthToCurveName withUseCompactKeys:(BOOL)useCompactKeys;

@end
