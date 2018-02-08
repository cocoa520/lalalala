//
//  EscrowProxyRequest.h
//  
//
//  Created by Pallas on 4/26/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class Headers;

@interface EscrowProxyRequest : NSObject {
@private
    NSString *                      _dsPrsID;
    NSString *                      _escrowProxyUrl;
    NSString *                      _mmeAuthToken;
    Headers *                       _headers;
}

- (id)initWithDsPrsID:(NSString*)dsPrsID withMmeAuthToken:(NSString*)mmeAuthToken withEscrowProxyUrl:(NSString*)escrowProxyUrl withHeaders:(Headers*)headers;
- (id)initWithDsPrsID:(NSString*)dsPrsID withMmeAuthToken:(NSString*)mmeAuthToken withEscrowProxyUrl:(NSString*)escrowProxyUrl;

- (NSMutableURLRequest*)getRecords;
- (NSMutableURLRequest*)srpInit:(NSData*)key;
- (NSMutableURLRequest*)recover:(NSMutableData*)m1 withUUID:(NSMutableData*)uuid withTag:(NSMutableData*)tag;

@end
