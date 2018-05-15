//
//  IMBTranferBtnManager.h
//  AllFiles
//
//  Created by 龙凡 on 2018/5/12.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMBTranferBtnManager : NSObject
{
    NSMutableArray *_tranferAry;
}
@property (nonatomic,retain) NSMutableArray *tranferAry;
+ (IMBTranferBtnManager*)singleton;
@end
