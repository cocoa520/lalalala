//
//  IMBAppClone.h
//  iMobieTrans
//
//  Created by iMobie on 12/22/15.
//  Copyright (c) 2015 iMobie Inc. All rights reserved.
//

#import "IMBBaseClone.h"

@interface IMBAppClone : IMBBaseClone {
    NSArray *_sourceAppDomain;
    NSArray *_targetAppDomain;
    NSArray *_sourceApp;
    NSArray *_targetApp;
}

@property (nonatomic, retain) NSArray *sourceApp;
@property (nonatomic, retain) NSArray *targetApp;
- (void)merge;
- (void)toDevice;

@end
