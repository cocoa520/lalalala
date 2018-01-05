//
//  AbstractRecord.m
//
//
//  Created by JGehry on 8/2/16.
//
//  Complete

#import "AbstractRecord.h"
#import "CloudKit.pb.h"

@interface AbstractRecord ()

@property (nonatomic, readwrite, retain) Record *record;
@property (nonatomic, readwrite, retain) NSMutableDictionary *recordFields;

@end

@implementation AbstractRecord
@synthesize record = _record;
@synthesize recordFields = _recordFields;

+ (NSMutableDictionary*)map:(NSArray*)recordFields {
    NSMutableDictionary *retDict = [[[NSMutableDictionary alloc] init] autorelease];
    NSEnumerator *iterator = [recordFields objectEnumerator];
    RecordField *rf = nil;
    while (rf = [iterator nextObject]) {
        [retDict setObject:rf forKey:[[rf identifier] name]];
    }
    return retDict;
}

- (id)initWithRecord:(Record*)record {
    if (self = [self initWithRecord:record recordFields:[AbstractRecord map:[record recordFieldList]]]) {
        return self;
    } else {
        return nil;
    }
}

- (id)initWithRecord:(Record*)record recordFields:(NSMutableDictionary*)recordFields {
    if (self = [super init]) {
        if (record == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"record" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (recordFields == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"recordFields" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setRecord:record];
        [self setRecordFields:recordFields];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setRecord:nil];
    [self setRecordFields:nil];
    [super dealloc];
#endif
}

- (NSString*)type {
    return [[[self record] type] name];
}

- (Record*)getRecord {
    return [self record];
}

- (NSString*)name {
    return [[[[self getRecord] recordIdentifier] value] name];
}

- (CFTimeInterval)creation {
    double timeStamp = [[[[self record] timeStatistics] creation] time];
    return timeStamp;
}

- (CFTimeInterval)modification {
    double timeStamp = [[[[self record] timeStatistics] modification] time];
    return timeStamp;
}

- (NSMutableDictionary*)getRecordFields {
    return [[[NSMutableDictionary alloc] initWithDictionary:[self recordFields]] autorelease];
}

- (RecordField*)recordField:(NSString*)name {
    id field = [[self recordFields] objectForKey:name];
    if (field && [field isKindOfClass:[RecordField class]]) {
        RecordField *recordField = (RecordField*)field;
        return recordField;
    }else {
        return nil;
    }
}

- (RecordFieldValue*)recordFieldValue:(NSString*)name {
    id field = [[self recordFields] objectForKey:name];
    if (field && [field isKindOfClass:[RecordField class]]) {
        RecordField *recordField = (RecordField *)field;
        return [recordField value];
    }else {
        return nil;
    }
}


@end