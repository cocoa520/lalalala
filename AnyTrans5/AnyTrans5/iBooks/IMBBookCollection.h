//
//  IMBBookCollection.h
//  iMobieTrans
//
//  Created by iMobie on 14-3-17.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBBaseModel.h"

@interface IMBBookCollection : IMBBaseModel
{
    NSString *_collectionID;
    NSString *_collectionName;
}
@property(nonatomic,copy)NSString *collectionID;
@property(nonatomic,copy)NSString *collectionName;

@end
