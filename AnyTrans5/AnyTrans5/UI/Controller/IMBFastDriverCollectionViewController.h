//
//  IMBFastDriverCollectionViewController.h
//  AnyTrans
//
//  Created by LuoLei on 16-12-5.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "IMBScrollView.h"
@class IMBBackgroundBorderView;
@class IMBFileSystemManager;
@interface IMBFastDriverCollectionViewController : IMBBaseViewController
{
    NSString *_exportFolder;
    NSMutableArray *_backContainer;
    NSMutableArray *_nextContainer;
    NSMutableArray *_currentArray;
    NSString *_currentDevicePath;
    int currentIndex;
    HoverButton *advanceButton;
    HoverButton *backButton;
    IMBFileSystemManager *systemManager;
    IBOutlet NSView *_noDataView;
    IBOutlet NSTextView *_textView;
    IBOutlet NSImageView *_noDataImageView;
    IBOutlet NSBox *_mainBox;
    IBOutlet IMBWhiteView *_bgView;
    IBOutlet IMBScrollView *_systemScrollView;
    
    int _deleteTotalItems;
    @public
    NSTextField *_pathField;
}
@property(nonatomic,retain)NSMutableArray *currentArray;
@property (nonatomic,retain)NSString *currentDevicePath;
@property (nonatomic,assign)HoverButton *advanceButton;
@property (nonatomic,assign)HoverButton *backButton;
@property (nonatomic,retain)NSMutableArray *backContainer;
@property (nonatomic,retain)NSMutableArray *nextContainer;
- (id)initWithIpod:(IMBiPod *)ipod  withDelegate:(id)delegate;
- (void)getSystemFile;
#pragma mark - 实现方法
- (void)reloadView:(NSArray *)array;
- (NSArray *)doReloadMode;
- (void)editFileName;
- (void)doRename:(SimpleNode *)seletednode withName:(NSString *)name;
-(void)deleteSelectedItems;
- (NSArray *)doDelete:(NSArray *)selectedTracks;
- (void)doReloadDelete:(NSArray *)newArray;
- (void)setDeleteCurItems:(int)curItem;
- (void)exportSelectedItems:(NSString *)exportFolder;

- (void)backAction:(id)sender;
- (void)nextAction:(id)sender;
- (void)doubleClick:(NSInteger)selectIndex;
- (void)setCollectionView;
@end
