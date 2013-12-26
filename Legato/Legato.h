//
//  Legato.h
//  Legato
//
//  Created by Florent Vilmart on 2013-12-24.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGCard.h"

typedef void (^LegatoTokenizeResponseBlock)(NSDictionary *responseParams, NSError * error);

@interface Legato : NSObject


+(void) tokenizeCard:(LGCard *) card withBlock:(LegatoTokenizeResponseBlock) block;
@end

@interface Legato (deprecated)
+(void) enableProduction;
@end
