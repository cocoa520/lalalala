//
//  IMBBooksPlist.h
//  iMobieTrans
//
//  Created by Pallas on 1/24/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBiPod.h"

@interface IMBBooksPlist : NSObject {
@private
    NSString *_remotingFilePath;
    NSString *_localFilePath;
    
    NSFileManager *fm;
}

@property (nonatomic, readwrite, retain) NSString *remotingFilePath;
@property (nonatomic, readwrite, retain) NSString *localFilePath;

- (NSMutableDictionary*)parsePlist:(IMBiPod*)ipod isSync:(BOOL)isSync;
- (BOOL)saveiBookPlist:(IMBiPod*)ipod contentDic:(NSMutableDictionary*)contentDic;
- (BOOL)synciBookPlist:(IMBiPod*)ipod contentDic:(NSMutableDictionary*)contentDic;
- (BOOL)synciBookPlistAfterDelete:(IMBiPod *)ipod contentDic:(NSMutableDictionary *)contentDic;
- (void)deletePlistItem:(NSArray*)dbIDArray ipod:(IMBiPod*)ipod isSync:(BOOL)isSync;
@end
