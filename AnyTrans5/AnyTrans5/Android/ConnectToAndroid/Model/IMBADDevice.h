//
//  IMBADDevice.h
//  
//
//  Created by ding ming on 17/3/17.
//
//

#import "IMBBaseCommunicate.h"
#import "DeviceInfo.h"

@interface IMBADDevice : IMBBaseCommunicate {
    DeviceInfo *_deviceInfo;
}

- (id)initWithSerialNumber:(NSString *)serialNumber WithDeviceInfo:(DeviceInfo *)deviceInfo;

@end
