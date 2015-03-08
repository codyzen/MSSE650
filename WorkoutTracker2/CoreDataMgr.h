//
//  CoreDataMgr.h
//  WorkoutTracker2
//
//  Created by Cody McDonald on 3/1/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataMgr : NSObject

@property (atomic) NSManagedObjectContext *moc;

+(CoreDataMgr *) sharedInstance;
+(NSManagedObjectContext *) getContext;

@end
