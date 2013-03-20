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

@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeButton;
@property (nonatomic)NSUInteger gameMatchMode;
@end

@implementation CardGameViewController



-(void)setGameModeButton:(UISegmentedControl *)gameModeButton{
    
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

}

//Updates the UI for every flip
-(void)updateUI
{
    //Just cycle through the card buttons getting the associated card from the CardMatchingGame
    for(UIButton *cardButton in self.cardButtons){
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        //Set the title for selectedstate. if contents don't change, this will do nothing
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        
        //If the card is both selected and disabled, then set the title to teh card's contents
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
        
        
    }//end for
     //Update the score
    self.scoreLabel.text = [NSString stringWithFormat:@"Score : %d", self.game.score];
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    //Update the resultString
    self.resultsLabel.text = [Utility getResultString:self.game.lastFlipPoints forCurrentCardContents:self.game.currentFlippedCard.contents andPreviousCardContents:self.game.previousFlippedCard.contents];

}//end updateUI



-(void)setFlipCount:(int)flipCount{
    _flipCount = flipCount;
    
}

- (IBAction)flipCard:(UIButton *)sender {
    //Flipping is now done by the CardMatchingGame
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    NSLog(@"self.game.previousFlippedCard in controller before setting to current----@%@",self.game.previousFlippedCard.contents);
    NSLog(@"current flippedcard address in controller before setting to current----@%@",self.game.currentFlippedCard.contents);
    self.flipCount++;
    
    //Update the UI whenever the card gets flipped
    [self updateUI];
    //Set the previousFlippedCard only if it isn't the same card flipped twice
    /*if((self.game.previousFlippedCard != [self.game cardAtIndex:[self.cardButtons indexOfObject:sender]])
){
        self.game.previousFlippedCard = [self.game cardAtIndex:[self.cardButtons indexOfObject:sender]];
    }
     */
    if(self.game.previousFlippedCard != self.game.currentFlippedCard ){
        self.game.previousFlippedCard = self.game.currentFlippedCard;
        if(self.game.previousFlippedCard.isUnplayable && self.game.currentFlippedCard.isUnplayable){
            self.game.previousFlippedCard = nil;
        }//end inner if
    }
    NSLog(@"self.game.previousFlippedCard in controller after updating UI----@%@",self.game.previousFlippedCard.contents);
}

//Switches the game mode between 2 and 3 card matches
- (IBAction)switchGameMode:(id)sender {
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
}



@end
