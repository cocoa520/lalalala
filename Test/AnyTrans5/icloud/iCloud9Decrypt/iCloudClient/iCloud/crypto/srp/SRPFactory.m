//
//  SRPFactory.m
//  
//
//  Created by Pallas on 4/27/16.
//
//  Complete

#import "SRPFactory.h"
#import "BigInteger.h"
#import "Digest.h"
#import "Sha256Digest.h"
#import "SRPClient.h"
#import "SecureRandom.h"
#import "Hex.h"

@implementation SRPFactory

+ (NSString*)DEFAULT_PRIME_HEX {
    static NSString *_default_prime_hex = nil;
    @synchronized(self) {
        if (_default_prime_hex == nil) {
            _default_prime_hex = [[NSString alloc] initWithString:@"AC6BDB41324A9A9BF166DE5E1389582FAF72B6651987EE07FC3192943DB56050A37329CBB4A099ED8193E0757767A13DD52312AB4B03310DCD7F48A9DA04FD50E8083969EDB767B0CF6095179A163AB3661A05FBD5FAAAE82918A9962F0B93B855F97993EC975EEAA80D740ADBF4FF747359D041D5C33EA71D281E446B14773BCA97B43A23FB801676BD207A436C6481F1D2B9078717461A5B9D32E688F87748544523B524B0D57D5EA77A2775D2ECFA032CFBDBF52FB3786160279004E57AE6AF874E7303CE53299CCC041C7BC308D82A5698F3A8D0C38271AE35F8E9DBFBB694B5C803D89F7AE435DE236D525F54759B65E372FCD68EF20FA7111F9E4AFF73"];
        }
    }
    return _default_prime_hex;
}

+ (SRPClient*)rfc5054:(SecureRandom*)random {
    /**
     *  Changed by Gehry
     */
    BigInteger *N = [[BigInteger alloc] initWithValue:[SRPFactory DEFAULT_PRIME_HEX] withRadix:16];
//    BigInteger *N = [[BigInteger alloc] initWithSign:1 withBytes:[Hex decodeWithString:[SRPFactory DEFAULT_PRIME_HEX]]];
    Digest *digest = [[Sha256Digest alloc] init];
    SRPClient *srpClient = [[[SRPClient alloc] initWithRandom:random withDigest:digest withN:N withG:[BigInteger Two]] autorelease];
#if !__has_feature(objc_arc)
    if (N != nil) [N release]; N = nil;
    if (digest != nil) [digest release]; digest = nil;
#endif
    return srpClient;
}

@end
