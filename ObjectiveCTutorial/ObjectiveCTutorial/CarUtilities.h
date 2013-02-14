//
//  CarUtilities.h
//  ObjectiveCTutorial
//
//  Created by Prashanth Reddy Kambalapally on 2/10/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import <Foundation/Foundation.h>


NSString *CUGetRandomMake(NSArray *makes);
NSString *CUGetRandomModel(NSArray *models);
NSString *CUGetRandomMakeAndModel(NSDictionary *makesAndModels);
@interface CarUtilities : NSObject

@end
