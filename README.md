legato-ios
==========

Beanstream Legato iOS SDK for Credit Card tokenization

Unofficial port from [Legato-js](https://www.beanstream.com/scripts/tokenization/legato-1.1.js)

## Installation

- [Download the pre-built library](https://github.com/vfloz/legato-ios/releases/0.1).
- Add libLegato.a to your project and to Build Phases -> Link Binary With Libraries.

#### Headers

##### includes folder
The includes folder is automatically included in the project's header search path.

- Copy the include folder to your project (or include/balanced to your existing include folder). Drag the folder to your project to add the references.

If you copy the files to a location other than includes you'll probably need to add the path to User Header Search Paths in your project settings.

##### Direct copy
You can copy the headers directly into your proejct and add them as direct references.
- Drag the contents of include/balanced to your project (select copy if needed)

## Usage

```
#import "Legato.h" // Tokenize
#import "LGCard.h" // Card

LGCard * card = [[LGCard alloc] initWithNumber:@"5100000010001004" expiryMonth:1 expiryYear:14 securityCode:123];


if(card){
	// By default Legato runs in the sandbox
	/*
		[Legato enableProduction];
	*/
	 [Legato tokenizeCard:card withBlock:^(NSDictionary *response, NSError *error) {
            NSString * token = response[@"data"][@"token"];
            // Use the token after
     }];
}
```

##### Example response

```
{
     data =     {
        code = 1;
        message = "";
        token = "gt3-740403f2-b9ec-4afe-bff6-8daedb366ef8";
        version = 1;
    };
    status = 200;
}
```
