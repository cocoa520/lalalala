//
//  IMBBookCollection.m
//  iMobieTrans
//
//  Created by iMobie on 14-3-17.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBBookCollection.h"

@implementation IMBBookCollection

@synthesize collectionID = _collectionID;
@synthesize collectionName = _collectionName;

- (void)dealloc
{
    [_collectionName release];
    [_collectionID release];
    [super dealloc];

}
@end
