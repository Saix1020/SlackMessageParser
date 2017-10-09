//
//  SLKRegx.h
//  SLKMessageParser
//
//  Created by saix on 2017/9/14.
//  Copyright © 2017年 sai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+SLKMessageParser.h"

@class SLKTokenHandler;

@interface SLKRegx : NSObject

-(instancetype)initWithRegxStr:(NSString*)regxStr options:(NSRegularExpressionOptions)options;

-(NSString*)map:(NSString*)message handler:(SLKTokenHandler*)handler;
-(BOOL)match:(NSString*)string;
@end
