//
//  StartViewController.m
//  SlackMessageParser
//
//  Created by saix on 2017/10/9.
//  Copyright © 2017年 sai. All rights reserved.
//

#import "StartViewController.h"
#import "SLKMessageViewController.h"

@interface StartViewController ()

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StartCell"];
    
    if (indexPath.row==0) {
        cell.textLabel.text = @"Sync Display";
    }
    else {
        cell.textLabel.text = @"Async Display";
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SLKMessageViewController* vc = nil;
    if (indexPath.row==0) {
        vc = [[SLKMessageViewController alloc] initWithAsync:NO];
    }
    else {
        vc = [[SLKMessageViewController alloc] initWithAsync:YES];

    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
