//
//  SLKTokenArrayHandler.h
//  SLKMessageParser
//
//  Created by saix on 2017/9/15.
//  Copyright © 2017年 sai. All rights reserved.
//

#import "SLKTokenHandler.h"


@interface SLKTokenArrayHandler : SLKTokenHandler

-(instancetype)initWithPaser:(SLKMessageParser *)parser startPos:(NSMutableArray*)startPosp string:(NSString*)newString before:(NSMutableArray*)beforep array:(NSMutableArray *)array;

@end
