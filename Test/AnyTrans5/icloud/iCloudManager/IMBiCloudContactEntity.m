//
//  IMBiCloudContactEntity.m
//  
//
//  Created by ding ming on 17/2/2.
//
//

#import "IMBiCloudContactEntity.h"

@implementation IMBiCloudContactEntity
@synthesize etag = _etag;
@synthesize isCompany = _isCompany;
@synthesize normalized = _normalized;
@synthesize prefix = _prefix;
@synthesize profilesArr = _profilesArr;
@synthesize imageSign =  _imageSign;
@synthesize imageUrl = _imageUrl;
@synthesize imageH = _imageH;
@synthesize imageW = _imageW;
@synthesize imageX = _imageX;
@synthesize imageY = _imageY;

- (id)init {
    if ([super init]) {
        _etag = @"";
        _isCompany = NO;
        _normalized = @"";
        _prefix = @"";
        _imageSign = @"";
        _imageUrl = @"";
        _imageH = 0;
        _imageW = 0;
        _imageX = 0;
        _imageY = 0;
    }
    return self;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    IMBiCloudContactEntity *entity = [[IMBiCloudContactEntity allocWithZone:zone]init];
    entity->_entityID =  [_entityID retain];
    entity->_contactId = [_contactId mutableCopy];
    if (_birthday != nil) {
        entity->_birthday = [[NSDate dateWithTimeIntervalSince1970:[_birthday timeIntervalSince1970]] retain];
    }
    if (_image != nil) {
        entity->_image = [_image mutableCopy];
    }
    entity->_companyName = [_companyName mutableCopy];
    entity->_department = [_department mutableCopy];
    entity->_displayAsCompany = [_displayAsCompany mutableCopy];
    entity->_firstName = [_firstName mutableCopy];
    entity->_firstNameYomi = [_firstNameYomi mutableCopy];
    entity->_jobTitle = [_jobTitle mutableCopy];
    entity->_middleName = [_middleName mutableCopy];
    entity->_lastName = [_lastName mutableCopy];
    entity->_lastNameYomi = [_lastNameYomi mutableCopy];
    entity->_notes = [_notes mutableCopy];
    entity->_suffix = [_suffix mutableCopy];
    entity->_title = [_title mutableCopy];
    entity->_dateArray = [[self dateArray] mutableCopyWithZone:zone];
    entity->_relatedNameArray = [[self relatedNameArray] mutableCopyWithZone:zone];
    entity->_phoneNumberArray = [[self phoneNumberArray] mutableCopyWithZone:zone];
    entity->_emailAddressArray = [[self emailAddressArray] mutableCopyWithZone:zone];
    entity->_urlArray = [[self urlArray] mutableCopyWithZone:zone];
    entity->_IMArray = [[self IMArray] mutableCopyWithZone:zone];
    entity->_addressArray = [[self addressArray] mutableCopyWithZone:zone];
    entity->_etag = [_etag mutableCopy];
    entity->_isCompany = _isCompany;
    entity->_normalized = [_normalized mutableCopy];
    entity->_prefix = [_prefix mutableCopy];
    entity->_profilesArr =[[self profilesArr] mutableCopyWithZone:zone];
    entity->_imageH = _imageH;
    entity->_imageX = _imageX;
    entity->_imageY = _imageY;
    entity->_imageW = _imageW;
    entity->_imageSign = [_imageSign mutableCopy];
    entity->_imageUrl = [_imageUrl mutableCopy];

    return entity;
}

- (void)dealloc
{
    if (_profilesArr != nil) {
        [_profilesArr release];
        _profilesArr = nil;
    }
    [super dealloc];
}

- (NSMutableArray *)profilesArr
{
    if (_profilesArr == nil) {
        _profilesArr = [[NSMutableArray array] retain];
    }
    
    return _profilesArr;
}

@end
