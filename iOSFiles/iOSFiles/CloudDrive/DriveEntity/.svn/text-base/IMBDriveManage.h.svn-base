//
//  IMBDriveManage.h
//  iOSFiles
//
//  Created by JGehry on 2/27/18.
//  Copyright © 2018 iMobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OneDrive.h"
@interface IMBDriveManage : NSObject <BaseDriveDelegate>
{
    NSMutableArray *_driveDataAry;
    OneDrive *_oneDrive;
    NSString *_userID;
    id _deivceDelegate;
}
@property (nonatomic,retain) NSMutableArray *driveDataAry;
@property (nonatomic,retain) NSString *userID;
- (id)initWithUserID:(NSString *)userID withDelegate:(id)delegate;
@end
