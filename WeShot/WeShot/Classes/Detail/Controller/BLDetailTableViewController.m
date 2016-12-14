//
//  BLDetailTableViewController.m
//  WeShot
//
//  Created by bo LI on 12/14/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import "BLDetailTableViewController.h"
#import "BLDetailContentCell.h"
#import "BLDetailCommentCell.h"

@interface BLDetailTableViewController ()

@end

@implementation BLDetailTableViewController

static NSString* headercellID = @"BLDetailContentCell";
static NSString* commentCellID = @"BLDetailCommentCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    self.navigationItem.title = @"SHOT";
}

- (void) setupTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = BLGlobalBg;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1 + 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        BLDetailContentCell* cell = [tableView dequeueReusableCellWithIdentifier:headercellID];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:headercellID owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        return cell;
    }
    BLDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellID];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:commentCellID owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return ScreenSize.width + 210;
    }
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
