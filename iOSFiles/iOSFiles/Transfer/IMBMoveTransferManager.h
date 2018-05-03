//
//  IMBMoveTransferManager.h
//  AllFiles
//
//  Created by 龙凡 on 2018/5/3.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBDriveBaseManage.h"
#import "IMBiPod.h"
@interface IMBMoveTransferManager : NSObject
{
    IMBDriveBaseManage *_originDriveBaseManager;
    IMBDriveBaseManage *_targerDriveBaseManager;
    NSMutableArray *_selectedAry;
    ChooseLoginModelEnum _originChooseModelEnum;
    ChooseLoginModelEnum _targerChooseModelEnum;
    CategoryNodesEnum _categoryNodeEnum;
    IMBiPod *_origniPod;
    IMBiPod *_targeriPod;
}
@property (nonatomic,retain) NSMutableArray *selectedAry;
@property (nonatomic,retain) IMBDriveBaseManage *originDriveBaseManager;
@property (nonatomic,retain) IMBDriveBaseManage *targerDriveBaseManager;
@property (nonatomic,assign) ChooseLoginModelEnum originChooseModelEnum;
@property (nonatomic,assign) ChooseLoginModelEnum targerChooseModelEnum;
@property (nonatomic,assign) CategoryNodesEnum categoryNodeEnum;
@property (nonatomic,retain) IMBiPod *origniPod;
@property (nonatomic,retain) IMBiPod *targeriPod;
+ (IMBMoveTransferManager*)singleton ;
- (void)driveToDriveDown:(NSMutableArray *)ary;
@end
