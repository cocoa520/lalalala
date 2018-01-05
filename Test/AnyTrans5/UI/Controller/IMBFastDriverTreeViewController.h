//
//  IMBFastDriverTreeViewController.h
//  AnyTrans
//
//  Created by LuoLei on 16-12-6.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBBaseViewController.h"
@class IMBFileSystemManager;
@interface IMBFastDriverTreeViewController : IMBBaseViewController {
    NSString *_exportFolder;
@public
    NSTextField *_pathField;
}
- (id)initWithIpod:(IMBiPod *)ipod  withDelegate:(id)delegate ;

- (void)editFileName;
- (void)deleteSelectedItems;
- (void)exportSelectedItems:(NSString *)exportFolder;

@end
