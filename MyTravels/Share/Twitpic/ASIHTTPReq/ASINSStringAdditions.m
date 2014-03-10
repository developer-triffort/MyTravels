//
//  ASINSStringAdditions.m
//  SnapDeck
//  Part of ASIHTTPRequest -> http://allseeing-i.com/ASIHTTPRequest
//
//  Created by Muzammil Azmi on 29/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ASINSStringAdditions.h"

@implementation NSString (CookieValueEncodingAdditions)

- (NSString *)decodedCookieValue
{
	NSMutableString *s = [NSMutableString stringWithString:[self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	//Also swap plus signs for spaces
	[s replaceOccurrencesOfString:@"+" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, [s length])];
	return [NSString stringWithString:s];
}

- (NSString *)encodedCookieValue
{
	return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
