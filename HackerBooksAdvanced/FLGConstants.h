//
//  FLGConstants.h
//  HackerBooks
//
//  Created by Javi Alzueta on 15/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#pragma mark - Autosave
#define AUTO_SAVE YES
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
#define COVER_KEY @"cover"
#define COVER_DID_CHANGE_NOTIFICATION @"coverDidChange"
#define PDF_KEY @"pdf"
#define PDF_DID_CHANGE_NOTIFICATION @"pdfDidChange"
#define BOOK_KEY @"book"
#define BOOK_DID_CHANGE_NOTIFICATION @"bookDidChange"
#define BOOK_DID_CHANGE_COVER_NOTIFICATION @"bookDidChangeCover"
#define BOOK_DID_CHANGE_PDF_NOTIFICATION @"bookDidChangePdf"
#define BOOK_DID_CHANGE_FAVORITE_STATE_NOTIFICATION @"BookDidChangeFavoriteState"

#pragma mark - NSUserDefaults
#define LAST_SELECTED_BOOK_ARCHIVED_URI @"lastBookArchivedUri"

#pragma mark - Book
#define FAVOURITE_ON_IMAGE_NAME @"favourite_on.png"
#define FAVOURITE_OFF_IMAGE_NAME @"favourite_off.png"

#define PHOTO_DID_CHANGE_PHOTO @"photoDidChangePhoto"
#define PHOTO_KEY @"photo"

#define ANNOTATION_DID_CHANGE_ITS_CONTENT_NOTIFICATION @"annotationDidChangeItsContent"
#define ANNOTATION_KEY @"annotation"

#pragma mark - Colors
#define FAVOURITE_HEADER_COLOR [UIColor colorWithRed:77/255.0 green:173/255.0 blue:0/255.0 alpha:1.0]
#define CATHEGORY_HEADER_COLOR [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0]
#define SELECTED_CELL_BACKGROUND_COLOR [UIColor colorWithRed:235/255.0 green:255/255.0 blue:235/255.0 alpha:1.0]

#pragma mark - Picture Date Picker
#define CAMERA @"camera"
#define ROLL @"roll"
#define ALBUM @"album"


