//
//  PhotoConversioniCloud.m
//  
//
//  Created by JGehry on 7/13/17.
//
//

#import "PhotoConversioniCloud.h"
#import "IMBADPhotoEntity.h"
#import "IMBToiCloudPhotoEntity.h"

@implementation PhotoConversioniCloud
@synthesize conversionDict = _conversionDict;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    [self setConversionDict:nil];
    [super dealloc];
#endif
}

- (instancetype)init
{
    if (self = [super init]) {
        _conversionDict = [[NSMutableDictionary alloc] init];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

//数据转化为iCloud支持的类型
- (void)conversionAlbumToiCloud:(id)album {
    NSMutableArray *returnAry = [[NSMutableArray alloc] init];
    IMBADAlbumEntity *albumEntity = nil;
    if ([album isMemberOfClass:[IMBADAlbumEntity class]]) {
        albumEntity = (IMBADAlbumEntity *)album;
    }
    if ([[albumEntity albumName] isEqualToString:@"App Photo"]) {
        for (IMBADPhotoEntity *entity in albumEntity.photoArray) {
            @autoreleasepool {
                [returnAry addObjectsFromArray:[self conversionToiCloudsWithApp:entity]];
            }
        }
    }else {
        for (IMBADPhotoEntity *entity in albumEntity.photoArray) {
            @autoreleasepool {
                [returnAry addObjectsFromArray:[self conversionToiClouds:entity]];
            }
        }
    }
    [_conversionDict setObject:returnAry forKey:[NSString stringWithFormat:@"%@", [albumEntity albumName]]];
    [returnAry release];
    returnAry = nil;
}

- (NSMutableArray *)conversionToiClouds:(IMBADPhotoEntity *)entity {
    NSMutableArray *mutAry = [[[NSMutableArray alloc] init] autorelease];
    IMBToiCloudPhotoEntity *photoEntity = [[IMBToiCloudPhotoEntity alloc] init];
    [photoEntity setClientId:[NSString stringWithFormat:@"%d", [entity photoId]]];
    [photoEntity setOriDownloadUrl:[entity url]];
    [photoEntity setPhotoTitle:[entity name]];
    [photoEntity setType:[entity mimeType]];
    [photoEntity setPhotoWidth:[entity width]];
    [photoEntity setPhotoHeight:[entity height]];
    [photoEntity setPhotoSize:[entity size]];
    if ([entity photoImage]) {
        NSLog(@"");
    }
    [mutAry addObject:photoEntity];
    [photoEntity release];
    photoEntity = nil;
    return mutAry;
}

- (NSMutableArray *)conversionToiCloudsWithApp:(IMBADPhotoEntity *)entity {
    NSMutableArray *mutAry = [[[NSMutableArray alloc] init] autorelease];
    IMBToiCloudPhotoEntity *photoEntity = [[IMBToiCloudPhotoEntity alloc] init];
    [photoEntity setClientId:[NSString stringWithFormat:@"%@", [entity name]]];
    [photoEntity setOriDownloadUrl:[entity url]];
    [photoEntity setPhotoTitle:[entity name]];
    [photoEntity setType:[entity mimeType]];
    [photoEntity setPhotoWidth:[entity width]];
    [photoEntity setPhotoHeight:[entity height]];
    [photoEntity setPhotoSize:[entity size]];
    if ([entity photoImage]) {
        NSLog(@"");
    }
    [mutAry addObject:photoEntity];
    [photoEntity release];
    photoEntity = nil;
    return mutAry;
}

@end
