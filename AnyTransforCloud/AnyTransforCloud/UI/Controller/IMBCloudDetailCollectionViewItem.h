//
//  IMBCloudDetailCollectionViewItem.h
//  AnyTransforCloud
//
//  Created by hym on 24/04/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBDriveModel.h"
#import "IMBWhiteView.h"

@class IMBToolBarButton;
@interface IMBCloudDetailCollectionViewItem : NSCollectionViewItem
{
    IMBDriveModel* _model;
    id _delegate;
    IBOutlet IMBToolBarButton *_starBtn;
    IBOutlet IMBToolBarButton *_shareBtn;
    IBOutlet IMBToolBarButton *_syncBtn;
    IBOutlet IMBToolBarButton *_moreBtn;
}

@property (nonatomic, retain) IMBToolBarButton *starBtn;
@property (nonatomic, retain) IMBToolBarButton *shareBtn;
@property (nonatomic, retain) IMBToolBarButton *syncBtn;
@property (nonatomic, retain) IMBToolBarButton *moreBtn;
@property (nonatomic, retain) IMBDriveModel* model;
@property (nonatomic, assign) id delegate;
@end
