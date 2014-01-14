//
//  HistoryViewController.m
//  Matchismo
//
//  Created by Daisuke Hirata on 2014/01/13.
//  Copyright (c) 2014年 Daisuke Hirata. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()
@property (weak, nonatomic) IBOutlet UITextView *historyTextView;
@end

@implementation HistoryViewController

- (void)setHistoryText:(NSString *)historyText
{
    _historyText = historyText;
    if (self.view.window) [self updateUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void)updateUI
{
    self.historyTextView.text = self.historyText;
}

@end
