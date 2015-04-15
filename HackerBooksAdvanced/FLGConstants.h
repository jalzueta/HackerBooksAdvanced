//
//  FLGConstants.h
//  HackerBooks
//
//  Created by Javi Alzueta on 15/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#pragma mark - Autosave
#define AUTO_SAVE NO
#define AUTO_SAVE_DELAY 30


#pragma mark - FLGBook JSON download
#define JSON_DOWNLOAD_URL @"https://t.co/K9ziV0z3SJ"
#define IS_MODEL_DOWNLOADED @"isModelDownloaded"

#pragma mark - FLGBook JSON parser
#define AUTHORS_KEY @"authors"
#define COVER_URL_KEY @"image_url"
#define PDF_URL_KEY @"pdf_url"
#define TAGS_KEY @"tags"
#define TITLE_KEY @"title"

#pragma mark - FLGLibrary
#define FAVOURITES_TAG @"favorites"

#pragma mark - Notifications
#define BOOK_DID_CHANGE_NOTIFICATION_NAME @"bookDidChange"
#define BOOK_DID_CHANGE_ITS_CONTENT_NOTIFICATION_NAME @"bookDidChangeItsContent"
#define BOOK_KEY @"book"

#pragma mark - NSUserDefaults
#define LAST_SELECTED_BOOK @"lastBook"

#pragma mark - Book
#define FAVOURITE_ON_IMAGE_NAME @"favourite_on.png"
#define FAVOURITE_OFF_IMAGE_NAME @"favourite_off.png"

#pragma mark - Colors
#define FAVOURITE_HEADER_COLOR [UIColor colorWithRed:77/255.0 green:173/255.0 blue:0/255.0 alpha:1.0]
#define CATHEGORY_HEADER_COLOR [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0]
#define SELECTED_CELL_BACKGROUND_COLOR [UIColor colorWithRed:235/255.0 green:255/255.0 blue:235/255.0 alpha:1.0]


