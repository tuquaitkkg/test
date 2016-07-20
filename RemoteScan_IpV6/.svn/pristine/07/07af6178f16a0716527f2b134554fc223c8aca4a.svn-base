#import "PrintPictManager.h"

@implementation PrintPictManager

/**
 @brief 両面印刷が出来る用紙サイズか判定
 */
+ (BOOL)checkCanDuplexPaperSize:(NSString*)strPaperSize {
    
    if ([strPaperSize isEqualToString:S_PRINT_PAPERSIZE_A3]
        || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_A3]
        || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_A4]
        || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_A5]
        || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_B4]
        || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_B5]
        || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_LEDGER]
        || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_LETTER]
        || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_LEGAL]
        || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_INVOICE]
        || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_FOOLSCAP]
        || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_CHINESE8K]
        || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_CHINESE16K]) {
        
        return YES;
        
    }
    return NO;
    
}

/**
 @brief 両面印刷ができる用紙タイプか判定
 */
+ (BOOL)checkCanDuplexPaperType:(NSString*)strPaperType {
    
    if ([strPaperType isEqualToString:S_PRINT_PAPERTYPE_AUTOSELECT]
        || [strPaperType isEqualToString:S_PRINT_PAPERTYPE_PLAIN]
        || [strPaperType isEqualToString:S_PRINT_PAPERTYPE_LETTERHEAD]
        || [strPaperType isEqualToString:S_PRINT_PAPERTYPE_PREPRINTED]
        || [strPaperType isEqualToString:S_PRINT_PAPERTYPE_PREPUNCHED]
        || [strPaperType isEqualToString:S_PRINT_PAPERTYPE_RECYCLED]
        || [strPaperType isEqualToString:S_PRINT_PAPERTYPE_COLOR]
        || [strPaperType isEqualToString:S_PRINT_PAPERTYPE_HEAVYPAPER]) {
        
        return YES;
        
    }
    return NO;
}


#pragma mark - Staple

/**
 @brief ステープルを設定できる用紙サイズかどうかを判定する
 */
+ (BOOL)checkCanStaplePaperSize:(BOOL)isStapleless andPaperSize:(NSString*)strPaperSize {
    
    if (!isStapleless) {
        // 1箇所とじ/2箇所とじ
        if ([strPaperSize isEqualToString:S_PRINT_PAPERSIZE_A3]
            || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_A4]
            || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_B4]
            || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_B5]
            || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_LEDGER]
            || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_LETTER]
            || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_LEGAL]) {
            
            return YES;
        }
    }
    else {
        // 針なしステープル
        if ([strPaperSize isEqualToString:S_PRINT_PAPERSIZE_A3]
            || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_A4]
            || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_B4]
            || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_B5]
            || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_LEDGER]
            || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_LETTER]
            || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_CHINESE8K]
            || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_CHINESE16K]) {
            
            return YES;
        }
    }
    
    return NO;
    
}

/**
 @brief パンチを設定できる用紙サイズかどうかを判定する
 */
+ (BOOL)checkCanPunchPaperSize:(NSString*)strPaperSize {
    
    // パンチ
    if ([strPaperSize isEqualToString:S_PRINT_PAPERSIZE_A3]
        || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_A4]
        || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_B4]
        || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_B5]
        || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_LEDGER]
        || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_LETTER]
        || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_LEGAL]) {
        
        return YES;
    }
    
    return NO;
    
}

/**
 @brief 仕上げ設定画面のステープルの活性/非活性を判定する
 @detail 用紙サイズを変更後/プリンター変更後に呼ばれる
 */
+ (BOOL)checkFinishingSettingViewStapleEnable:(STAPLE)staple andPaperSize:(NSString*)strPaperSize {
    
    if (staple == STAPLE_ONE || staple == STAPLE_TWO) {
        if ([strPaperSize isEqualToString:S_PRINT_PAPERSIZE_A3]
            || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_A4]
            || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_B4]
            || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_B5]
            || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_LEDGER]
            || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_LETTER]
            || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_LEGAL]) {
            
            return YES;
        }

    }
    else if (staple == STAPLE_NONE_STAPLELESS) {
        if ([strPaperSize isEqualToString:S_PRINT_PAPERSIZE_A3]
            || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_A4]
            || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_B4]
            || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_B5]
            || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_LEDGER]
            || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_LETTER]
            || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_CHINESE8K]
            || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_CHINESE16K]) {
            
            return YES;
        }

    }
    else if (staple == STAPLE_ONE_STAPLELESS || staple == STAPLE_TWO_STAPLELESS) {
        if ([strPaperSize isEqualToString:S_PRINT_PAPERSIZE_A3]
            || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_A4]
            || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_B4]
            || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_B5]
            || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_LEDGER]
            || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_LETTER]
            || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_LEGAL]
            || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_CHINESE8K]
            || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_CHINESE16K]) {
            
            return YES;
        }

    }
    
    return NO;
}

/**
 @brief 仕上げ設定画面のパンチの活性/非活性を判定する
 @detail 用紙サイズを変更後/プリンター変更後に呼ばれる
 */
+ (BOOL)checkFinishingSettingViewPunchEnable:(PunchData*)punchData andPaperSize:(NSString*)strPaperSize {
    
    // パンチ非活性
    if (punchData == nil || punchData.canPunch == NO) {
        return NO;
    }
    
    if ([strPaperSize isEqualToString:S_PRINT_PAPERSIZE_A3]
        || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_A4]
        || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_B4]
        || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_B5]
        || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_LEDGER]
        || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_LETTER]
        || [strPaperSize isEqualToString:S_PRINT_PAPERSIZE_LEGAL]) {
        
        return YES;
    }
    
    return NO;
}

/**
 @brief ステープルを設定できる用紙タイプかどうかを判定する
 @detail 用紙タイプとステープルの排他制御判定
 */
+ (BOOL)checkCanStaplePaperType:(NSString*)strPaperType {
    
    if ([strPaperType isEqualToString:S_PRINT_PAPERTYPE_AUTOSELECT]
        || [strPaperType isEqualToString:S_PRINT_PAPERTYPE_PLAIN]
        || [strPaperType isEqualToString:S_PRINT_PAPERTYPE_LETTERHEAD]
        || [strPaperType isEqualToString:S_PRINT_PAPERTYPE_PREPRINTED]
        || [strPaperType isEqualToString:S_PRINT_PAPERTYPE_PREPUNCHED]
        || [strPaperType isEqualToString:S_PRINT_PAPERTYPE_RECYCLED]
        || [strPaperType isEqualToString:S_PRINT_PAPERTYPE_COLOR]) {
        
        return YES;
        
    }
    return NO;
}

/**
 @brief パンチを設定できる用紙タイプかどうかを判定する
 @detail 用紙タイプとパンチの排他制御判定
 */
+ (BOOL)checkCanPunchPaperType:(NSString*)strPaperType {
    
    if ([strPaperType isEqualToString:S_PRINT_PAPERTYPE_AUTOSELECT]
        || [strPaperType isEqualToString:S_PRINT_PAPERTYPE_PLAIN]
        || [strPaperType isEqualToString:S_PRINT_PAPERTYPE_LETTERHEAD]
        || [strPaperType isEqualToString:S_PRINT_PAPERTYPE_PREPRINTED]
        || [strPaperType isEqualToString:S_PRINT_PAPERTYPE_RECYCLED]
        || [strPaperType isEqualToString:S_PRINT_PAPERTYPE_COLOR]
        || [strPaperType isEqualToString:S_PRINT_PAPERTYPE_HEAVYPAPER]) {
        
        return YES;
        
    }
    return NO;
}

/**
 @brief 選択されているステープルの値が針なしステープルかどうかを判定する
 */
+ (BOOL)isStaplelessStapleSelected:(STAPLE)staple andSelectedIndex:(NSInteger)nSelectedIndex andPaperSize:(NSString*)strPaperSize {
    
    if (staple == STAPLE_NONE_STAPLELESS || staple == STAPLE_ONE_STAPLELESS || staple == STAPLE_TWO_STAPLELESS) {
        if ([[self getSelectableStaple:staple andPaperSize:strPaperSize] objectAtIndex:nSelectedIndex] == S_PRINT_STAPLE_STAPLELESS) {
            return YES;
        }
    }
    
    return NO;
}

/**
 @brief 選択可能なステープルのリストを返す
 @detail プリンターのステープルスペックと用紙サイズによってリストが変わる
 */
+ (NSMutableArray*)getSelectableStaple:(STAPLE)staple andPaperSize:(NSString*)strPaperSize {
    
    NSMutableArray *resArray = [[NSMutableArray alloc] init];
    [resArray addObject:S_PRINT_STAPLE_NONE];
    switch (staple) {
        case STAPLE_ERR:
            break;
        case STAPLE_NONE:
            break;
        case STAPLE_ONE:
            if ([self checkCan1Staple2StapleWithPaperSize:strPaperSize]) {
                [resArray addObject:S_PRINT_STAPLE_1STAPLE];
            }
            break;
        case STAPLE_TWO:
            if ([self checkCan1Staple2StapleWithPaperSize:strPaperSize]) {
                [resArray addObject:S_PRINT_STAPLE_1STAPLE];
                [resArray addObject:S_PRINT_STAPLE_2STAPLES];
            }
            break;
        case STAPLE_NONE_STAPLELESS:
            if ([self checkCanStaplelessWithPaperSize:strPaperSize]) {
                [resArray addObject:S_PRINT_STAPLE_STAPLELESS];
            }
            break;
        case STAPLE_ONE_STAPLELESS:
            if ([self checkCan1Staple2StapleWithPaperSize:strPaperSize]) {
                [resArray addObject:S_PRINT_STAPLE_1STAPLE];
            }
            if ([self checkCanStaplelessWithPaperSize:strPaperSize]) {
                [resArray addObject:S_PRINT_STAPLE_STAPLELESS];
            }
            break;
        case STAPLE_TWO_STAPLELESS:
            if ([self checkCan1Staple2StapleWithPaperSize:strPaperSize]) {
                [resArray addObject:S_PRINT_STAPLE_1STAPLE];
                [resArray addObject:S_PRINT_STAPLE_2STAPLES];
            }
            if ([self checkCanStaplelessWithPaperSize:strPaperSize]) {
                [resArray addObject:S_PRINT_STAPLE_STAPLELESS];
            }
            break;
    }
    
    return resArray;
}

/**
 @brief 選択可能なパンチのリストを返す
 @detail プリンターのパンチスペックと用紙サイズによってリストが変わる
 */
+ (NSMutableArray*)getSelectablePunch:(PunchData*)punchData andPaperSize:(NSString*)strPaperSize {
    
    NSMutableArray *resArray = [[NSMutableArray alloc] init];
    [resArray addObject:S_PRINT_PUNCH_NONE];
    
    if (punchData == nil || punchData.canPunch == NO) {
        return resArray;
    }

    // 3穴パンチ追加
    if (punchData.canPunch3Holes == YES) {
        [resArray addObject:S_PRINT_PUNCH_3HOLES];

    } else {
        // 2穴パンチ追加
        if (punchData.canPunch2Holes == YES) {
            [resArray addObject:S_PRINT_PUNCH_2HOLES];
        }
    }

    // 4穴パンチ追加
    if (punchData.canPunch4Holes == YES) {
        [resArray addObject:S_PRINT_PUNCH_4HOLES];
    }
    
    // 4穴(幅広)パンチ追加
    if (punchData.canPunch4HolesWide == YES) {
        [resArray addObject:S_PRINT_PUNCH_4HOLESWIDE];
    }
    
    return resArray;
}

/**
 @brief 1箇所とじ/2箇所とじができる用紙サイズかどうか判定(リスト作成時専用)
 @detail 用紙サイズが8K, 16Kの場合は不可
 */
+ (BOOL)checkCan1Staple2StapleWithPaperSize:(NSString*)strPaperSize {
    
    if (strPaperSize == S_PRINT_PAPERSIZE_CHINESE8K || strPaperSize == S_PRINT_PAPERSIZE_CHINESE16K) {
        return NO;
    }
    
    return YES;
    
}

/**
 @brief 針なしステープルができる用紙サイズかどうか判定(リスト作成時専用)
 @detail 用紙サイズがLegalの場合は不可
 */
+ (BOOL)checkCanStaplelessWithPaperSize:(NSString*)strPaperSize {
    
    if (strPaperSize == S_PRINT_PAPERSIZE_LEGAL) {
        return NO;
    }
    
    return YES;
    
}

/**
 @brief ステープルのPJL用の文字列取得
 */
+ (NSString*)getStaplePJLString:(NSString*)strStaple {
    
    if ([strStaple isEqualToString:S_PRINT_STAPLE_NONE]) {
        return S_PJL_SET_JOBSTAPLE_STAPLENO;
    }
    else if ([strStaple isEqualToString:S_PRINT_STAPLE_1STAPLE]) {
        return S_PJL_SET_JOBSTAPLE_STAPLELEFT;
    }
    else if ([strStaple isEqualToString:S_PRINT_STAPLE_2STAPLES]) {
        return S_PJL_SET_JOBSTAPLE_STAPLEBOTH;
    }
    else if ([strStaple isEqualToString:S_PRINT_STAPLE_STAPLELESS]) {
        return S_PJL_SET_STAPLEOPTION_STAPLELESS;
    }
    
    return nil;
}

/**
 @brief パンチのPJL用の文字列取得
 */
+ (NSString*)getPunchPJLString:(NSString*)strPunch {
    
    if ([strPunch isEqualToString:S_PRINT_PUNCH_2HOLES]) {
        // 2穴
        return S_PJL_SET_PUNCH_NUMBER_TWO;
    }
    else if ([strPunch isEqualToString:S_PRINT_PUNCH_3HOLES]) {
        // 3穴
        return S_PJL_SET_PUNCH_NUMBER_THREE;
    }
    else if ([strPunch isEqualToString:S_PRINT_PUNCH_4HOLES]) {
        // 4穴
        return S_PJL_SET_PUNCH_NUMBER_FOUR;
    }
    else if ([strPunch isEqualToString:S_PRINT_PUNCH_4HOLESWIDE]) {
        // 4穴(幅広)
        return S_PJL_SET_PUNCH_NUMBER_FOURWIDE;
    }
    
    return nil;
}

#pragma -mark 印刷データ有無判定
/**
 @brief 引数から印刷データが選択されているか判定する
 @details Web印刷とメール印刷の場合とそれ以外で参照する変数を場合分け
 */
+ (BOOL)checkPrintDataSelected:(PrintPictViewID)printPictViewID
                  andFileCount:(NSInteger)selFileCnt
                  andPictCount:(NSInteger)selPictCnt
                  andTotalPage:(NSInteger)totalPageCnt
                   andFilePath:(NSString*)strFilePath
                andIsSingleData:(BOOL)isSingleData {
    
    if (printPictViewID == WEB_PRINT_VIEW || printPictViewID == EMAIL_PRINT_VIEW) {
        // Web印刷/メール本文印刷
        if (totalPageCnt > 0) {
            return YES;
        }
    }
    else if (selFileCnt > 0 || selPictCnt > 0) {
        // 単数複数ファイル/複数写真/単数複数添付ファイル印刷
        return YES;
    }
    else if (printPictViewID == PPV_PRINT_SELECT_PICTURE_CELL) {
        if (strFilePath != nil && ![strFilePath isEqualToString:@""] && isSingleData) {
            // 単数写真印刷
            return YES;
        }
    }
    else if (printPictViewID == PPV_OTHER) {
        // 外部連携のときは活性(ファイル削除がない＋引数のデータではファイルの有無が判定できない)
        return YES;
    }
    
    return NO;
}

@end
