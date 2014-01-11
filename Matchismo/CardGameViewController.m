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

@interface CardGameViewController ()
@property (nonatomic, strong) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(PlayingCardView) NSArray *playingCardViews;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchModeSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *lastConsiderationLabel;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
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
    self.matchModeSegmentedControl.enabled = NO;
    [self updateUI];
}

- (IBAction)redealButton:(UIButton *)sender {
    self.game = [[CardMatchingGame alloc] initWithCardCount:[self.playingCardViews count]
                                              usingDeck:[self createDeck]];
    self.game.threeCardsMode = [self.matchModeSegmentedControl selectedSegmentIndex] == 1 ? YES : NO;
    self.matchModeSegmentedControl.enabled = YES;
    [self updateUI];
}

- (IBAction)changeMatchModeSegmentedControl:(UISegmentedControl *)sender {
    self.game.threeCardsMode = [self.matchModeSegmentedControl selectedSegmentIndex] == 1 ? YES : NO;
}

- (IBAction)changeHistorySlider:(UISlider *)sender {
    self.lastConsiderationLabel.text = [self.game.considerationHistory objectAtIndex:(int)sender.value];
    self.lastConsiderationLabel.alpha = 0.4;
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
    self.historySlider.maximumValue = [self.game.considerationHistory count] - 1;
    self.historySlider.value = self.historySlider.maximumValue;
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
