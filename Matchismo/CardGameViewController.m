//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Daisuke Hirata on 2013/12/27.
//  Copyright (c) 2013年 Daisuke Hirata. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "CardMatchingGame.h"
#import "PlayingCardView.h"
#import "HistoryViewController.h"

@interface CardGameViewController ()
@property (nonatomic, strong) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(PlayingCardView) NSArray *playingCardViews;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastConsiderationLabel;
@end

@implementation CardGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    for (PlayingCardView *card in self.playingCardViews) {
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

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.playingCardViews count]
                                                          usingDeck:[self createDeck]];
    return _game;
}

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (void)tapPlayingCardView:(UITapGestureRecognizer *)sender {
    int chosenButtonIndex = [self.playingCardViews indexOfObject:sender.view];
    NSLog(@"%d tapped", chosenButtonIndex);
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}

- (IBAction)redealBarButton:(UIBarButtonItem *)sender {
    self.game = [[CardMatchingGame alloc] initWithCardCount:[self.playingCardViews count]
                                              usingDeck:[self createDeck]];
    self.game.threeCardsMode = NO;
    [self updateUI];
}

- (void)updateUI
{
    
    for (PlayingCardView *cardView in self.playingCardViews) {
        int cardViewIndex = [self.playingCardViews indexOfObject:cardView];
        PlayingCard *card = (PlayingCard *)[self.game cardAtIndex:cardViewIndex];
        cardView.rank = card.rank;
        cardView.suit = card.suit;
        cardView.faceUp = card.isChosen;
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.lastConsiderationLabel.text = self.game.lastConsideration;
    self.lastConsiderationLabel.alpha = 1;
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
