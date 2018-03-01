//
//  IMBiCloudDriveManager.h
//  iOSFiles
//
//  Created by JGehry on 3/1/18.
//  Copyright © 2018 iMobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iCloudDrive.h"
#import "IMBDriveEntity.h"
@interface IMBiCloudDriveManager : NSObject <BaseDriveDelegate>
{
    iCloudDrive *_iCloudDrive;
    NSString *_userID;
    NSString *_passWordID;
    NSMutableArray *_driveDataAry;
}
- (id)initWithUserID:(NSString *)userID WithPassID:(NSString*)passID WithDelegate:(id)delegate ;
- (void)setTwoCodeID:(NSString *)twoCodeID;
- (void)drive:(iCloudDrive *)iCloudDrive logInFailWithResponseCode:(ResponseCode)responseCode;
@end
