//
//  Encoder.h
//  
//
//  Created by Pallas on 5/30/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class DataStream;

@interface Encoder : NSObject

- (int)encode:(NSMutableData*)data withOff:(int)off withLength:(int)length withOutStream:(DataStream*)outStream;
- (int)decode:(NSMutableData*)data withOff:(int)off withLength:(int)length withOutStream:(DataStream*)outStream;
- (int)decodeString:(NSString*)data withOutStream:(DataStream*)outStream;

@end
