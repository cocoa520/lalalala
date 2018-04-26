//
//  IMBDevicePageFolderModel.h
//  iOSFiles
//
//  Created by iMobie on 18/2/1.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBBaseEntity.h"
@interface IMBDevicePageFolderModel : IMBBaseEntity

{
    @private
    NSArray *_trackArray;
    NSMutableArray *_subPhotoArray;
    
    NSString *_name;
    unsigned long long _size;
    NSString *_sizeString;
    NSString *_time;
    NSInteger _counts;
    NSString *_countsString;
    NSInteger _idx;
    NSImage *_image;
    CategoryNodesEnum _nodesEnum;
}
@property(nonatomic, assign)CategoryNodesEnum nodesEnum;
@property(nonatomic, retain)NSImage *image;
@property(nonatomic, retain)NSString *name;
@property(nonatomic, assign)unsigned long long size;
@property(nonatomic, retain)NSString *time;
@property(nonatomic, assign)NSInteger counts;
@property(nonatomic, retain)NSArray *trackArray;
@property(nonatomic, retain)NSMutableArray *subPhotoArray;
@property(nonatomic, assign)NSInteger idx;
@property(nonatomic, retain)NSString *sizeString;
@property(nonatomic, retain)NSString *countsString;


@end
