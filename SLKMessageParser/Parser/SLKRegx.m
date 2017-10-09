//
//  SLKRegx.m
//  SLKMessageParser
//
//  Created by saix on 2017/9/14.
//  Copyright © 2017年 sai. All rights reserved.
//

#import "SLKRegx.h"
#import "SLKTokenHandler.h"

@interface SLKRegx (){
    NSRegularExpression* regx;

}


@end

@implementation SLKRegx

-(instancetype)initWithRegxStr:(NSString*)regxStr options:(NSRegularExpressionOptions)options
{
    self = [super init];
    if(self) {
        regx = [NSRegularExpression regularExpressionWithPattern:regxStr
                                                         options:options
                                                           error:nil];
        
    }
    
    return self;
}


-(NSString*)map:(NSString*)message handler:(SLKTokenHandler*)handler
{
    NSMutableString* finalString = [NSMutableString new];
    
    NSArray *matches = [regx matchesInString:message
                                     options:0
                                       range:NSMakeRange(0, message.length)];
    
    NSInteger index = 0;
    
    for (NSTextCheckingResult *match in matches) {
        
        if(index<match.range.location){
            [finalString appendString:[message substringWithRange:NSMakeRange(index, match.range.location-index)]];
        }
        
        NSString* handledString = [handler handle:message match:match];
        
        if(handledString.length>0){
            [finalString appendString:handledString];
        }
        
        index = match.range.location + match.range.length;
    }
    
    if(index<message.length){
        [finalString appendString:[message substringFromIndex:index]];
    }
    
    return finalString;
}

-(BOOL)match:(NSString*)string
{
    if(string.length == 0){
        return NO;
    }
    
    NSArray *matches = [regx matchesInString:string
                                          options:0
                                            range:NSMakeRange(0, string.length)];
    
    return matches.count>0;

}

//-(void)dealloc
//{
//    NSLog(@"dealloc %@", [self class]);
//}

@end
