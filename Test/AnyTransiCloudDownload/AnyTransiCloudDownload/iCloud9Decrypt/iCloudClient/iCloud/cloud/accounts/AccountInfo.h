//
//  AccountInfo.h
//  
//
//  Created by Pallas on 1/7/16.
//
//  Complete

#import <Foundation/Foundation.h>

@interface AccountInfo : NSObject {
@private
    NSString *                      _appleId;
    NSString *                      _aDsID;
    NSString *                      _dsPrsID;
    NSString *                      _lastName;
    NSString *                      _firstName;
}

- (id)init:(NSString*)appleId withADsID:(NSString*)aDsID withDsPrsID:(NSString*)dsPrsID withLastName:(NSString*)lastName withFirstName:(NSString*)firstName;
- (id)init:(NSDictionary*)accountInfo;

- (NSString*)appleId;
- (NSString*)aDsID;
- (NSString*)dsPrsID;
- (NSString*)lastName;
- (NSString*)firstName;

@end
