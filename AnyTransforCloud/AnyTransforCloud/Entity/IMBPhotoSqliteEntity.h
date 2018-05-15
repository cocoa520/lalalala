//
//  IMBPhotoSqliteEntity.h
//  AnyTransforCloud
//
//  Created by 龙凡 on 2018/5/6.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMBPhotoSqliteEntity : NSObject
{
    NSString *_md5Name;
    NSString *_fileID;
    NSMutableData *_firstBytesData;
}
@property (nonatomic,retain) NSString *md5Name;
@property (nonatomic,retain) NSString *fileID;
@property (nonatomic,retain) NSMutableData *firstBytesData;
@end
