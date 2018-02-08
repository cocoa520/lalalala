//
//  AbstractRecord.h
//
//
//  Created by JGehry on 8/2/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class Record;
@class RecordField;
@class RecordFieldValue;

@interface AbstractRecord : NSObject {
@private
    Record *_record;
    NSMutableDictionary *_recordFields;
}

- (id)initWithRecord:(Record*)record;

- (NSString*)type;
- (Record*)getRecord;
- (NSString*)name;
- (CFTimeInterval)creation;
- (CFTimeInterval)modification;
- (NSMutableDictionary*)getRecordFields;
- (RecordField*)recordField:(NSString*)name;
- (RecordFieldValue*)recordFieldValue:(NSString*)name;

@end
