//
//  IMBChooseLanguagesWindowController.h
//  PhoneClean
//
//  Created by iMobie023 on 15-7-24.
//  Copyright (c) 2015年 imobie.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBLanguageImageView.h"
#import "IMBGeneralButton.H"
#import "IMBWhiteView.h"
@interface IMBChooseLanguagesWindowController : NSWindowController
{
    IBOutlet NSImageView *_bgImageVIew;
    IBOutlet IMBWhiteView *conView;
    IBOutlet IMBLanguageImageView *enimageView;
    IBOutlet IMBLanguageImageView *japImageView;
    IBOutlet IMBLanguageImageView *germanImageView;
    IBOutlet IMBLanguageImageView *frenchImageView;
    IBOutlet IMBLanguageImageView *spanishImageView;
    IBOutlet IMBLanguageImageView *cheseImageView;
    IBOutlet IMBLanguageImageView *arabImageView;
    IBOutlet NSTextField *enTextStr;
    IBOutlet NSTextField *japTectStr;
    IBOutlet NSTextField *genrmanTextStr;
    IBOutlet NSTextField *frenchTextStr;
    IBOutlet NSTextField *spanishTextStr;
    IBOutlet NSTextField *arabTextStr;
    IBOutlet NSTextField *cheseTextStr;
    IBOutlet IMBGeneralButton *_saveBtn;
    
    IBOutlet NSTextField *optTextField;
     NSString *_langStr;
     BOOL _isSave;
}
@end
