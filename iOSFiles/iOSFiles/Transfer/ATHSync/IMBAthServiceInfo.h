//
//  IMBAthServiceInfo.h
//  iMobieTrans
//
//  Created by iMobie on 5/9/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMBAthServiceInfo : NSObject{
    NSString *_itunesVer;
    NSString *_itunesLibID;
    int64_t _threadValue;
}

@property (nonatomic,retain) NSString *itunesVer;
@property (nonatomic,retain) NSString *itunesLibID;
@property (nonatomic) int64_t threadValue;


@end
