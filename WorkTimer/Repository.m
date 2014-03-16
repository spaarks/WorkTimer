//
//  JIRASettingsRepository.m
//  WorkTimer
//
//  Created by martin steel on 20/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import "Repository.h"

@implementation Repository

static sqlite3 *database = NULL;
static sqlite3_stmt *create_settings_statement = NULL;
static sqlite3_stmt *create_worktimertask_statement = NULL;

static sqlite3_stmt *count_settings_table_statement = NULL;
static sqlite3_stmt *count_worktimertask_table_statement=NULL;

static sqlite3_stmt *count_settings_statement = NULL;

static sqlite3_stmt *insert_settings_statement = NULL;
static sqlite3_stmt *insert_work_timer_task_statement = NULL;

static sqlite3_stmt *reset_settings_statement = NULL;
static sqlite3_stmt *reset_worktimertasks_statement = NULL;

static sqlite3_stmt *getSettings_statement = NULL;
static sqlite3_stmt *getWorkTimerTasks_statement = NULL;

+ (Settings*) getSettings
{
    sqlite3 *db = Database();
    if (getSettings_statement == NULL) {
        static const char *sql = "SELECT * FROM Settings";
        if (sqlite3_prepare_v2(db, sql, -1, &getSettings_statement, NULL) != SQLITE_OK) {
            NSCAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
        }
    }
    
    int success = sqlite3_step(getSettings_statement);
    NSString* userName = @"";
    NSString* password = @"";
    NSString* serverPath = @"";
    NSString* authToken = @"";
    NSInteger parserType = 0;
    
    if (success == SQLITE_ROW) {
        userName = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(getSettings_statement, 0)];
        password = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(getSettings_statement, 1)];
        serverPath = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(getSettings_statement, 2)];
        parserType = sqlite3_column_int(getSettings_statement, 3);
        authToken = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(getSettings_statement, 4)];
    } else {
        NSCAssert1(0, @"Error: failed to execute query with message '%s'.", sqlite3_errmsg(db));
    }
    // Reset the query for the next use.
    sqlite3_reset(getSettings_statement);
    
    Settings* currentSettings = [[Settings alloc] init];
    currentSettings.userName = userName;
    currentSettings.password = password;
    currentSettings.serverPath = serverPath;
    currentSettings.authenticationToken = authToken;
    currentSettings.parserType = parserType;
    
    return currentSettings;
}

+ (WorkTimerTask*) getWorkTimerTask
{
    sqlite3 *db = Database();
    if (getWorkTimerTasks_statement == NULL) {
        static const char *sql = "SELECT * FROM WorkTimerTask";
        if (sqlite3_prepare_v2(db, sql, -1, &getWorkTimerTasks_statement, NULL) != SQLITE_OK) {
            NSCAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
        }
    }
    
    int success = sqlite3_step(getWorkTimerTasks_statement);
    NSString* taskID = @"";
    NSString* taskKey = @"";
    NSString* taskSummary = @"";
    NSString* taskDescription = @"";
    NSString* timeWorked = @"";
    
    if (success == SQLITE_ROW) {
        taskID = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(getWorkTimerTasks_statement, 0)];
        taskKey = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(getWorkTimerTasks_statement, 1)];
        taskSummary = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(getWorkTimerTasks_statement, 2)];
        taskDescription = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(getWorkTimerTasks_statement, 3)];
        timeWorked = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(getWorkTimerTasks_statement, 4)];
    } else {
        NSCAssert1(0, @"Error: failed to execute query with message '%s'.", sqlite3_errmsg(db));
    }
    // Reset the query for the next use.
    sqlite3_reset(getWorkTimerTasks_statement);
    
    WorkTimerTask *taskToEdit = [[WorkTimerTask alloc] init];
    taskToEdit.taskID = taskID;
    taskToEdit.taskKey = taskKey;
    taskToEdit.taskSummary = taskSummary;
    taskToEdit.taskDescription = taskDescription;
    taskToEdit.timeWorked = timeWorked;
    
    return taskToEdit;
}


+ (void) saveSettings:(Settings*) settings
{
    NSCAssert2([NSThread isMainThread], @"%s at line %d called on secondary thread", __FUNCTION__, __LINE__);
    sqlite3 *db = Database();
    if (insert_settings_statement == NULL) {
        static const char *sql = "INSERT INTO Settings (UserName, Password, ServerPath, ParserType, AuthenticationToken) VALUES(?, ?, ?, ?, ?)";
        if (sqlite3_prepare_v2(db, sql, -1, &insert_settings_statement, NULL) != SQLITE_OK) {
            NSCAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
        }
    }
    
    const char *userNameChar = [settings.userName cStringUsingEncoding:NSASCIIStringEncoding];
    
    if (sqlite3_bind_text(insert_settings_statement, 1, userNameChar, (int)settings.userName.length, SQLITE_TRANSIENT) != SQLITE_OK)
    {
        NSCAssert1(0, @"Error: failed to bind variable with message '%s'.", sqlite3_errmsg(db));
    }
    
    const char *passwordChar = [settings.password cStringUsingEncoding:NSASCIIStringEncoding];
    
    if (sqlite3_bind_text(insert_settings_statement, 2, passwordChar, (int)settings.password.length, SQLITE_TRANSIENT) != SQLITE_OK)
    {
        NSCAssert1(0, @"Error: failed to bind variable with message '%s'.", sqlite3_errmsg(db));
    }
    
    const char *serverPath = [settings.serverPath cStringUsingEncoding:NSASCIIStringEncoding];
    
    if (sqlite3_bind_text(insert_settings_statement, 3, serverPath, (int)settings.serverPath.length, SQLITE_TRANSIENT) != SQLITE_OK)
    {
        NSCAssert1(0, @"Error: failed to bind variable with message '%s'.", sqlite3_errmsg(db));
    }
    
    if (sqlite3_bind_int(insert_settings_statement, 4, (int)settings.parserType) != SQLITE_OK) {
        NSCAssert1(0, @"Error: failed to bind variable with message '%s'.", sqlite3_errmsg(db));
    }
    
    const char *authenticationChar = [settings.authenticationToken cStringUsingEncoding:NSASCIIStringEncoding];
    
    if (sqlite3_bind_text(insert_settings_statement, 5, authenticationChar, (int)settings.authenticationToken.length, SQLITE_TRANSIENT) != SQLITE_OK)
    {
        NSCAssert1(0, @"Error: failed to bind variable with message '%s'.", sqlite3_errmsg(db));
    }
    
    int result = sqlite3_step(insert_settings_statement);
    sqlite3_reset(insert_settings_statement);
    if (result != SQLITE_DONE) {
        NSLog(@"%s: step error: %s (%d)", __FUNCTION__, sqlite3_errmsg(db), result);
        //NSCAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(db));
    }
}

+ (void) saveWorkTimerTask:(WorkTimerTask*) workTimerTask
{
    NSCAssert2([NSThread isMainThread], @"%s at line %d called on secondary thread", __FUNCTION__, __LINE__);
    sqlite3 *db = Database();
    if (insert_work_timer_task_statement == NULL) {
        static const char *sql = "INSERT INTO WorkTimerTask (TaskID, TaskKey, TaskSummary, taskDescription, TimeWorked) VALUES(?, ?, ?, ?, ?)";
        if (sqlite3_prepare_v2(db, sql, -1, &insert_work_timer_task_statement, NULL) != SQLITE_OK) {
            NSCAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
        }
    }
    
    const char *taskIDChar = [workTimerTask.taskID cStringUsingEncoding:NSASCIIStringEncoding];
    
    if (sqlite3_bind_text(insert_work_timer_task_statement, 1, taskIDChar, (int)workTimerTask.taskID.length, SQLITE_TRANSIENT) != SQLITE_OK)
    {
        NSCAssert1(0, @"Error: failed to bind variable with message '%s'.", sqlite3_errmsg(db));
    }
    
    const char *taskKeyChar = [workTimerTask.taskKey cStringUsingEncoding:NSASCIIStringEncoding];
    
    if (sqlite3_bind_text(insert_work_timer_task_statement, 2, taskKeyChar, (int)workTimerTask.taskKey.length, SQLITE_TRANSIENT) != SQLITE_OK)
    {
        NSCAssert1(0, @"Error: failed to bind variable with message '%s'.", sqlite3_errmsg(db));
    }
    
    const char *taskSummaryChar = [workTimerTask.taskSummary cStringUsingEncoding:NSASCIIStringEncoding];
    
    if (sqlite3_bind_text(insert_work_timer_task_statement, 3, taskSummaryChar, (int)workTimerTask.taskSummary.length, SQLITE_TRANSIENT) != SQLITE_OK)
    {
        NSCAssert1(0, @"Error: failed to bind variable with message '%s'.", sqlite3_errmsg(db));
    }
    
    const char *decriptionChar = [workTimerTask.taskDescription cStringUsingEncoding:NSASCIIStringEncoding];
    
    if (sqlite3_bind_text(insert_work_timer_task_statement, 4, decriptionChar, (int)workTimerTask.taskDescription.length, SQLITE_TRANSIENT) != SQLITE_OK)
    {
        NSCAssert1(0, @"Error: failed to bind variable with message '%s'.", sqlite3_errmsg(db));
    }
    
    const char *timeWorkedChar = [workTimerTask.timeWorked cStringUsingEncoding:NSASCIIStringEncoding];
    
    if (sqlite3_bind_text(insert_work_timer_task_statement, 5, timeWorkedChar, (int)workTimerTask.timeWorked.length, SQLITE_TRANSIENT) != SQLITE_OK)
    {
        NSCAssert1(0, @"Error: failed to bind variable with message '%s'.", sqlite3_errmsg(db));
    }
    
    int result = sqlite3_step(insert_work_timer_task_statement);
    sqlite3_reset(insert_work_timer_task_statement);
    if (result != SQLITE_DONE) {
        NSLog(@"%s: step error: %s (%d)", __FUNCTION__, sqlite3_errmsg(db), result);
        //NSCAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(db));
    }
}

+ (void) createSettingsTable:(sqlite3*) db
{   
    if (create_settings_statement == NULL) {
        static const char *sql = "CREATE TABLE Settings (\
                                                             UserName TEXT NOT NULL,\
                                                             Password TEXT NOT NULL,\
                                                             ServerPath TEXT NOT NULL,\
                                                             ParserType INT NOT NULL,\
                                                             AuthenticationToken TEXT NOT NULL\
                                                         )";
        if (sqlite3_prepare_v2(db, sql, -1, &create_settings_statement, NULL) != SQLITE_OK) {
            NSCAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
        }
    }

    sqlite3_step(create_settings_statement);

    // Reset the query for the next use.
    sqlite3_reset(create_settings_statement);
}

+ (void) createWorkTimerTaskTable:(sqlite3*) db
{
    if (create_worktimertask_statement == NULL) {
        static const char *sql = "CREATE TABLE WorkTimerTask (\
        TaskID TEXT NOT NULL,\
        TaskKey TEXT NOT NULL,\
        TaskSummary TEXT NOT NULL,\
        TaskDescription TEXT NOT NULL,\
        TimeWorked TEXT NOT NULL\
        )";
        
        if (sqlite3_prepare_v2(db, sql, -1, &create_worktimertask_statement, NULL) != SQLITE_OK) {
            NSCAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
        }
    }
    
    sqlite3_step(create_worktimertask_statement);
    
    // Reset the query for the next use.
    sqlite3_reset(create_worktimertask_statement);
}

+ (BOOL) doesSettingsTableExist:(sqlite3*) db
{
    if (count_settings_table_statement == NULL) {
        // Prepare (compile) the SQL statement.
        static const char *sql = "SELECT COUNT(*) FROM sqlite_master WHERE type='table' AND name='Settings'";
        if (sqlite3_prepare_v2(db, sql, -1, &count_settings_table_statement, NULL) != SQLITE_OK) {
            NSCAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
        }
    }

    int success = sqlite3_step(count_settings_table_statement);
    NSUInteger numberOfRows = 0;
    if (success == SQLITE_ROW) {
        // Store the value of the first and only column for return.
        numberOfRows = sqlite3_column_int(count_settings_table_statement, 0);
    } else {
        NSCAssert1(0, @"Error: failed to execute query with message '%s'.", sqlite3_errmsg(db));
    }
    // Reset the query for the next use.
    sqlite3_reset(count_settings_table_statement);
    return numberOfRows>0;
}

+ (BOOL) doesWorkTimerTaskTableExist:(sqlite3*) db
{
    if (count_worktimertask_table_statement == NULL) {
        // Prepare (compile) the SQL statement.
        static const char *sql = "SELECT COUNT(*) FROM sqlite_master WHERE type='table' AND name='WorkTimerTask'";
        if (sqlite3_prepare_v2(db, sql, -1, &count_worktimertask_table_statement, NULL) != SQLITE_OK) {
            NSCAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
        }
    }
    
    int success = sqlite3_step(count_worktimertask_table_statement);
    NSUInteger numberOfRows = 0;
    if (success == SQLITE_ROW) {
        // Store the value of the first and only column for return.
        numberOfRows = sqlite3_column_int(count_worktimertask_table_statement, 0);
    } else {
        NSCAssert1(0, @"Error: failed to execute query with message '%s'.", sqlite3_errmsg(db));
    }
    // Reset the query for the next use.
    sqlite3_reset(count_worktimertask_table_statement);
    return numberOfRows>0;
}

+ (BOOL) doSettingsExist
{
    sqlite3 *db = Database();
    if (count_settings_statement == NULL) {
        // Prepare (compile) the SQL statement.
        static const char *sql = "SELECT COUNT(*) FROM Settings";
        if (sqlite3_prepare_v2(db, sql, -1, &count_settings_statement, NULL) != SQLITE_OK) {
            NSCAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
        }
    }
    
    int success = sqlite3_step(count_settings_statement);
    NSUInteger numberOfRows = 0;
    if (success == SQLITE_ROW) {
        // Store the value of the first and only column for return.
        numberOfRows = sqlite3_column_int(count_settings_statement, 0);
    } else {
        NSCAssert1(0, @"Error: failed to execute query with message '%s'.", sqlite3_errmsg(db));
    }
    // Reset the query for the next use.
    sqlite3_reset(count_settings_statement);
    return numberOfRows>0;
}

// Returns a reference to the database, creating and opening if necessary.
sqlite3 *Database(void)
{
    if (database == NULL)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"settings.sqlite"];

        // Open the database. The database was prepared outside the application.
        if (sqlite3_open([writableDBPath UTF8String], &database) != SQLITE_OK) {
            // Even though the open failed, call close to properly clean up resources.
            sqlite3_close(database);
            database = NULL;
            NSCAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
            // Additional error handling, as appropriate...
        }
    }
    
    if(![Repository doesSettingsTableExist:database])
    {
        [Repository createSettingsTable:database];
    }
    
    if(![Repository doesWorkTimerTaskTableExist:database])
    {
        [Repository createWorkTimerTaskTable:database];
    }
    
    return database;
}

+ (void)deleteStatement:(sqlite3_stmt*) statement
{
    if (statement != NULL)
    {
        sqlite3_finalize(statement);
        statement = NULL;
    }
}

// Close the database. This should be called when the application terminates.
+ (void) closeSettingsDatabase
{
    [self deleteStatement:create_settings_statement];
    [self deleteStatement:count_settings_table_statement];
    [self deleteStatement:insert_settings_statement];
    [self deleteStatement:count_settings_statement];
    
    [self deleteStatement:create_worktimertask_statement];
    [self deleteStatement:count_worktimertask_table_statement];
    [self deleteStatement:insert_work_timer_task_statement];
    
    [self deleteStatement:reset_settings_statement];
    [self deleteStatement:reset_worktimertasks_statement];
    
    [self deleteStatement:getSettings_statement];
    [self deleteStatement:getWorkTimerTasks_statement];

    if (database == NULL) return;
    
    // Close the database.
    if (sqlite3_close(database) != SQLITE_OK) {
        NSCAssert1(0, @"Error: failed to close database with message '%s'.", sqlite3_errmsg(database));
    }
    database = NULL;
}

+ (void) resetDatabase
{
    NSCAssert2([NSThread isMainThread], @"%s at line %d called on secondary thread", __FUNCTION__, __LINE__);
    sqlite3 *db = Database();
    if (reset_settings_statement == NULL) {
        static const char *sql = "DROP TABLE IF Exists Settings";
        if (sqlite3_prepare_v2(db, sql, -1, &reset_settings_statement, NULL) != SQLITE_OK) {
            NSCAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
        }
    }
    int success = sqlite3_step(reset_settings_statement);
    if (success == SQLITE_ERROR) {
        NSCAssert1(0, @"Error: failed to drop Settings table with message '%s'.", sqlite3_errmsg(db));
    }
    // Reset the query for the next use.
    sqlite3_reset(reset_settings_statement);
    
    if (reset_worktimertasks_statement == NULL) {
        static const char *sql = "DROP TABLE IF Exists WorkTimerTask";
        if (sqlite3_prepare_v2(db, sql, -1, &reset_worktimertasks_statement, NULL) != SQLITE_OK) {
            NSCAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
        }
    }
    success = sqlite3_step(reset_worktimertasks_statement);
    if (success == SQLITE_ERROR) {
        NSCAssert1(0, @"Error: failed to drop WorkTimerTasks table with message '%s'.", sqlite3_errmsg(db));
    }
    // Reset the query for the next use.
    sqlite3_reset(reset_worktimertasks_statement);
}
@end
