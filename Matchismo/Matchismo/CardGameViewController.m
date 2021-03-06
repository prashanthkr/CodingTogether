//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Prashanth Reddy Kambalapally on 1/30/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "Card.h"
#import "CardMatchingGame.h"
#import "Utility.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
//@property(strong, nonatomic) Card* previousFlippedCard;
@property(strong, nonatomic) Card* currentFlippedCard;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;//view
@property (strong, nonatomic) CardMatchingGame  *game;//The game model
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;
- (IBAction)startNewGame:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UISegmentedControl *gameModeButton;
@property (nonatomic)NSUInteger gameMatchMode;//default value is 2.
@end

@implementation CardGameViewController

//Lazy initialize gameMatchMode
-(NSUInteger)gameMatchMode{
    if(!_gameMatchMode)_gameMatchMode = 2;//default value is 2 if button not clicked
    return _gameMatchMode;
}

-(UISegmentedControl*)gameModeButton{
    if(!_gameModeButton)_gameModeButton = [[UISegmentedControl alloc] init];
    [_gameModeButton setEnabled:YES forSegmentAtIndex:0];
    return _gameModeButton;

}
//Lazy instantiation
-(CardMatchingGame *)game
{
    
    //We are getting the count of card buttons from the view
    if(!_game)_game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                         usingDeck:[[PlayingCardDeck alloc] init]
                                                     andMatchMode: self.gameMatchMode ];
    return _game;
}

-(void) setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    for(UIButton * cardButton in _cardButtons){
        [cardButton setBackgroundImage:[UIImage imageNamed:@"card-back.png"] forState:UIControlStateNormal];
    }
}

//Updates the UI for every flip
-(void)updateUI
{
    //Just cycle through the card buttons getting the associated card from the CardMatchingGame
    for(UIButton *cardButton in self.cardButtons){
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        //Set the title for selectedstate. if contents don't change, this will do nothing
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        
        //If the card is both selected and disabled, then set the title to the card's contents
        //[cardButton setImage:nil forState:UIControlStateSelected | UIControlStateDisabled];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        
        //Card is selected only if it is face up.
        cardButton.Selected = card.isFaceUp;//IS OBJECTIVE C Case sensitive????
        
        //Make the card untappable if it is unplayable
        cardButton.enabled = !card.isUnplayable;
        
        //Make a disabled button semi-transparent using opaqueness property
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0; //1 fully opaque, 0.0 fully transparent
        
                
        //NSLog(@"matched---%@",[self.game.matchingFlippedCards componentsJoinedByString:@"-"]);
        //NSLog(@"unmatched---%@",[self.game.unMatchingFlippedCards componentsJoinedByString:@"-"]);
        //Update the matched elements and last flip count
        //self.matchedElementsLabel.text = [NSString stringWithFormat:@"Flipped %@\rMatched %@ \rUnmatched %@  Points:%d",card.contents, [self.game.matchingFlippedCards componentsJoinedByString:@"-"], [self.game.unMatchingFlippedCards componentsJoinedByString:@"-"], self.game.lastFlipPoints];
        [cardButton setBackgroundImage:[UIImage imageNamed:@"white_wall_hash.png"] forState:UIControlStateSelected];
        [cardButton setBackgroundImage:[UIImage imageNamed:@"white_wall_hash.png"] forState:UIControlStateDisabled];
    }//end for
     //Update the score
    self.scoreLabel.text = [NSString stringWithFormat:@"Score : %d", self.game.score];
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    //Update the resultString
    //self.resultsLabel.text = [Utility getResultString:self.game.lastFlipPoints forCurrentCardContents:self.game.currentFlippedCard.contents andPreviousCardContents:self.game.previousFlippedCard.contents];
    self.resultsLabel.text = self.game.resultString;

}//end updateUI



-(void)setFlipCount:(int)flipCount{
    _flipCount = flipCount;
    
}

- (IBAction)flipCard:(UIButton *)sender {
    //As soon as any card is flipped, the game mode control should be disabled
    [self.gameModeButton setEnabled:NO forSegmentAtIndex:0];
    [self.gameModeButton setEnabled:NO forSegmentAtIndex:1];
    
    
    //Flipping is now done by the CardMatchingGame
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    //NSLog(@"self.game.previousFlippedCard in controller before setting to current----@%@",self.game.previousFlippedCard.contents);
    //NSLog(@"current flippedcard address in controller before setting to current----@%@",self.game.currentFlippedCard.contents);
    self.flipCount++;
    
    //Go through all the flippedcards and remove those that are facedown
    NSMutableArray* cardsToRemove = [[NSMutableArray alloc] init];
    for(Card* flippedCard in self.game.allFlippedCards){
        if(!flippedCard.isFaceUp){
            [cardsToRemove addObject:flippedCard];
        }
    }//end for on allFlippedCards
    [self.game.allFlippedCards removeObjectsInArray:cardsToRemove];
    
    //Update the UI whenever the card gets flipped
    [self updateUI];
    
}

//Switches the game mode between 2 and 3 card matches
- (IBAction)switchGameMode:(id)sender {
    //Whenever the game mode is changed, the game has to be reset too
    self.game = nil;
    NSUInteger selectedIndex = [sender selectedSegmentIndex];
    if(selectedIndex == 0){
        self.gameMatchMode = 2;
    }else if (selectedIndex == 1){
        self.gameMatchMode = 3;
    }
    NSLog(@"game match mode---%d", self.gameMatchMode);
}//end switchGameMode


//Resets the game
- (IBAction)startNewGame:(UIButton *)sender {
    self.game = nil;
    self.flipCount=0;
    self.flipsLabel.text = @"Flips:0";
    self.scoreLabel.text=@"Score:0";
    [self updateUI];
    self.resultsLabel.text = @"Welcome!";
    //Re-enable the gamemode control
    [self.gameModeButton setEnabled:YES forSegmentAtIndex:0];
    [self.gameModeButton setEnabled:YES forSegmentAtIndex:1];
}



@end
