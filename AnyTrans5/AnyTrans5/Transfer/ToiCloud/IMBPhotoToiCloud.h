//
//  IMBPhotoToiCloud.h
//  AnyTrans
//
//  Created by LuoLei on 2017-02-22.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "IMBBaseTransfer.h"
@class IMBiCloudManager;
@interface IMBPhotoToiCloud : IMBBaseTransfer
{
    IMBiCloudManager *_iCloudManager;
    NSArray *_photoArray;
    CategoryNodesEnum _category;
}
- (id)initWithIPodkey:(NSString *)ipodKey importTracks:(NSArray *)importTracks withiCloudManager:(IMBiCloudManager *)iCloudManager CategoryNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate;
@end
