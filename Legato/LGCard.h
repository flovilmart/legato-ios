//
//  LGCard.h
//  Legato
//
//  Created by Florent Vilmart on 2013-12-24.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGCard : NSObject

-(id) initWithNumber:(NSString *) number expiryMonth:(NSInteger) expMonth expiryYear:(NSInteger) expYear securityCode:(NSInteger) securityCode;
@property (readonly) NSString * number;
@property (readonly) NSString * expirationMonth;
@property (readonly) NSString * expirationYear;
@property (readonly) NSString * securityCode;
@property NSDictionary * optionalFields;
@end
