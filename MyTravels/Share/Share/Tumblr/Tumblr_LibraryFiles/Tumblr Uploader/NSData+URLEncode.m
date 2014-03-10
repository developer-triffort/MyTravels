//
//  NSData+URLEncode.m
//  Displayr
//
//  Created by Victor Van Hee on 9/14/11.
//  Uses code from Scott James Remnant's NSString+URLEncode category
//

#import "NSData+URLEncode.h"

@implementation NSData (NSData_URLEncode)

- (NSString *) stringWithoutURLEncoding {
    NSString *hexDataDesc = [self description];
    hexDataDesc = [[hexDataDesc stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    int hlen = [hexDataDesc length];
    
    NSString *hexDataDescU = [hexDataDesc uppercaseString];
    
    const char *hexcString = [hexDataDescU cStringUsingEncoding:NSASCIIStringEncoding];
    
    char *newStringC = malloc(hlen *3);
    memset(newStringC, 0, hlen *3); 
    
    int xC= 0, value = 0;
    
    char *componentC = malloc(5);   // = "XX";
    
    componentC[2] = 0;
    
    const char *px = "%x"; char ptc = '%';
    
    for (int x=0; x<hlen; x+=2)
    {                           
        componentC[0] = hexcString[x];
        componentC[1] = hexcString[x+1];
        
        value = 0;
        sscanf(componentC, px, &value);
        if ((value <=46 && value >= 45) || (value <=57 && value >= 48) || (value <=90 && value >= 65) || (value == 95) || (value <=122 && value >= 97)) //48-57, 65-90, 97-122
        {  
            newStringC[xC++] = (char)value;
        }
        else
        {
            newStringC[xC++] = ptc;
            newStringC[xC++] = (char)componentC[0];
            newStringC[xC++] = (char)componentC[1];
        }
    }
    
    NSString *newString = [NSString stringWithCString:newStringC encoding:NSASCIIStringEncoding];
    NSString *aNewString = [newString stringByReplacingOccurrencesOfString:@"%20" withString:@"+"];
    
    free (newStringC);
    free (componentC);
    
    return aNewString;
}

- (NSString *) encodeForURL {
    NSString *newString = [self stringWithoutURLEncoding];
    newString = [newString stringByReplacingOccurrencesOfString:@"+" withString:@"%20"];
    const CFStringRef legalURLCharactersToBeEscaped = CFSTR("!*'();:@&=+$,/?#[]<>\"{}|\\`^% ");    
    NSString *urlEncodedString = [NSMakeCollectable(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)newString, NULL, legalURLCharactersToBeEscaped, kCFStringEncodingUTF8)) autorelease];
    
    return urlEncodedString;
    
}

- (NSString *) encodeForOauthBaseString {
    NSString *newString = [self encodeForURL];
    newString =[newString stringByReplacingOccurrencesOfString:@"%257E" withString:@"~"];
    return newString;
}

@end
