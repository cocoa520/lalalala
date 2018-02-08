//
//  KDFCounterBytesGenerator.m
//  
//
//  Created by Pallas on 7/22/16.
//
//  Complete

#import "KDFCounterBytesGenerator.h"
#import "CategoryExtend.h"
#import "BigInteger.h"
#import "Mac.h"
#import "DerivationParameters.h"
#import "KDFCounterParameters.h"
#import "KeyParameter.h"

@interface KDFCounterBytesGenerator ()

// fields set by the constructor
@property (nonatomic, readwrite, retain) Mac *prf;
@property (nonatomic, readwrite, assign) int h;

// fields set by init
@property (nonatomic, readwrite, retain) NSMutableData *fixedInputDataCtrPrefix;
@property (nonatomic, readwrite, retain) NSMutableData *fixedInputData_afterCtr;
@property (nonatomic, readwrite, assign) int maxSizeExcl;

// ios is i defined as an octet string (the binary representation)
@property (nonatomic, readwrite, retain) NSMutableData *ios;

// operational
@property (nonatomic, readwrite, assign) int generatedBytes;
// k is used as buffer for all K(i) values
@property (nonatomic, readwrite, retain) NSMutableData *k;

@end

@implementation KDFCounterBytesGenerator
@synthesize prf = _prf;
@synthesize h = _h;
@synthesize fixedInputDataCtrPrefix = _fixedInputDataCtrPrefix;
@synthesize fixedInputData_afterCtr = _fixedInputData_afterCtr;
@synthesize maxSizeExcl = _maxSizeExcl;
@synthesize ios = _ios;
@synthesize generatedBytes = _generatedBytes;
@synthesize k = _k;

static const int  MAX_VALUE = 0x7fffffff;

+ (BigInteger*)INTEGER_MAX {
    static BigInteger *_interger_max = nil;
    @synchronized(self) {
        if (_interger_max == nil) {
            _interger_max = [[BigInteger valueOf:MAX_VALUE] retain];
        }
    }
    return _interger_max;
}

+ (BigInteger*)TWO {
    static BigInteger *_two = nil;
    @synchronized(self) {
        if (_two == nil) {
            _two = [BigInteger Two];
        }
    }
    return _two;
}

- (id)initWithPrf:(Mac*)prf {
    if (self = [super init]) {
        @autoreleasepool {
            [self setPrf:prf];
            [self setH:[prf getMacSize]];
            NSMutableData *tmpData = [[NSMutableData alloc] initWithSize:self.h];
            [self setK:tmpData];
#if !__has_feature(objc_arc)
            if (tmpData != nil) [tmpData release]; tmpData = nil;
#endif
        }
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setPrf:nil];
    [self setFixedInputDataCtrPrefix:nil];
    [self setFixedInputData_afterCtr:nil];
    [self setIos:nil];
    [self setK:nil];
    [super dealloc];
#endif
}

- (void)init:(DerivationParameters*)param {
    @autoreleasepool {
        if (param == nil || ![param isKindOfClass:[KDFCounterParameters class]]) {
            @throw [NSException exceptionWithName:@"Argument" reason:@"Wrong type of arguments given" userInfo:nil];
        }
        
        KDFCounterParameters *kdfParams = (KDFCounterParameters*)param;
        
        // --- init mac based PRF ---
        KeyParameter *tmpKP = [[KeyParameter alloc] initWithKey:[kdfParams getKI]];
        [[self prf] init:tmpKP];
#if !__has_feature(objc_arc)
        if (tmpKP != nil) [tmpKP release]; tmpKP = nil;
#endif
        
        // --- set arguments ---
        [self setFixedInputDataCtrPrefix:[kdfParams getFixedInputDataCounterPrefix]];
        [self setFixedInputData_afterCtr:[kdfParams getFixedInputDataCounterSuffix]];
        
        int r = [kdfParams getR];
        NSMutableData *tmpData = [[NSMutableData alloc] initWithSize:(r / 8)];
        [self setIos:tmpData];
#if !__has_feature(objc_arc)
        if (tmpData != nil) [tmpData release]; tmpData = nil;
#endif
        
        BigInteger *maxSize = [[[KDFCounterBytesGenerator TWO] powWithExp:r] multiplyWithVal:[BigInteger valueOf:[self h]]];
        [self setMaxSizeExcl:([maxSize compareTo:[KDFCounterBytesGenerator INTEGER_MAX]] == 1 ? MAX_VALUE : [maxSize intValue])];
        
        // --- set operational state ---
        [self setGeneratedBytes:0];
    }
}

- (Mac*)getMac {
    return [self prf];
}

- (int)generateBytes:(NSMutableData*)output withOutOff:(int)outOff withLength:(int)length {
    int generatedBytesAfter = [self generatedBytes] + length;
    if (generatedBytesAfter < 0 || generatedBytesAfter >= self.maxSizeExcl) {
        @throw [NSException exceptionWithName:@"DataLength" reason:[NSString stringWithFormat:@"Current KDFCTR may only be used for %d bytes", self.maxSizeExcl] userInfo:nil];
    }
    
    if (self.generatedBytes % self.h == 0) {
        [self generateNext];
    }
    
    // copy what is left in the currentT (1..hash
    int toGenerate = length;
    int posInK = self.generatedBytes % self.h;
    int leftInK = self.h - self.generatedBytes % self.h;
    int toCopy = MIN(leftInK, toGenerate);
    [output copyFromIndex:outOff withSource:[self k] withSourceIndex:posInK withLength:toCopy];
    self.generatedBytes += toCopy;
    toGenerate -= toCopy;
    outOff += toCopy;
    
    while (toGenerate > 0) {
        [self generateNext];
        toCopy = MIN(self.h, toGenerate);
        [output copyFromIndex:outOff withSource:[self k] withSourceIndex:0 withLength:toCopy];
        self.generatedBytes += toCopy;
        toGenerate -= toCopy;
        outOff += toCopy;
    }
    
    return length;
}

- (void)generateNext {
    int i = self.generatedBytes / self.h + 1;
    
    if ([self ios].length == 4) {
        ((Byte*)([self ios].bytes))[0] = (Byte)(i >> 24);
        ((Byte*)([self ios].bytes))[[self ios].length - 3] = (Byte)(i >> 16);
        ((Byte*)([self ios].bytes))[[self ios].length - 2] = (Byte)(i >> 8);
        ((Byte*)([self ios].bytes))[[self ios].length - 1] = (Byte)i;
    } else {
        @throw [NSException exceptionWithName:@"Exception" reason:@"Unsupported size of counter i" userInfo:nil];
    }
    
    // special case for K(0): K(0) is empty, so no update
    [[self prf] blockUpdate:[self fixedInputDataCtrPrefix] withInOff:0 withLen:(int)([self fixedInputDataCtrPrefix].length)];
    [[self prf] blockUpdate:[self ios] withInOff:0 withLen:(int)([self ios].length)];
    [[self prf] blockUpdate:[self fixedInputData_afterCtr] withInOff:0 withLen:(int)([self fixedInputData_afterCtr].length)];
    [[self prf] doFinal:[self k] withOutOff:0];
}

@end
