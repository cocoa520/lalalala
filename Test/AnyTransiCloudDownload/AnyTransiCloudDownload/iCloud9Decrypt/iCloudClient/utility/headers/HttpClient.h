//
//  HttpClient.h
//  
//
//  Created by Pallas on 1/11/16.
//
//

#import <Foundation/Foundation.h>

@interface HttpClient : NSObject

+ (NSMutableData*)execute:(NSMutableURLRequest*)request;
+ (NSMutableData*)executeGet:(NSMutableURLRequest*)request;
+ (NSMutableData*)executePost:(NSMutableURLRequest*)request;

@end
