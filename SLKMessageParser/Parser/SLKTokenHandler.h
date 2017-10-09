//
//  SLKRegx.h
//  SLKMessageParser
//
//  Created by saix on 2017/9/14.
//  Copyright © 2017年 sai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLKMessageParser.h"
#import "SLKRegx.h"
@class SLKMessageParser;

@interface SLKTokenHandler : NSObject
@property (nonatomic, weak) SLKMessageParser* parser;
@property (nonatomic, strong) NSMutableArray* array;


-(NSString*)handle:(NSString*)message match:(NSTextCheckingResult*)match ;
-(instancetype)initWithPaser:(SLKMessageParser*)parser array:(NSMutableArray*)array;

@end
