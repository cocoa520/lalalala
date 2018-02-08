//
//  IMBBackupShowEntity.h
//  AnyTrans
//
//  Created by long on 16-7-26.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBCommonEnum.h"

@interface IMBBackupShowEntity : NSObject
{
    NSString *_name;
    NSImage *_image;
    CategoryNodesEnum _categoryEnum;
    NSString *_imageName;
}
@property (nonatomic, retain) NSString *imageName;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSImage *image;
@property (nonatomic, assign) CategoryNodesEnum categoryEnum;
@end
