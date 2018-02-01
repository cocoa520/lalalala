//
//  IMBDevicePageFolderModel.h
//  iOSFiles
//
//  Created by iMobie on 18/2/1.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMBDevicePageFolderModel : NSObject

{
    @private
    NSArray *_trackArray;
    NSArray *_photoArray;
    NSArray *_booksArray;
    NSArray *_appsArray;
    NSString *_name;
    unsigned long long _size;
    NSString *_time;
    NSInteger _counts;
    
    NSInteger _idx;
}

@property(nonatomic, copy)NSString *name;
@property(nonatomic, assign)unsigned long long size;
@property(nonatomic, copy)NSString *time;
@property(nonatomic, assign)NSInteger counts;
@property(nonatomic, retain)NSArray *trackArray;
@property(nonatomic, retain)NSArray *photoArray;
@property(nonatomic, retain)NSArray *booksArray;
@property(nonatomic, retain)NSArray *appsArray;
@property(nonatomic, assign)NSInteger idx;


@end
