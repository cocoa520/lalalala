//
//  IMBAllFileExport.h
//  iMobieTrans
//
//  Created by iMobie on 8/1/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBBaseTransfer.h"
#import "IMBCommonEnum.h"
#import "IMBInformation.h"
#import "IMBInformationManager.h"
@class IMBiCloudManager;
@interface IMBAllFileExport : IMBBaseTransfer {
    IMBAppTransferTypeEnum _archiveType;
    int _totalStep;
    int _curStep;
    int _singleStep;
    
    IMBInformation *_infoMation;
    int _curCategory;
    IMBiCloudManager *_icloudManager;
}
@property (nonatomic,assign)IMBiCloudManager *icloudManager;
@end
