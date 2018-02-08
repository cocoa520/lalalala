//
//  EscrowOperationsRecords.m
//  
//
//  Created by Pallas on 7/25/16.
//
//  Complete

#import "EscrowOperationsRecords.h"
#import "CategoryExtend.h"
#import "HttpClient.h"
#import "EscrowProxyRequest.h"

@implementation EscrowOperationsRecords

+ (NSMutableDictionary*)records:(EscrowProxyRequest*)requests {
    /*
     EscrowService SRP-6a exchanges: GETRECORDS
     */
    NSMutableURLRequest *recordsRequest = [requests getRecords];
    NSData *responsedData = [HttpClient execute:recordsRequest];
    if (!responsedData) {
        return nil;
    }
    return [responsedData dataToMutableDictionary];
}

@end
