//
//  LegatoTests.m
//  LegatoTests
//
//  Created by Florent Vilmart on 2013-12-24.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Legato.h"
#import "LGCard.h"
#import <objc/runtime.h>


static char mn_waitingForAsynchronousTestKey;
@interface LegatoTests : XCTestCase

@end

@implementation LegatoTests


- (void)mn_preformWithTimeout:(NSTimeInterval)timeout asynchronousTest:(void (^)(void))asynchronousTest
{
    // run test block
	[self mn_setWaitingForAsynchronousTest:YES];
	asynchronousTest();
	
	NSTimeInterval timeoutTime = [[NSDate dateWithTimeIntervalSinceNow:timeout] timeIntervalSinceReferenceDate];
	while ([self mn_waitingForAsynchronousTest])  {
		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1f]];
		if ([NSDate timeIntervalSinceReferenceDate] > timeoutTime) {
			XCTFail(@"Test timed out! Did you forget to call -mn_finishRunningAsynchronousTest");
			[self mn_setWaitingForAsynchronousTest:NO];
		}
	}
}



- (void)mn_finishRunningAsynchronousTest
{
	[self mn_setWaitingForAsynchronousTest:NO];
}


- (void)mn_setWaitingForAsynchronousTest:(BOOL)isWaiting;
{
	objc_setAssociatedObject(self, &mn_waitingForAsynchronousTestKey, @(isWaiting), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (BOOL)mn_waitingForAsynchronousTest
{
	NSNumber *valueObject = objc_getAssociatedObject(self, &mn_waitingForAsynchronousTestKey);
	return [valueObject boolValue];
}

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void) testInvalidMonth{
    LGCard * card = [[LGCard alloc] initWithNumber:@"5100000010001004" expiryMonth:0 expiryYear:2014 securityCode:123];
    XCTAssertTrue(card == nil, @"Invalid Month OK");
}

-(void) testInvalidYear{
    LGCard * card = [[LGCard alloc] initWithNumber:@"5100000010001004" expiryMonth:0 expiryYear:2055 securityCode:123];
    XCTAssertTrue(card == nil, @"Invalid Year OK");
}

-(void) testInvalidYear2{
    LGCard * card = [[LGCard alloc] initWithNumber:@"5100000010001004" expiryMonth:1 expiryYear:55 securityCode:123];
    XCTAssertTrue(card == nil, @"Invalid Year OK");
}

-(void) testCardTooLong{
    // 21 digit card
    LGCard * card = [[LGCard alloc] initWithNumber:@"123456789012345678901" expiryMonth:1 expiryYear:14 securityCode:123];
    XCTAssertTrue(card == nil, @"Invalid Card OK");
}

-(void) testSecurityCodeTooLong{
    // 5 digit security code
    LGCard * card = [[LGCard alloc] initWithNumber:@"123456789012345678901" expiryMonth:1 expiryYear:14 securityCode:10000];
    XCTAssertTrue(card == nil, @"Invalid Security Code OK");
}


- (void) testValidCard
{
    [Legato enableProduction];
    LGCard * card = [[LGCard alloc] initWithNumber:@"5100000010001004" expiryMonth:2 expiryYear:2014 securityCode:123];
    
     [self mn_preformWithTimeout:120 asynchronousTest:^{
        [Legato tokenizeCard:card withBlock:^(NSDictionary *responseParams, NSError *error) {
            NSLog(@"%@ %@", responseParams, error);
            XCTAssertTrue(responseParams !=nil, @"Failed to create card.");
			[self mn_finishRunningAsynchronousTest];
        }];
     }];
}

@end
