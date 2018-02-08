//
//  IMBAndroidViewController.h
//  
//
//  Created by JGehry on 7/5/17.
//
//

#import "IMBBaseViewController.h"
#import "IMBAndroid.h"
#import "DeviceAccessManager.h"
#import "IMBOpenUSBDeugViewController.h"
#import "IMBAnimation.h"
#import "IMBAndroidAlertViewController.h"

@interface IMBAndroidViewController : IMBBaseViewController {
    NSMutableDictionary *_androidDeviceMainPageDic;
    DeviceAccessManager *_devAccessManager;
    NSNotificationCenter *_nc;
    
    IBOutlet NSBox *_deviceContentBox;
    IMBOpenUSBDeugViewController *_openUSBViewController;
}

- (id)initWithDelegate:(id)delegete;
- (void)ShowWindowControllerCategory;
- (void)trustBtnOperation:(id)sender;
- (void)pauseAndroidLoad;
- (void)continueAndroidLoad;

@end
