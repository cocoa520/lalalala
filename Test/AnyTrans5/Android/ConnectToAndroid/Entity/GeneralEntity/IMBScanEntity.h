//
//  IMBScanEntity.h
//  PhoneRescue_Android
//
//  Created by smz on 17/4/19.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBBaseEntity.h"
//#import "IMBScanCirAnimation.h"

@interface IMBScanEntity : IMBBaseEntity {
    
    NSString *_name;
    NSString *_imageName;
    NSString *_noValueImgName;
    ScanTypeEnum _scanType;
    int64_t _count;
    BOOL _scanStatue;
    BOOL _isSubNode;
    BOOL _isHaveValue;
    NSView *_animaView;
//    IMBScanCirAnimation *_animationView;
    NSImage *_image;
    NSImage *_toDeviceImage;//用于ToDevice时候显示的图片，calendar callHistory contact message
    
    NSImage *_bindingImage;
    int _sonAryCount;
    int _bingdingTag;
    int _index;
    NSString *_searchStr;
}

//@property (nonatomic ,retain) IMBScanCirAnimation *animationView;
@property (nonatomic ,retain) NSString *noValueImgName;
@property (nonatomic ,assign) NSView *animaView;
@property (nonatomic ,retain) NSString *name;
@property (nonatomic ,retain) NSString *imageName;
@property (nonatomic ,assign) ScanTypeEnum scanType;
@property (nonatomic ,assign) int64_t count;
//扫描状态
@property (nonatomic ,assign) BOOL scanStatue;
//子item
@property (nonatomic ,assign) BOOL isSubNode;
//有值
@property (nonatomic ,assign) BOOL isHaveValue;
@property (nonatomic ,retain) NSImage *image;
@property (nonatomic, retain) NSImage *bindingImage;
@property (nonatomic ,assign) int sonAryCount;
@property (nonatomic ,assign) int bingdingTag;
@property (nonatomic, assign) int index;
@property (nonatomic ,retain) NSString *searchStr;
@property (nonatomic, retain) NSImage *toDeviceImage;
@end

@interface IMBResultEntity : IMBBaseEntity {
@private
    int64_t _reslutCount;
    int64_t _deleteReslutCount;
    int64_t _reslutSize;
    ScanTypeEnum _scanType;
    int64_t _totalAttachmentSize;
    NSMutableArray *_reslutArray;
}

@property (nonatomic, readwrite) int64_t reslutCount;
@property (nonatomic, readwrite) int64_t reslutSize;
@property (nonatomic, readwrite) ScanTypeEnum scanType;
@property (nonatomic, readwrite, retain) NSMutableArray *reslutArray;
@property (nonatomic, readwrite) int64_t totalAttachmentSize;
@property (nonatomic, readwrite) int64_t deleteReslutCount;

- (void)reInit;

@end
