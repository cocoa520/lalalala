//
//  FileStreamWriter.h
//  
//
//  Created by Pallas on 8/30/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class Stream;
@class XFileKey;

@interface FileStreamWriter : NSObject

+ (BOOL)copy:(Stream*)inStream withOutStream:(NSFileHandle*)outStream withKeyCipher:(XFileKey*)keyCipher withSignature:(NSMutableData*)signature withDecompress:(Stream *)decompress withCancel:(BOOL*)cancel;

@end
