//
//  IMBBlockView.h
//  iMobieTrans
//
//  Created by iMobie on 5/28/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBContactEntity.h"
#import "IMBPopupButton.h"

typedef enum {
    PhoneNumberBlock = 0,
    EmailBlock = 1,
    URLBlock = 2,
    DateBlock = 3,
    RelatedNameBlock = 4,
    IMBlock = 5,
    AddressBlock = 6
}BlockType;

@interface IMBBlockView : NSView<InternalLayoutChange>{
    NSMutableArray *_entityArr;
    NSMutableArray *_entityViewArr;
    CGFloat compHeight;
    id _delegate;
    BlockType _blockType; //如phonenumber/url/address/im
    BOOL _isEditing;
    BOOL _isLastItem;
    NSString *_contactID;
    NSNumber *_entityID;
}

@property (nonatomic,assign) id delegate;
@property (nonatomic,retain) NSString *contactID;
@property (nonatomic,retain) NSNumber *entityID;
@property (nonatomic,assign) BlockType blockType;
@property (nonatomic,readwrite,setter = setIsEditing:) BOOL isEditing;
@property (nonatomic,assign) BOOL isLastItem;

#pragma mark -  数据源处理
- (void)addEntity:(IMBContactBaseEntity *)entity;
- (void)addEntities:(NSArray *)entities;
- (void)addEmptyEntity;
- (BOOL)isEditing;
- (void)setIsEditing:(BOOL)isEditing;
- (NSMutableArray *)dataArr;
#pragma mark - 界面处理
- (void)initSubviews;
- (void)layoutSubviews;

@end
