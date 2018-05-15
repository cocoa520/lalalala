//
//  IMBCloudDetailCollectionViewItem.m
//  AnyTransforCloud
//
//  Created by hym on 24/04/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import "IMBCloudDetailCollectionViewItem.h"
#import "StringHelper.h"
#import "CloudItemView.h"
#import "IMBToolBarButton.h"
#import "IMBAllCloudViewController.h"

@implementation IMBCloudDetailCollectionViewItem
@synthesize model = _model;
@synthesize starBtn = _starBtn;
@synthesize shareBtn = _shareBtn;
@synthesize syncBtn = _syncBtn;
@synthesize moreBtn = _moreBtn;
@synthesize delegate = _delegate;

- (void)awakeFromNib {
    [[self textField] setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_starBtn setMouseExitedImg:[NSImage imageNamed:@"list_star"] withMouseEnterImg:[NSImage imageNamed:@"list_star2"] withMouseDownImage:[NSImage imageNamed:@"list_star3"] withMouseDisableImage:[NSImage imageNamed:@"list_star4"]];
    [_starBtn setToolTip:CustomLocalizedString(@"Mouse_Right_Menu_13", nil)];
    [_starBtn setTarget:self];
    [_starBtn setAction:@selector(star:)];

    
    [_shareBtn setMouseExitedImg:[NSImage imageNamed:@"list_share"] withMouseEnterImg:[NSImage imageNamed:@"list_share2"] withMouseDownImage:[NSImage imageNamed:@"list_share3"] withMouseDisableImage:[NSImage imageNamed:@"list_share4"]];
    [_shareBtn setToolTip:CustomLocalizedString(@"Mouse_Right_Menu_12", nil)];
    [_shareBtn setTarget:self];
    [_shareBtn setAction:@selector(share:)];

    
    [_syncBtn setMouseExitedImg:[NSImage imageNamed:@"list_sync"] withMouseEnterImg:[NSImage imageNamed:@"list_sync2"] withMouseDownImage:[NSImage imageNamed:@"list_sync3"] withMouseDisableImage:[NSImage imageNamed:@"list_sync4"]];
    [_syncBtn setToolTip:CustomLocalizedString(@"Mouse_Right_Menu_11", nil)];
    [_syncBtn setTarget:self];
    [_syncBtn setAction:@selector(sync:)];
    
    [_moreBtn setMouseExitedImg:[NSImage imageNamed:@"list_more"] withMouseEnterImg:[NSImage imageNamed:@"list_more2"] withMouseDownImage:[NSImage imageNamed:@"list_more3"] withMouseDisableImage:[NSImage imageNamed:@"list_more4"]];
    [_moreBtn setToolTip:CustomLocalizedString(@"Menu_MoreCloud_Tips", nil)];
    [_moreBtn setTarget:self];
    [_moreBtn setAction:@selector(more:)];
}

- (void)setModel:(IMBDriveModel *)model {
    
    if (model.isFolder) {
        [_syncBtn setMouseExitedImg:[NSImage imageNamed:@"list_sync"] withMouseEnterImg:[NSImage imageNamed:@"list_sync2"] withMouseDownImage:[NSImage imageNamed:@"list_sync3"] withMouseDisableImage:[NSImage imageNamed:@"list_sync4"]];
        [_syncBtn setToolTip:CustomLocalizedString(@"Mouse_Right_Menu_11", nil)];
        [_syncBtn setTarget:self];
        [_syncBtn setAction:@selector(sync:)];
    } else {
        [_syncBtn setMouseExitedImg:[NSImage imageNamed:@"list_downlaod"] withMouseEnterImg:[NSImage imageNamed:@"list_downlaod2"] withMouseDownImage:[NSImage imageNamed:@"list_downlaod3"] withMouseDisableImage:[NSImage imageNamed:@"list_downlaod4"]];
        [_syncBtn setToolTip:CustomLocalizedString(@"Mouse_Right_Menu_2", nil)];
        [_syncBtn setTarget:self];
        [_syncBtn setAction:@selector(download:)];
    }
    
    _model = model;
    if(model){
        if (model.image) {
            [self imageView].image = model.image;
        }else {
            [self imageView].image = model.iConimage;
        }
        [self textField].stringValue = model.displayName;
    }else{
        [self imageView].image = nil;
        [self textField].stringValue = @"";
    }
    if (_model.fileTypeEnum == ImageFile) {
        [_model addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
    }
    CloudItemView *itemView  =  (CloudItemView *)self.view;
    itemView.model = _model;
    [itemView.textFiled setSelectable:NO];
    [itemView.textFiled setEditable:NO];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"image"]) {
        if (_model.image) {
            [self imageView].image = _model.image;
            @try {
                [_model removeObserver:self forKeyPath:@"image"];
            }@catch (NSException *exception) {
                
            }
        }
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    if (_model.fileTypeEnum == ImageFile) {
        if (_model.image) {
            @try {
                [_model removeObserver:self forKeyPath:@"image"];
            }@catch (NSException *exception) {
                
            }
        }
    }
}

- (void)star:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(itemStar:)]) {
        [_delegate itemStar:_model];
    }
}

- (void)share:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(itemShare:)]) {
        [_delegate itemShare:_model];
    }
}

- (void)sync:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(itemSync:)]) {
        [_delegate itemSync:_model];
    }
}

- (void)download:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(itemDownload:)]) {
        [_delegate itemDownload:_model];
    }
}

- (void)more:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(itemMore: withBtn:)]) {
        [_delegate itemMore:_model withBtn:sender];
    }
}

- (void)setSelected:(BOOL)selected {
    if (selected != self.selected) {
        [super setSelected:selected];
        [_model setCheckState:selected];
        
        // Relay the new "selected" state to our AAPLSlideCarrierView.
        [(CloudItemView *)[self view] setSelected:selected];
        if (_delegate && [_delegate respondsToSelector:@selector(changeCheckButtonState:)]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_delegate changeCheckButtonState:_model];
            });
        }
    }
}

- (void)setHighlightState:(NSCollectionViewItemHighlightState)newHighlightState {
    [super setHighlightState:newHighlightState];
    [(CloudItemView *)[self view] setHighlightState:newHighlightState];
}

- (void)dealloc {
    
    [super dealloc];
}

@end
