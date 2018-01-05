//
//  FileSignatures.h
//
//
//  Created by JGehry on 8/8/16.
//
//
//  Complete

#import <Foundation/Foundation.h>

@class DigestInputStream;
@class FileDigestA;
@class Stream;

typedef enum Type {
    A
}Type;

@interface FileSignatures : NSObject

+ (FileDigestA*)ONE;

+ (DigestInputStream*)like:(Stream*)inputStream fileSignature:(NSMutableData*)fileSignature;
+ (DigestInputStream*)of:(Stream*)inputStream type:(Type)type;
+ (NSNumber*)type:(NSMutableData*)fileSignature;
+ (FileDigestA*)typeWithFileSignature:(NSMutableData*)fileSignature;
+ (BOOL)compare:(DigestInputStream*)digestInputStream fileSignature:(NSMutableData*)fileSignature;
+ (NSMutableData*)output:(DigestInputStream*)digestInputStream;
+ (DigestInputStream*)typeA:(Stream*)inputStream;

@end