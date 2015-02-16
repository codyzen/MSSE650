//
//  WorkoutSvcSQLite.m
//  WorkoutTracker2
//
//  Created by Cody McDonald on 2/12/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import "WorkoutSvcSQLite.h"

#import "sqlite3.h"

@implementation WorkoutSvcSQLite

//DB location
NSString *databasePath = nil;

//DB object
sqlite3 *database = nil;

//making WorkoutSvcSQLite a singleton
+ (WorkoutSvcSQLite *)sharedInstance {
    static WorkoutSvcSQLite *_singletonInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _singletonInstance = [[WorkoutSvcSQLite alloc] init];
    });
    return _singletonInstance;
}


//************************************
//* Methods for SQLite
//************************************

- (id) init{
    NSLog(@"WorkoutSvcSQLite::init -- Entering...");
    if ((self = [super init])) {
        //specify location of database
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [documentPaths objectAtIndex:0];
        //append DB name to path
        databasePath = [documentsDir stringByAppendingPathComponent:@"workout.sqlite3"];
        
        //open a connection to the database
        if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
            NSLog(@"WorkoutSvcSQLite::init -- database is open");
            NSLog(@"WorkoutSvcSQLite::init -- database file path: %@", databasePath);
            
            //***************************
            //check tables here
            sqlite3_stmt *statement;//
            //construct a statement in an NSString to return DB tables//
            //NSString *tablesSQL = @"SELECT * FROM sqlite_master where type='table'";//
            NSString *tablesSQL = @".tables";
            //compile and execute the statement and check to see that the DB is open
            if (sqlite3_prepare_v2(database, [tablesSQL UTF8String], -1, &statement, NULL) == SQLITE_OK){
                //tablesSQL statement compiled successfully
                if(sqlite3_step(statement) == SQLITE_DONE){
                    //tablesSQL statement evaluated successfully
                    NSMutableArray *tableArray;
                    while (sqlite3_step(statement) == SQLITE_ROW) {
                        //iterate through the returned records/rows
                        char *table = (char *)sqlite3_column_text(statement, 1);
                        //[tableArray addObject:table];
                        [tableArray addObject:[[NSString alloc] initWithUTF8String:table]];
                    }
                    NSLog(@"WorkoutSvcSQLite::init -- tables: %@", tableArray);
                } else {
                    NSLog(@"*** tableSQL statement not successful");
                    NSLog(@"*** SQL error: %s\n", sqlite3_errmsg(database));
                }
                //close the statement
                sqlite3_finalize(statement);
            }
            //*************************** end check tables
            
        }else{
            NSLog(@"*** Failed to open database!");
            NSLog(@"*** SQL error %s\n", sqlite3_errmsg(database));
        }
    }
    NSLog(@"WorkoutSvcSQLite::init -- Exiting...");
    return self;
}

- (void) dealloc {
    sqlite3_close(database);
}


//************************************
//* Implement WorkoutSvc CRUD methods
//************************************

- (Workout *) createWorkout:(Workout *)workout {
    
    NSLog(@"WorkoutSvcSQLite::createWorkout -- Entering...");
    NSLog(@"WorkoutSvcSQLite::createWorkout -- creating workout %@", workout.name);
    
    //TODO call retrieve all workouts into an array and get array count, for pre-creation count
    
    //check if workout name already exists in DB using helper method
    int index = [self findWorkout:workout];
    if (index != 99999999){
        //a workout by this name exists -- cannot create!
        NSLog(@"WorkoutSvcSQLite::createWorkout -- Workout already exists!!!");
        NSLog(@"WorkoutSvcSQLite::createWorkout -- Exiting...");
        return nil;
    }else {
        NSLog(@"WorkoutSvcSQLite::createWorkout -- workout name does NOT exist, creating workout...");
        //there was not a match, create workout by adding record
        sqlite3_stmt *statement;
        //construct a statement in an NSString including the SQL "insert" command
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO workout (name, location, category) VALUES (\"%@\", \"%@\", \"%@\")", workout.name, workout.location, workout.category];
    
        //compile and execute the statement and check to see that the DB is open
        if (sqlite3_prepare_v2(database, [insertSQL UTF8String], -1, &statement, NULL) == SQLITE_OK){
            //insert statement completed successfully
            if(sqlite3_step(statement) == SQLITE_DONE){
                //update the Workout with the "last insert id"
                workout.id = sqlite3_last_insert_rowid(database);
                NSLog(@"WorkoutSvcSQLite::createWorkout *** Workout added");
            } else {
                NSLog(@"*** Workout NOT added");
                NSLog(@"*** SQL error: %s\n", sqlite3_errmsg(database));
            }
        }
        //close the statement
        sqlite3_finalize(statement);
    }
    return workout;
}


- (NSMutableArray *) retrieveAllWorkouts{
    
    NSMutableArray *workouts = [NSMutableArray array];
    //construct a statement in an NSString including the SQL "select" command
    NSString *selectSQL = [NSString stringWithFormat:@"SELECT * FROM workout ORDER BY name"];
    sqlite3_stmt *statement;
    //compile and execute the statement and check to see that the DB is open
    if (sqlite3_prepare_v2(database, [selectSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        NSLog(@"*** WorkoutSvcSQLite::retrieveAllWorkouts -- Workouts retrieved");
        while (sqlite3_step(statement) == SQLITE_ROW) {
            //iterate through the returned records/rows
            int id = sqlite3_column_int(statement, 0);
            char *nameChars = (char *)sqlite3_column_text(statement, 1);
            char *locationChars = (char *)sqlite3_column_text(statement, 2);
            char *categoryChars = (char *)sqlite3_column_text(statement, 3);
            
            //construct a workout
            Workout *workout = [[Workout alloc] init];
            workout.id = id;
            workout.name = [[NSString alloc] initWithUTF8String:nameChars];
            workout.location = [[NSString alloc] initWithUTF8String:locationChars];
            workout.category = [[NSString alloc] initWithUTF8String:categoryChars];
            //update workouts array
            NSLog(@"*** workout: %@", workout.name);
            [workouts addObject:workout];
        
        }
        //close the statement
        sqlite3_finalize(statement);
    } else {
        NSLog(@"*** Workouts NOT retrieved");
        NSLog(@"*** SQL error: %s\n", sqlite3_errmsg(database));
    }
    
    return workouts;
}


- (Workout *) updateWorkout:(Workout *)workout{
    
    //construct a statement in an NSString including the SQL "update" command
    NSString *updateSQL = [NSString stringWithFormat:@"UPDATE workout SET name=\"%@\", location=\"%@\", category=\"%@\" WHERE id = %i ", workout.name, workout.location, workout.category, workout.id];
    sqlite3_stmt *statement;
    //compile and execute the statement and check to see that the DB is open
    if (sqlite3_prepare_v2(database, [updateSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"*** Workout updated");
        }else{
            NSLog(@"*** Workout NOT updated");
            NSLog(@"*** SQL error: %s\n", sqlite3_errmsg(database));
        }
        //close the statement
        sqlite3_finalize(statement);
    }
    
    return workout;
}


- (Workout *) deleteWorkout:(Workout *)workout{
    NSLog(@"WorkoutSvcSQLite::deleteWorkout -- Entering...");
    
    //construct a statement in an NSString including the SQL "update" command
    NSLog(@"workout to delete:  id=%d, name=%@", workout.id, workout.name);
    NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM workout WHERE id = %d", workout.id];
    NSLog(@"deleteSQL: %@", deleteSQL);
    sqlite3_stmt *statement;
    //compile and execute the statement and check to see that the DB is open
    if (sqlite3_prepare_v2(database, [deleteSQL UTF8String], -1, &statement, NULL) == SQLITE_OK){
        if (sqlite3_step(statement) == SQLITE_DONE){
            NSLog(@"*** Workout deleted");
        } else {
            NSLog(@"*** #1 -- Workout NOT deleted");
            NSLog(@"*** SQL error: %s\n", sqlite3_errmsg(database));
        }
        //close the statement
        sqlite3_finalize(statement);
    }else{
        NSLog(@"*** #2 -- Workout NOT deleted");
        NSLog(@"*** SQL error: %s\n", sqlite3_errmsg(database));
    }
    NSLog(@"WorkoutSvcSQLite::deleteWorkout -- Exiting...");
    return workout;
}


- (int) findWorkout:(Workout *)workout{
    NSLog(@"WorkoutSvcSQLite::findWorkout -- Entering...");
    //helper method to find specific workout in DB by name
    bool exists = false;
    int rowId = 99999999;
    //NSLog(@"WorkoutSvcSQLite::findWorkout -- workout to find: %@", workout.name);

    //construct a statement in an NSString to return DB tables
    NSString *wktName = workout.name;
    NSString *findSQL = [NSString stringWithFormat:@"SELECT name FROM workout WHERE name='%@'", wktName];
    //NSString *findSQL = @"SELECT * FROM workout";
    NSLog(findSQL);
    sqlite3_stmt *statement;
    
    //compile statement and check to see that the DB is open
    if (sqlite3_prepare_v2(database, [findSQL UTF8String], -1, &statement, NULL) == SQLITE_OK){
        //statement compiled successfully
        while (sqlite3_step(statement) == SQLITE_ROW) {
            //iterate through the returned records/rows
            
            //use column 0 because we only pulled back name attribute, not whole object
            NSString *tempName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            
            //this will handle nulls
            //NSString *tempName = ((char *)sqlite3_column_text(statement, 0)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)] : nil;             NSLog(@"tempName: %@", tempName);
            
            NSLog(@"temp: %@, wktName: %@", tempName, wktName);
            //NSLog(@"[tempName isEqualToString:wktName]: %d", ([tempName isEqualToString:wktName]));
            if([tempName isEqualToString:wktName]){
                //WORKOUT WITH THIS NAME EXISTS
                NSLog(@"*** WORKOUT WITH THIS NAME ALREADY EXISTS...");
                rowId = sqlite3_column_int(statement, 0);
                exists = true;
                break;
            }//if
        }//while
    } else {
        NSLog(@"*** findSQL execution failed...");
        NSLog(@"*** SQL error: %s\n", sqlite3_errmsg(database));
    }//if
    //close the statement
    sqlite3_finalize(statement);
        
    if(exists){//there was a match
        return rowId;
    }else{
        NSLog(@"WorkoutSvcSQLite::findWorkout -- Workout NOT found");
        return 99999999;
    }
}



@end
