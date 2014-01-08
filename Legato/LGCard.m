//
//  LGCard.m
//  Legato
//
//  Created by Florent Vilmart on 2013-12-24.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//

#import "LGCard.h"

@implementation LGCard

-(id) initWithNumber:(NSString *) number expiryMonth:(NSInteger) expMonth expiryYear:(NSInteger) expYear securityCode:(NSInteger) securityCode{
    self = [super init];
    if (self) {
        if ([number length] > 20) {
            return nil;
        }
        _number = number;
        if (expMonth > 12 || expMonth < 1) {
            return nil;
        }
        _expirationMonth = [NSString stringWithFormat:@"%02lu",(long)expMonth];
        if (expYear > 2000) {
            // offset the expiration year if > 2000
            expYear -= 2000;
        }
        if (expYear > 50) {
            // No support after 2050
            return nil;
        }
        _expirationYear = [NSString stringWithFormat:@"%02lu", (long)expYear];
        if (securityCode > 9999 || securityCode <= 99) {
            // Amex security may be 4 digits, no security code < 100
            return nil;
        }
        _securityCode = [NSString stringWithFormat:@"%02lu", (long)securityCode];
        
    }
    return self;
    
}

-(id) initWithNumber:(NSString *) number expiryMonth:(NSInteger) expMonth expiryYear:(NSInteger) expYear securityCode:(NSInteger) securityCode error:(NSError **) error{
    self = [super init];
    if (self) {
        if ([number length] > 20) {
            return nil;
        }
        _number = number;
        if (expMonth > 12 || expMonth < 1) {
            *error = [NSError errorWithDomain:@"com.soevolved.legato" code:LGCardErrorInvalidMonth userInfo:@{@"description" : @"Month should be between 1 and 12"}];
            return nil;
        }
        _expirationMonth = [NSString stringWithFormat:@"%02lu",(long)expMonth];
        if (expYear > 2000) {
            // offset the expiration year if > 2000
            expYear -= 2000;
        }
        if (expYear > 50) {
            // No support after 2050
            *error = [NSError errorWithDomain:@"com.soevolved.legato" code:LGCardErrorInvalidYear userInfo:nil];
            return nil;
        }
        _expirationYear = [NSString stringWithFormat:@"%02lu", (long)expYear];
        if (securityCode > 9999 || securityCode <= 99) {
            // Amex security may be 4 digits, no security code < 100
            *error = [NSError errorWithDomain:@"com.soevolved.legato" code:LGCardErrorInvalidCCV userInfo:@{@"description":@"CCV sould be 3 numbers for Visa and MasterCard and 4 numbers for Amex"}];
            return nil;
        }
        _securityCode = [NSString stringWithFormat:@"%02lu", (long)securityCode];
        
    }
    return self;
    
}

@end
