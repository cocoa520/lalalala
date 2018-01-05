//
//  CalendarConversioniCloud.h
//  
//
//  Created by JGehry on 7/6/17.
//
//

#import <Foundation/Foundation.h>

@interface CalendarConversioniCloud : NSObject {
    NSMutableDictionary *_conversionDict;
}

@property (nonatomic, readwrite, retain) NSMutableDictionary *conversionDict;

//数据转化为iCloud支持的类型
- (void)conversionAccountToiCloud:(id)account;

@end
