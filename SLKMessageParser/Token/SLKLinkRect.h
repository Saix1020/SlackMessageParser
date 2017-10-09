//
//  SLKLinkRect.h
//  SLKMessageDemo
//
//  Created by saix on 2017/9/29.
//  Copyright © 2017年 sai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^SLKLinkActionBlock)(NSString* url);

@interface SLKLinkRect : NSObject

@property (nonatomic, strong) NSMutableArray* rects;
@property (nonatomic, copy) NSString* url;

@property (nonatomic, strong) SLKLinkActionBlock action;

-(instancetype)initWithUrl:(NSString*)url;
-(instancetype)initWithUrl:(NSString*)url andAction:(SLKLinkActionBlock)action;

-(void)addRect:(CGRect)rect;
-(BOOL)containsPoint:(CGPoint)point;
-(void)tapped;

@end
