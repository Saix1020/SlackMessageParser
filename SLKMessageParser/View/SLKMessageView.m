//
//  SLKMessageView.m
//  SLKMessageParser
//
//  Created by saix on 2017/10/9.
//  Copyright © 2017年 sai. All rights reserved.
//

#import "SLKMessageView.h"
#import "SLKMessageParser.h"
#import "SLKMessageToken+Display.h"
#import "SLKMessageComponent.h"
#import "SLKLinkRect.h"

@interface SLKMessageView()

@end

@implementation SLKMessageView

-(instancetype)init
{
    self = [super init];
    if (self) {
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleSingleTap:)];
        [self addGestureRecognizer:singleFingerTap];
    }
    return self;
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:recognizer.view];
    for(SLKLinkRect* linkRect in self.linkRects){
        
        if ([linkRect containsPoint:location]) {
            
            [linkRect tapped];            
            NSLog(@"Link rect clicked! %@ in %@", [NSValue valueWithCGPoint:location], linkRect.url);
            return;
        }
    }
    for(NSValue* vrect in self.codeRects){
        CGRect rect = vrect.CGRectValue;
        if (CGRectContainsPoint(rect, location)) {
            NSLog(@"Code rect clicked! %@ in %@", [NSValue valueWithCGPoint:location], vrect);
            return;
        }
    }
}



-(NSMutableArray*)codeRects
{
    if (!_codeRects) {
        _codeRects = [NSMutableArray new];
    }
    return _codeRects;
}

-(NSMutableArray*)linkRects
{
    if (!_linkRects) {
        _linkRects = [NSMutableArray new];
    }
    return _linkRects;
}


-(void)setComponent:(SLKMessageComponent *)component
{
    [self _setComponent:component];
    
    [self setNeedsDisplay];
}

-(void)_setComponent:(SLKMessageComponent *)component
{
    if (_component == component) {
        return;
    }
    _component = component;
    
    _linkRects = nil;
    _codeRects = nil;
    
    [component getLinkRectsInto:self.linkRects andCodeRectsInto:self.codeRects];
    
    for(SLKLinkRect* linkRect in self.linkRects){
        linkRect.action = ^(NSString* url){
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"SLKMessageDemo" message:[NSString stringWithFormat:@"url %@ clicked!", url] preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:NULL]];
                UIViewController * controller = [UIApplication sharedApplication].keyWindow.rootViewController;
                while (controller.presentedViewController) {
                    controller = controller.presentedViewController;
                }
                [controller presentViewController:alertController animated:YES completion:NULL];
            });
        };
    }
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self drawComponet];
    
}

-(void)drawComponet
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.component drawWithContent:context];

}

//-(void)setMessage:(NSString *)message
//{
//    _message = message;
//
//    NSArray* stringTokens = [[[SLKMessageParser alloc] init] getTokensArray:message mode:@"NORMAL" flag:@{@"jumbomoji" : @1}];;
//    NSMutableArray* tokens = [NSMutableArray new];
//    [stringTokens enumerateObjectsUsingBlock:^(NSString* stringToken, NSUInteger idx, BOOL* stop) {
//        [tokens addObject:[[SLKMessageToken alloc] initWithToken:stringToken]];
//    }];
//    // @"*&gt;B* AAAA"
//    NSMutableArray* tokensStack = [NSMutableArray new];
//    for(SLKMessageToken* token in tokens){
//
//        if(token.isTokenStart){
//            [tokensStack insertObject:token atIndex:0];
//        }
//        else if(token.isTokenEnd){
//            NSMutableArray* subTokens = token.subTokens;
//            while(YES){
//                SLKMessageToken* firstToken = tokensStack.firstObject;
//                [tokensStack removeObjectAtIndex:0];
//
//                if(firstToken.isTokenStart){
//                    token.startToken = firstToken;
//                    break;
//                }
//                else {
//                    [subTokens addObject:firstToken];
//                }
//
//            }
//
//            BOOL ignoredToken = NO;
//            if(token.type == SLKMessageTokenB){
//                [token appendStyle:kSLKMessageTokenSpanB];
//                ignoredToken = YES;
//            }
//            else if(token.type == SLKMessageTokenI){
//                [token appendStyle:kSLKMessageTokenSpanI];
//                ignoredToken = YES;
//            }
//            else if(token.type == SLKMessageTokenSTRIKE){
//                [token appendStyle:kSLKMessageTokenSpanSTRIKE];
//                ignoredToken = YES;
//            }
//
//            token.subTokens = [[[subTokens reverseObjectEnumerator] allObjects] mutableCopy];
//
//            if(ignoredToken) {
//                [tokensStack insertObjects:subTokens atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, subTokens.count)]];
//            }
//            else {
//                [tokensStack insertObject:token atIndex:0];
//            }
//        }
//        else {
//            [tokensStack insertObject:token atIndex:0];
//        }
//    }
//    tokens = [[[tokensStack reverseObjectEnumerator] allObjects] mutableCopy];
//    SLKMessageComponent* component = [[SLKMessageComponent alloc] initWithFrame:self.bounds andType:SLKMessageComponentTypeNomal];
//    [component addSLKMessageTokens:tokens];
//
//    messageComponent = component;
//
//    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, messageComponent.frame.size.height);
//}




@end
