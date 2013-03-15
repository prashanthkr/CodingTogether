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

//Override the score's visibility
@property (nonatomic) int score;

//Also override the visibility of lastFlipPoints and flippedCards
@property (nonatomic) int lastFlipPoints;
//@property (strong, nonatomic) NSMutableArray *flippedCards;
@property (strong, nonatomic) NSMutableArray *matchingFlippedCards;
@property (strong, nonatomic) NSMutableArray *unMatchingFlippedCards;


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
-(id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
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
        }
    }
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
    
    //Get the card to flip and make sure it is playable.
    if(!card.isUnplayable){
        //If it is playable, flip the card.
        if(!card.isFaceUp){
            
            //Reset the Array for each flip
            self.unMatchingFlippedCards = [[NSMutableArray alloc] init];
            self.matchingFlippedCards = [[NSMutableArray alloc] init];
            
            //Add the card to the flipped cards array
            //[self.flippedCards addObject:card];
            
            //For every flip, this is reset. But it stays put for all iterations of the deck...
            //coz there might be 3 cards that are played and all 3 might match, etc...
            //_lastFlipPoints = 0;//needed to do this if this wasn't overriden in the .m file
            self.lastFlipPoints = 0;
            
            
            //See if flipping this card up creates a match
            //Loop through other cards looking for a face up, playable card.
            for(Card *otherCard in self.cards){
                if(otherCard.isFaceUp && !otherCard.isUnplayable){
                    
                    //Add the other card also to the flipped cards array
                    //We only need to maintain one other card...coz we only show the result of last flip
                    //We only need to store last flip and the current flipped cards
                    //[self.flippedCards addObject:otherCard ];
                    
                    //check to see if this matches
                    int matchScore = [card match:@[otherCard]];
                    
                    //If it's a match, both cards become unplayable and we up our score
                    if(matchScore){
                        [self.matchingFlippedCards addObject:otherCard.contents ];
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
                        [self.unMatchingFlippedCards addObject:otherCard.contents ];
                        //If mismatch, then the penalty should be applied, and also the array updated
                        self.lastFlipPoints -= MISMATCH_PENALTY;
                        //Can update the score using last flip points.
                        //self.score -= self.lastFlipPoints;
                        self.score -= MISMATCH_PENALTY;
                    }
                }
            }//end for
             //NSLog(@"self.score----@%d",self.score);
            //NSLog(@"self.lastflippoints----@%d",self.lastFlipPoints);
            //NSLog(@"unmatched----@%@",self.unMatchingFlippedCards);
            //NSLog(@"matched----@%@",self.matchingFlippedCards);
             //If the card is not already faceup and is playable, then charge the flip cost
            self.score -= FLIP_COST;
            //this shoiuld be added to the lastFlipPoints too
            self.lastFlipPoints -= FLIP_COST;
        }//end check on card faceUp
        card.faceUp = !card.isFaceUp;
    }
}
@end
