//
//  ASINSStringAdditions.h
//  SnapDeck
//  Part of ASIHTTPRequest -> http://allseeing-i.com/ASIHTTPRequest
//
//  Created by Muzammil Azmi on 29/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CookieValueEncodingAdditions)

- (NSString *)encodedCookieValue;
- (NSString *)decodedCookieValue;

@end
