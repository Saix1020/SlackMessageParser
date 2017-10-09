//
//  SLKUrlHander.h
//  SLKMessageParser
//
//  Created by saix on 2017/9/15.
//  Copyright © 2017年 sai. All rights reserved.
//

#import "SLKTokenHandler.h"

@interface SLKUrlHandler : SLKTokenHandler
-(instancetype)initWithPaser:(SLKMessageParser*)parser string:(NSMutableArray*)stringp;

@end


