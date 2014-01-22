//
//  JIRASettingsRepository.m
//  WorkTimer
//
//  Created by martin steel on 20/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import "SettingsRepository.h"

@implementation SettingsRepository

static sqlite3 *database = NULL;
static sqlite3_stmt *create_statement = NULL;
static sqlite3_stmt *count_tables_statement = NULL;
static sqlite3_stmt *count_statement = NULL;
static sqlite3_stmt *insert_statement = NULL;
static sqlite3_stmt *reset_statement = NULL;

static sqlite3_stmt *getMyUserName_statement = NULL;
static sqlite3_stmt *getServerPath_statement = NULL;
static sqlite3_stmt *getAuthenticationToken_statement = NULL;
static sqlite3_stmt *getParserType_statement = NULL;

static sqlite3_stmt *getSettings_statement = NULL;

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
        parserType = sqlite3_column_int(getParserType_statement, 3);
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

+ (NSString *) getMyUserName
{
    sqlite3 *db = Database();
    if (getMyUserName_statement == NULL) {
        static const char *sql = "SELECT UserName FROM Settings";
        if (sqlite3_prepare_v2(db, sql, -1, &getMyUserName_statement, NULL) != SQLITE_OK) {
            NSCAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
        }
    }

    int success = sqlite3_step(getMyUserName_statement);
    NSString* userName = @"";
    if (success == SQLITE_ROW) {
        userName = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(getMyUserName_statement, 0)];
    } else {
        NSCAssert1(0, @"Error: failed to execute query with message '%s'.", sqlite3_errmsg(db));
    }
    // Reset the query for the next use.
    sqlite3_reset(getMyUserName_statement);
    return userName;
}

//TODO refactor this method out so that tempo token is no longer used
+ (NSString *) getToken
{
    return @"c39f740a-69dd-4ccc-a21e-820ae0f9d7f2";
}

+ (NSString *) getServerPath
{
    sqlite3 *db = Database();
    if (getServerPath_statement == NULL) {
        static const char *sql = "SELECT ServerPath FROM Settings";
        if (sqlite3_prepare_v2(db, sql, -1, &getServerPath_statement, NULL) != SQLITE_OK) {
            NSCAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
        }
    }
    
    int success = sqlite3_step(getServerPath_statement);
    NSString* serverPath = @"";
    if (success == SQLITE_ROW) {
        serverPath = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(getServerPath_statement, 0)];
    } else {
        NSCAssert1(0, @"Error: failed to execute query with message '%s'.", sqlite3_errmsg(db));
    }
    // Reset the query for the next use.
    sqlite3_reset(getServerPath_statement);
    return serverPath;
}

+ (NSString *) getAuthenticationToken
{
    sqlite3 *db = Database();
    if (getAuthenticationToken_statement == NULL) {
        static const char *sql = "SELECT AuthenticationToken FROM Settings";
        if (sqlite3_prepare_v2(db, sql, -1, &getAuthenticationToken_statement, NULL) != SQLITE_OK) {
            NSCAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
        }
    }
    
    int success = sqlite3_step(getAuthenticationToken_statement);
    NSString* authToken = @"";
    if (success == SQLITE_ROW) {
        authToken = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(getAuthenticationToken_statement, 0)];
    } else {
        NSCAssert1(0, @"Error: failed to execute query with message '%s'.", sqlite3_errmsg(db));
    }
    // Reset the query for the next use.
    sqlite3_reset(getAuthenticationToken_statement);
    return authToken;
}

+ (NSInteger) getParserType
{
    sqlite3 *db = Database();
    if (getParserType_statement == NULL) {
        static const char *sql = "SELECT ParserType FROM Settings";
        if (sqlite3_prepare_v2(db, sql, -1, &getParserType_statement, NULL) != SQLITE_OK) {
            NSCAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
        }
    }
    
    int success = sqlite3_step(getParserType_statement);
    NSInteger parserType = 0;
    if (success == SQLITE_ROW) {
        parserType = sqlite3_column_int(getParserType_statement, 0);
    } else {
        NSCAssert1(0, @"Error: failed to execute query with message '%s'.", sqlite3_errmsg(db));
    }
    // Reset the query for the next use.
    sqlite3_reset(getParserType_statement);
    return parserType;
}

+ (void) saveSettings:(Settings*) settings
{
    NSCAssert2([NSThread isMainThread], @"%s at line %d called on secondary thread", __FUNCTION__, __LINE__);
    sqlite3 *db = Database();
    if (insert_statement == NULL) {
        static const char *sql = "INSERT INTO Settings (UserName, Password, ServerPath, ParserType, AuthenticationToken) VALUES(?, ?, ?, ?, ?)";
        if (sqlite3_prepare_v2(db, sql, -1, &insert_statement, NULL) != SQLITE_OK) {
            NSCAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
        }
    }
    
    const char *userNameChar = [settings.userName cStringUsingEncoding:NSASCIIStringEncoding];
    
    if (sqlite3_bind_text(insert_statement, 1, userNameChar, settings.userName.length, SQLITE_TRANSIENT) != SQLITE_OK)
    {
        NSCAssert1(0, @"Error: failed to bind variable with message '%s'.", sqlite3_errmsg(db));
    }
    
    const char *passwordChar = [settings.password cStringUsingEncoding:NSASCIIStringEncoding];
    
    if (sqlite3_bind_text(insert_statement, 2, passwordChar, settings.password.length, SQLITE_TRANSIENT) != SQLITE_OK)
    {
        NSCAssert1(0, @"Error: failed to bind variable with message '%s'.", sqlite3_errmsg(db));
    }
    
    const char *serverPath = [settings.serverPath cStringUsingEncoding:NSASCIIStringEncoding];
    
    if (sqlite3_bind_text(insert_statement, 3, serverPath, settings.serverPath.length, SQLITE_TRANSIENT) != SQLITE_OK)
    {
        NSCAssert1(0, @"Error: failed to bind variable with message '%s'.", sqlite3_errmsg(db));
    }
    
    if (sqlite3_bind_int(insert_statement, 4, settings.parserType) != SQLITE_OK) {
        NSCAssert1(0, @"Error: failed to bind variable with message '%s'.", sqlite3_errmsg(db));
    }
    
    const char *authenticationChar = [settings.authenticationToken cStringUsingEncoding:NSASCIIStringEncoding];
    
    if (sqlite3_bind_text(insert_statement, 5, authenticationChar, settings.authenticationToken.length, SQLITE_TRANSIENT) != SQLITE_OK)
    {
        NSCAssert1(0, @"Error: failed to bind variable with message '%s'.", sqlite3_errmsg(db));
    }
    
    int result = sqlite3_step(insert_statement);
    sqlite3_reset(insert_statement);
    if (result != SQLITE_DONE) {
        NSLog(@"%s: step error: %s (%d)", __FUNCTION__, sqlite3_errmsg(db), result);
        //NSCAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(db));
    }
}

+ (void) createSettingsTable:(sqlite3*) db
{   
    if (create_statement == NULL) {
        static const char *sql = "CREATE TABLE Settings (\
                                                             UserName TEXT NOT NULL,\
                                                             Password TEXT NOT NULL,\
                                                             ServerPath TEXT NOT NULL,\
                                                             ParserType INT NOT NULL,\
                                                             AuthenticationToken TEXT NOT NULL\
                                                         )";
        if (sqlite3_prepare_v2(db, sql, -1, &create_statement, NULL) != SQLITE_OK) {
            NSCAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
        }
    }

    sqlite3_step(create_statement);

    // Reset the query for the next use.
    sqlite3_reset(create_statement);
}

+ (BOOL) doesSettingsTableExist:(sqlite3*) db
{
    if (count_tables_statement == NULL) {
        // Prepare (compile) the SQL statement.
        static const char *sql = "SELECT COUNT(*) FROM sqlite_master WHERE type='table' AND name='Settings'";
        if (sqlite3_prepare_v2(db, sql, -1, &count_tables_statement, NULL) != SQLITE_OK) {
            NSCAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
        }
    }

    int success = sqlite3_step(count_tables_statement);
    NSUInteger numberOfRows = 0;
    if (success == SQLITE_ROW) {
        // Store the value of the first and only column for return.
        numberOfRows = sqlite3_column_int(count_tables_statement, 0);
    } else {
        NSCAssert1(0, @"Error: failed to execute query with message '%s'.", sqlite3_errmsg(db));
    }
    // Reset the query for the next use.
    sqlite3_reset(count_tables_statement);
    return numberOfRows>0;
}

+ (BOOL) doSettingsExist
{
    sqlite3 *db = Database();
    if (count_statement == NULL) {
        // Prepare (compile) the SQL statement.
        static const char *sql = "SELECT COUNT(*) FROM Settings";
        if (sqlite3_prepare_v2(db, sql, -1, &count_statement, NULL) != SQLITE_OK) {
            NSCAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
        }
    }
    
    int success = sqlite3_step(count_statement);
    NSUInteger numberOfRows = 0;
    if (success == SQLITE_ROW) {
        // Store the value of the first and only column for return.
        numberOfRows = sqlite3_column_int(count_statement, 0);
    } else {
        NSCAssert1(0, @"Error: failed to execute query with message '%s'.", sqlite3_errmsg(db));
    }
    // Reset the query for the next use.
    sqlite3_reset(count_statement);
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
    
    if(![SettingsRepository doesSettingsTableExist:database])
    {
        [SettingsRepository createSettingsTable:database];
    }
    
    return database;
}

// Close the database. This should be called when the application terminates.
+ (void) closeSettingsDatabase
{
    // Finalize (delete) all of the SQLite compiled queries.
    
    if (create_statement != NULL)
    {
        sqlite3_finalize(create_statement);
        create_statement = NULL;
    }
    if (count_tables_statement != NULL)
    {
        sqlite3_finalize(count_tables_statement);
        count_tables_statement = NULL;
    }
    if (insert_statement != NULL)
    {
        sqlite3_finalize(insert_statement);
        insert_statement = NULL;
    }
    if (getMyUserName_statement != NULL)
    {
        sqlite3_finalize(getMyUserName_statement);
        getMyUserName_statement = NULL;
    }
    if (getServerPath_statement != NULL)
    {
        sqlite3_finalize(getServerPath_statement);
        getServerPath_statement = NULL;
    }
    if (getAuthenticationToken_statement != NULL)
    {
        sqlite3_finalize(getAuthenticationToken_statement);
        getAuthenticationToken_statement = NULL;
    }
    if (getParserType_statement != NULL)
    {
        sqlite3_finalize(getParserType_statement);
        getParserType_statement = NULL;
    }
    
    if (database == NULL) return;
    
    // Close the database.
    if (sqlite3_close(database) != SQLITE_OK) {
        NSCAssert1(0, @"Error: failed to close database with message '%s'.", sqlite3_errmsg(database));
    }
    database = NULL;
}

+ (void) resetSettingsDatabase
{
    NSCAssert2([NSThread isMainThread], @"%s at line %d called on secondary thread", __FUNCTION__, __LINE__);
    sqlite3 *db = Database();
    if (reset_statement == NULL) {
        static const char *sql = "DROP TABLE IF Exists Settings";
        if (sqlite3_prepare_v2(db, sql, -1, &reset_statement, NULL) != SQLITE_OK) {
            NSCAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
        }
    }
    int success = sqlite3_step(reset_statement);
    if (success == SQLITE_ERROR) {
        NSCAssert1(0, @"Error: failed to execute query with message '%s'.", sqlite3_errmsg(db));
    }
    // Reset the query for the next use.
    sqlite3_reset(reset_statement);
}
@end
