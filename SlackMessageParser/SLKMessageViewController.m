//
//  SLKMessageViewController.m
//  SLKMessage
//
//  Created by saix on 2017/9/5.
//  Copyright © 2017年 sai. All rights reserved.
//

#import "SLKMessageViewController.h"
#import "SLKMessageCell.h"

@interface SLKMessageViewController ()
//@property (strong, nonatomic) NSCache *cache;
@property (strong, nonatomic) NSMutableArray *messages;
@property (nonatomic) BOOL isAsync;

@end

@implementation SLKMessageViewController

-(instancetype)initWithAsync:(BOOL)isAsync
{
    self = [super init];
    if (self){
        self.isAsync = isAsync;
    }
    return self;
}


+(NSArray*)sampleMessages
{
    return @[

             [NSString stringWithFormat:@":copyright: `g` <@saix> :sweat_smile:\n&gt;&gt;&gt;&gt; &gt;&gt;  &gt;p\nA\n`AAA`\n&gt; &gt;&gt;<@1234> &gt;<@1235> fdsfdsf dsfdsfdsfdsfdsfdsfdsfdsfdsfdsfdsfdsfdsf fdsfdsfds :smile::sweat_smile: :sweat_smile: \n_&gt;<@1235>_ + ran `d` om :%@\n %@", @(rand()), @"&gt;&gt;&gt;&gt; &gt;&gt;  &gt;p\nA\n`AAA`\n&gt; &gt;&gt;<@1234> &gt;<@1235> fdsfdsf dsfdsfdsfdsfdsfdsfdsfdsfdsfdsfdsfdsfdsf fdsfdsfds :smile::sweat_smile: :sweat_smile: \n_&gt;<@1235>_ "],

             @"这句报错：Unknow type name UISwipeActionsConfiguration 是什么原因啊？",

             [NSString stringWithFormat:@":copyright: `g` <@saix> :sweat_smile: %@ + ran `d` om : %@", @"A\n&gt;&gt;&gt;p \n&gt;_B_ ~*_A_ ~C~* XXXX _B_~ _c_ kkkk _ZZZZ_ ~AAAAA _BBBBBB_~ * *A* * AAAAA \nC \n&gt;fdfd `code codecode codecodecodec odec odeco decodecodecode`\nA\n```if(a) `:smile_cat:`\nelse :sweat_smile: *A* http://localhost.com f ff ff ff ff f ff ff ff ff```\n:smile_cat: `*A*` `:smile_cat:`", @(rand())],
//
             @":woman-heart-woman::skin-tone-2:\u200D\u2640 :woman-heart-woman::skin-tone-2:",

             @"A\n&gt;aaaa\nBC",
             @"A `code1` \n_&gt;p_ `code3` \n*B* `Code2ji`\n`codex`",
             @"&gt;*p*",
             @"&gt;&gt;&gt;`AAA`\n&gt; &gt;&gt; <@U6642CDC0|saix> &gt; <@U68THKSQ0|liang> fdsfdsf dsfdsfdsfdsfdsfdsfdsfdsfdsfdsfdsfdsfdsf fdsfdsfds",
             @"&gt;`A`",
             @"&gt;&gt;&gt;p f\n&gt;p2",
             @"Hello, I’m Slackbot. Hello, I’m Slackbot. Hello, I’m Slackbot.\nHello, I’m Slackbot.\n",
                 @"<@U3F2RKE1Y> uploaded a file: <https://citrix.slack.com/files/U3F2RKE1Y/F79EFH150/-.c|Untitled>",
             ];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 60;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    self.messages = [@[] mutableCopy];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        for(NSUInteger index = 0; index<100;++index){
            SLKMessageComponent* model = [[SLKMessageComponent alloc] initWithFrame:CGRectMake(0, 0, [SLKMessageCell containerWidth], 0) andType:SLKMessageComponentTypeNomal];
            [model setMessage:[SLKMessageViewController sampleMessages][index%[SLKMessageViewController sampleMessages].count]];
            [self.messages addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^(){
            [self.tableView reloadData];

        });

    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for(NSUInteger index = 0; index<100;++index){
            SLKMessageComponent* model = [[SLKMessageComponent alloc] initWithFrame:CGRectMake(0, 0, [SLKMessageCell containerWidth], 0) andType:SLKMessageComponentTypeNomal];
            [model setMessage:[SLKMessageViewController sampleMessages][index%[SLKMessageViewController sampleMessages].count]];
            [self.messages addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^(){
            [self.tableView reloadData];
            
        });
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SLKMessageComponent* message = self.messages[indexPath.row];
//    if(message.container.height 0) {
//        return message.height;
//    }
    
    return message.frame.size.height+[SLKMessageCell heightOffset];
//    return UITableViewAutomaticDimension;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//
    SLKMessageCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SLKMessageCell3"];
    
    if (!cell) {
        cell = [[SLKMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SLKMessageCell3"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.isAsync = self.isAsync;

    }
    

    
    SLKMessageComponent* message = self.messages[indexPath.row];
    
    cell.component = message;
    return cell;
}




@end
