//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Prashanth Reddy Kambalapally on 2/13/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "CardMatchingGame.h"


//Private Interface
@interface CardMatchingGame()
//Private property to keep track of the cards
@property (strong, nonatomic) NSMutableArray *cards;

//Private property to keep track of the last flipped cards
//@property (strong, nonatomic) NSMutableArray *flippedCards;

//Override the score's visibility
@property (nonatomic) int score;

//Also override the visibility of lastFlipPoints and previousFlippedCard
@property (nonatomic) int lastFlipPoints;
//@property(strong, nonatomic) Card* previousFlippedCard;
@property(strong, nonatomic) Card* currentFlippedCard;
//@property (strong, nonatomic) NSMutableArray *flippedCards;
//@property (strong, nonatomic) NSMutableArray *matchingFlippedCards;
//@property (strong, nonatomic) NSMutableArray *unMatchingFlippedCards;
@property(nonatomic) NSUInteger gameMode;
@property (strong, nonatomic) NSMutableArray *allFlippedCards;

@end
@implementation CardMatchingGame

//Lazy initialization of the cards
-(NSMutableArray *)cards
{
    if(!_cards)_cards = [[NSMutableArray alloc] init];
    return _cards;
}

//Lazy initialization of the flipped cards
//-(NSMutableArray *)flippedCards
//{
//    if(!_flippedCards)_flippedCards = [[NSMutableArray alloc] init];
//    return _flippedCards;
//}

//Designated Initializer
-(id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck andMatchMode:(NSUInteger)mode
{
    //Super class initializer
    self = [super init];

    //check for null
    if(self){
        //Loop through the specified count of cards
        for (int i=0; i<count; i++) {
            Card *card = [deck drawRandomCard];
            //Adding nil to an NSMutableArray will crash. So we return nil if we cannot properly initialize with the arguments passed.
            if(!card){
                self = nil;
            }else{
                self.cards[i]= card;
            }
        }//end for
        self.gameMode = mode;
    }//end check on self
    return self;
}

//CardAtIndex implementation. Checking for out of bounds.
-(Card *)cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count)? self.cards[index]:nil;
}

//To be able to scale the scoring
#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1 //charge for flipping

-(void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
//    NSLog(@"self.previousFlippedCard before for----@%@",self.previousFlippedCard.contents);
//    NSLog(@"card before for----@%@",card.contents);
    
    self.currentFlippedCard = card;
    
    //Get the card to flip and make sure it is playable.
    if(!card.isUnplayable){
        //If it is playable, flip the card.
        if(!card.isFaceUp){
            
            
            /* NOT NEEDED
             //If the previousFlippedCard is null, set it to the current card
            if(!self.previousFlippedCard){
                self.previousFlippedCard = card;
            }
             */
            //Reset the Array for each flip
            //self.unMatchingFlippedCards = [[NSMutableArray alloc] init];
            //self.matchingFlippedCards = [[NSMutableArray alloc] init];
            
            //Add the card to the flipped cards array
            //[self.flippedCards addObject:card];
            
            //For every flip, this is reset. But it stays put for all iterations of the deck...
            //coz there might be 3 cards that are played and all 3 might match, etc...
            //_lastFlipPoints = 0;//needed to do this if this wasn't overriden in the .m file
            self.lastFlipPoints = 0;
            self.currentFlippedCard = card;
            
            // This is Breaking ...so going back to loop
            //If we are matching only against the one previous card that was flipped face up, we don't need to loop through all the faceup cards. Also for the first time, previousFlippedCard is nil and so doesn't match.
            
            int matchScore = 0;
            if(self.previousFlippedCard){
                //At least one card has been flipped before this. So see if it matches current
                //But check to make sure the same card isn't flipped twice.
                if(self.previousFlippedCard != card){
                    matchScore = [card match:@[self.previousFlippedCard]];

                    if(matchScore){
                        self.previousFlippedCard.unplayable = YES;
                        card.unplayable = YES;
                        //self.previousFlippedCard = nil;
                        self.lastFlipPoints +=  MATCH_BONUS;
                        self.score +=  MATCH_BONUS;
                    }else{
                        self.lastFlipPoints -= MISMATCH_PENALTY;
                        self.score -= MISMATCH_PENALTY;
                    }
                }else{
                    //The same card has been flipped twice, so just ignore it.
                    //Don't put any score either, as we don't want any message if the card is back to facedown.
                    NSLog(@"Same card flipped twice");
                }
                
            }else{
                //Logic if this is the first card flipped or the card flipped after a match has been found
                self.lastFlipPoints = 0;
                NSLog(@"last flipped card is null");
            }
            
            
            //See if flipping this card up creates a match
            //Loop through other cards looking for a face up, playable card.
           /* for(Card *otherCard in self.cards){
                if(otherCard.isFaceUp
                   && !otherCard.isUnplayable){
                   //&& (otherCard == self.previousFlippedCard)){
                    
                    //Add the other card also to the flipped cards array
                    //We only need to maintain one other card...coz we only show the result of last flip
                    //We only need to store last flip and the current flipped cards
                    //[self.flippedCards addObject:otherCard ];
                    
                    //check to see if this matches
                    int matchScore = [card match:@[otherCard]];
                    
                    
                    //If it's a match, both cards become unplayable and we up our score
                    if(matchScore){
                        //[self.matchingFlippedCards addObject:otherCard.contents ];
                        otherCard.unplayable = YES;
                        card.unplayable = YES;
                        //self.score += matchScore * MATCH_BONUS;
                        //We also add the otherCard to the flipped cards array and update the lastFlip Count
                        self.lastFlipPoints += matchScore * MATCH_BONUS;
                        //Can update the score using last flip points.
                        //self.score += self.lastFlipPoints;
                        self.score += matchScore * MATCH_BONUS;
                    }else{
                        //Assess a penalty if the card doesn't match
                        //self.score -= MISMATCH_PENALTY;
                        // [self.unMatchingFlippedCards addObject:otherCard.contents ];
                        //If mismatch, then the penalty should be applied, and also the array updated
                        self.lastFlipPoints -= MISMATCH_PENALTY;
                        //Can update the score using last flip points.
                        //self.score -= self.lastFlipPoints;
                        self.score -= MISMATCH_PENALTY;
                    }
                }
            }//end for
            */
            
            //Whether it matches or not, the current card is flipped and for the next flip it will be the previousflippedcard
            //self.previousFlippedCard = card;
            
//            NSLog(@"self.score in model----@%d",self.score);
            NSLog(@"self.lastflippoints in model----@%d",self.lastFlipPoints);
//            //NSLog(@"self.previousFlippedCard in model----@%@",self.previousFlippedCard.contents);
//            NSLog(@"card in model----@%@",card.contents);
            //NSLog(@"unmatched----@%@",self.unMatchingFlippedCards);
            //NSLog(@"matched----@%@",self.matchingFlippedCards);
            
            //If the card is not already faceup and is playable, then charge the flip cost
            self.score -= FLIP_COST;
            //this shoiuld be subtracted from the lastFlipPoints too--no it shouldn't, as the score takes care of this.
            //self.lastFlipPoints -= FLIP_COST;
        }else{
            NSLog(@"self.previousFlippedCard in not faceup----@%@",self.previousFlippedCard.contents);
            NSLog(@"currentflipcard in notfaceup----@%@",self.currentFlippedCard.contents);
            //Set the previous flipped card to nil if the card is made facedown and 
            if((self.previousFlippedCard == self.currentFlippedCard)){
                self.previousFlippedCard = nil;
                self.currentFlippedCard = nil;
                //self.previousFlippedCard.isFaceUp
            }
        }//end check on card faceUp
        card.faceUp = !card.isFaceUp;
        
        //self.previousFlippedCard = card;
    }//end flipCardAtIndex
    
}
@end
