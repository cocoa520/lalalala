//
//  IMBBackupNoteViewController.h
//  AnyTrans
//
//  Created by long on 16-7-20.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBBaseViewController.h"
#import "IMBBackupNoteEditView.h"
#import "IMBScrollView.h"
#import "IMBNoteContentView.h"
#import "IMBWhiteView.h"
#import "IMBNoteDataEntity.h"
#import "IMBPopUpBtn.h"
#import "LoadingView.h"
@interface IMBBackupNoteViewController : IMBBaseViewController 
{
    IBOutlet NSImageView *_nodataImageVIew;
    IMBBackupNoteEditView *_noteEditView;
    IMBNoteModelEntity *_notesEntity;
    IBOutlet IMBScrollView *noteScrollView;
    IMBNoteContentView *_noteContentView;
    IBOutlet IMBScrollView *_tabScrollView;
    IBOutlet IMBWhiteView *_lineView;
    IBOutlet NSView *_dataView;
    IBOutlet NSView *_noDataView;

    IBOutlet NSBox *_noteBox;
    IBOutlet NSTextField *_noDataTitle;
    IMBBackupDecryptAbove4 * _decryptAbove4;
    SimpleNode *_node;
    IMBiCloudBackup *_iCloudBackUp;

    IBOutlet LoadingView *_loadingAnimationView;
    IBOutlet IMBWhiteView *_loadingView;
}

@end
