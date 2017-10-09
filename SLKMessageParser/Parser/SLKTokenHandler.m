//
//  SLKRegx.m
//  SLKMessageParser
//
//  Created by saix on 2017/9/14.
//  Copyright © 2017年 sai. All rights reserved.
//

#import "SLKTokenHandler.h"

@implementation SLKTokenHandler


-(instancetype)initWithPaser:(SLKMessageParser*)parser array:(NSMutableArray*)array
{
    self = [super init];
    if (self) {
        self.array = array;
        self.parser = parser;
    }
    
    return self;
    
}


-(NSString*)handle:(NSString*)message match:(NSTextCheckingResult*)match
{
    NSAssert(0, @"You should overwrite this function!");
    return nil;
}

//-(void)dealloc
//{
//    NSLog(@"dealloc %@", [self class]);
//}

@end
