//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Daisuke Hirata on 2013/12/27.
//  Copyright (c) 2013年 Daisuke Hirata. All rights reserved.
//

#import "CardGameViewController.h"
#import "HistoryViewController.h"

@interface CardGameViewController ()
@end

@implementation CardGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    for (CardView *card in self.cardViews) {
        UITapGestureRecognizer *recognizer =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(tapPlayingCardView:)];
        [card addGestureRecognizer:recognizer];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"show History"]) {
        if ([segue.destinationViewController isKindOfClass:[HistoryViewController class]]) {
            HistoryViewController *hvc = (HistoryViewController *)segue.destinationViewController;
            NSMutableString *htext = [[NSMutableString alloc] init];
            for (NSString *con in self.game.considerationHistory) {
                [htext appendFormat:@"%@\n", con];
            }
            hvc.historyText = htext;
        }
    }
}

// abstract method. must override this.
- (Deck *)createDeck
{
    return nil;
}

- (void)tapPlayingCardView:(UITapGestureRecognizer *)sender {
    int chosenButtonIndex = [self.cardViews indexOfObject:sender.view];
    NSLog(@"%d tapped", chosenButtonIndex);
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}

- (IBAction)redealBarButton:(UIBarButtonItem *)sender {
    self.game = [[CardMatchingGame alloc] initWithCardCount:[self.cardViews count]
                                              usingDeck:[self createDeck]];
    [self updateUI];
}

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardViews count]
                                                          usingDeck:[self createDeck]];
    return _game;
}

// abstract method. must override this.
- (void)updateUI
{
}

- (NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

@end
