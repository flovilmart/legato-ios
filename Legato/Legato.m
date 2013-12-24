//
//  Legato.m
//  Legato
//
//  Created by Florent Vilmart on 2013-12-24.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//

#import "Legato.h"

static Legato * _sharedInstance;

@interface Legato (){
    NSString * _apiURL;
}

-(void) setAPIURL:(NSString *) baseURL;
@end
@implementation Legato
+ (NSString *)queryStringFromParameters:(NSDictionary *)params {
    __block NSString *queryString = @"";
    
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        queryString = [queryString stringByAppendingFormat:@"&%@=%@", key, obj];
    }];
    
    return queryString;
}

-(id) init{
    self = [super init];
    if (self) {
        [self setAPIURL:@"https://payments.beanstream.com/scripts/tokenization/tokens"];
    }
    return self;
}

-(NSURL *) apiURL{
    return [NSURL URLWithString:_apiURL];
}

+(NSURL *) apiURL{
    return [[Legato sharedInstance] apiURL];
}

+(id) sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[Legato alloc] init];
    });
    return  _sharedInstance;
}

+(void) tokenizeCard:(LGCard *)card withBlock:(LegatoTokenizeResponseBlock)block{
    NSURL *url = [Legato apiURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    __block NSHTTPURLResponse *response;
    NSDictionary *headers = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"application/json", @"accept",
                             @"application/x-www-form-urlencoded charset=utf-8", @"Content-Type", nil];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    
    NSMutableDictionary *params = [@{
                             @"number":card.number,
                             @"expiry_month":card.expirationMonth,
                             @"expiry_month":card.expirationYear,
                             @"cvd  ":card.securityCode
                             } mutableCopy];
    
    
    
    if ([card optionalFields] != NULL && [[card optionalFields] count] > 0) {
        [[card optionalFields] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            params[key] = obj;
        }];
    }
    NSError * error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (error) {
        return block(nil, error);
    }
    [request setHTTPBody:jsonData];
    
    __block NSError *tokenizeError;
    __block NSData *responseData;
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&tokenizeError];
        

        NSDictionary * structuredResponse = nil;
        if (tokenizeError == nil) {
            NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&tokenizeError];
            structuredResponse = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                responseJSON, @"data",
                                                [NSString stringWithFormat:@"%ld", (long)[response statusCode]], @"status",
                                  nil];
        }
        else {
            
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            block(structuredResponse, tokenizeError);
        });
    }];
}

+(void) enableProduction{
    [[Legato sharedInstance] setAPIURL:@"https://www.beanstream.com/scripts/tokenization/tokens"];
}

-(void) setAPIURL:(NSString *)baseURL{
    _apiURL = baseURL;
}
@end
