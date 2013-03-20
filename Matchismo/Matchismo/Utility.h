//
//  Utility.h
//  Matchismo
//
//  Created by Prashanth Reddy Kambalapally on 3/16/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject
+(NSString *)getResultString:(int)flipPoints
      forCurrentCardContents:(NSString *)currentCardContents
     andPreviousCardContents:(NSString *)previousCardContents;
@end
