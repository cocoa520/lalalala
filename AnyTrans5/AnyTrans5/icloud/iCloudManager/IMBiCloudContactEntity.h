//
//  IMBiCloudContactEntity.h
//  
//
//  Created by ding ming on 17/2/2.
//
//

#import "IMBContactEntity.h"

@interface IMBiCloudContactEntity : IMBContactEntity {
    NSString *_etag;
    BOOL _isCompany;
    NSString *_normalized;
    NSString *_prefix;
    NSMutableArray *_profilesArr;
    
    //contact 头像信息
    NSString *_imageSign;
    NSString *_imageUrl;
    int _imageX;
    int _imageY;
    int _imageW;
    int _imageH;

}

@property (nonatomic, retain) NSString *etag;
@property (nonatomic, assign) BOOL isCompany;
@property (nonatomic, retain) NSString *normalized;
@property (nonatomic, retain) NSString *prefix;
@property (nonatomic, retain) NSMutableArray *profilesArr;
@property (nonatomic, retain) NSString *imageSign;
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, assign) int imageX;
@property (nonatomic, assign) int imageY;
@property (nonatomic, assign) int imageW;
@property (nonatomic, assign) int imageH;

@end
