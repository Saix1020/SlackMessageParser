//
//  SLKEmojiHandler.h
//  SLKMessageParser
//
//  Created by saix on 2017/9/15.
//  Copyright © 2017年 sai. All rights reserved.
//

#import "SLKTokenHandler.h"

@interface SLKEmojiHandler : SLKTokenHandler

-(instancetype)initWithPaser:(SLKMessageParser*)parser token:(NSString*)token array:(NSMutableArray*)array;

@end
