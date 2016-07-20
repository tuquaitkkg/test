#include "ContentPosition.h"

/**
 * ContentPosition()
 * コンストラクタ
 *
 */
ContentPosition::ContentPosition()
{
}

/**
 * ContentPosition()
 * コンストラクタ
 *
 */
ContentPosition::ContentPosition(int paramDispWidth, int paramDispHeight, int paramOrgWidth, int paramOrgHeight, int paramNup, int paramOrder, int paramCount)
{
	setDisplaySize(paramDispWidth, paramDispHeight);
	setDiplayNup(paramNup);
	setDiplayNupOrder(paramOrder);
	setContentSize(paramOrgWidth, paramOrgHeight);
	setCountInNup(paramCount);
	ContentPosition();
	LOGD("img dw(%d) dh(%d) ow(%d) oh(%d) nup(%d) count(%d)", dispWidth, dispHeight, orgWidth, orgHeight, nup, count);
}

/**
 * ~ContentPosition()
 * デストラクタ
 *
 */
ContentPosition::~ContentPosition()
{
}

/**
 * setDisplaySize()
 * 画面サイズを設定する
 *
 */
void ContentPosition::setDisplaySize(int paramDispWidth, int paramDispHeight)
{
	dispWidth = paramDispWidth;
	dispHeight = paramDispHeight;
}

/**
 * setDiplayNup()
 * 画面分割サイズを設定する
 *
 */
void ContentPosition::setDiplayNup(int paramNup)
{
	nup = paramNup;
}

/**
 * setCountInNup()
 * 描画順番を設定する
 *
 */
void ContentPosition::setCountInNup(int paramCount)
{
	count = paramCount;
}

/**
 * setDiplayNupOrder()
 * 画面分割サイズの順番を設定する
 *
 */
void ContentPosition::setDiplayNupOrder(int paramOrder)
{
	order = paramOrder;
}

/**
 * setContentSize()
 * 元画像のサイズを設定する
 *
 */
void ContentPosition::setContentSize(int paramOrgWidth, int paramOrgHeight)
{
	orgWidth = paramOrgWidth;
	orgHeight = paramOrgHeight;
}

/**
 * setPortrait()
 * 元画像の向きを設定する
 *
 */
void ContentPosition::setPortrait(bool isPortrait)
{
	isConvert = false;
	switch (nup) {
	//case N_UP_1:
	//case N_UP_2:
	//	// 1UP/2UP時は縦固定のため
	//	// 画像のレイアウトが横であれば変換必要
	//	if (!isPortrait) {
	//		isConvert = true;
	//	}
	//	break;
    case N_UP_2:
        // 2UP時はPDFレイアウトと画像のレイアウトが同じであれば
        // 90度変換が必要
        if (dispWidth < dispHeight) {
            if (isPortrait) {
                isConvert = true;
            }
        } else {
            if (!isPortrait) {
                isConvert = true;
            }
        }
        break;
    case N_UP_1:
	case N_UP_4:
		// 4UP時はPDFレイアウトと画像のレイアウトが逆であれば
		// 90度変換が必要
		if (dispWidth < dispHeight) {
			if (!isPortrait) {
				isConvert = true;
			}
		} else {
			if (isPortrait) {
				isConvert = true;
			}
		}
		break;
	}
	if (isConvert) {
		int temp = orgWidth;
		orgWidth = orgHeight;
		orgHeight = temp;
		LOGD("Rotate --> w(%d) h(%d)", orgWidth, orgHeight);
	}
	return;
}

/**
 * calc()
 * 画像のサイズ、ならびに、開始位置を計算する
 *
 */
void ContentPosition::calc()
{
	calcContentSize();
	calcContentX();
	calcContentY();
	LOGD("img w(%d) h(%d) x(%d) y(%d) r(%d)", width, height, x, y, isConvert);
}

/**
 * setDefaultContentSize()
 * 基本の描画サイズを決定する
 *
 */
void ContentPosition::setDefaultContentSize()
{
	switch(nup) {
	case N_UP_1:
		width = dispWidth - PDF_SIZE_MARGIN_HORIZONTAL;
		height = dispHeight - PDF_SIZE_MARGIN_VERTICAL;
		break;
	case N_UP_2:
		width = (dispWidth / 2) - PDF_SIZE_MARGIN_LEFT- (PDF_SIZE_MARGIN_LEFT/ 2) ;
		height = dispHeight - PDF_SIZE_MARGIN_VERTICAL;
		break;
	case N_UP_4:
		width = (dispWidth / 2) - PDF_SIZE_MARGIN_LEFT- (PDF_SIZE_MARGIN_LEFT/ 4) ;
		height = (dispHeight / 2) - PDF_SIZE_MARGIN_BOTTOM - (PDF_SIZE_MARGIN_BOTTOM/ PDF_SIZE_MARGIN_HEIGHT_BETWEEN);
		break;
	}
	marginWidth = width;
	marginHeight = height;
	return;
}

/**
 * calcContentSize()
 * 縦横比から描画サイズを決定する
 *
 */
void ContentPosition::calcContentSize()
{
	// 縦横比を算出。メモリと計算時間に配慮して値は1000倍して計算
	int checkWidth = (orgWidth* 1000)/ dispWidth;
	int checkHeight = (orgHeight* 1000)/ dispHeight;
	switch(nup) {
	//case N_UP_2:
	//	//checkWidth = (orgWidth* 1000)/ (dispWidth/ 2);
	//	break;
	case N_UP_4:
		checkWidth = (orgWidth* 1000)/ (dispWidth/ 2);
		checkHeight = (orgHeight* 1000)/ (dispHeight/ 2);
		break;
	}
	LOGD("ratio w(%d):h(%d)", checkWidth, checkHeight);

	// 縦横比が同じ場合
	if (checkWidth == checkHeight) {
		setDefaultContentSize();
		return;
	}

	// どちらか一方が用紙サイズよりも大きい場合
	// 大きい倍率の方を基準にする
	if (checkWidth > 1000 || checkHeight > 1000) {
		// 横サイズの方が大きい場合、横にあわせる
		if (checkWidth > checkHeight) {
			switch(nup) {
			case N_UP_1:
				width = dispWidth - PDF_SIZE_MARGIN_HORIZONTAL;
				height = (orgHeight* (width* 1000/ orgWidth))/ 1000;
				marginWidth = width;
				marginHeight = height;
				break;
			case N_UP_2:
                //width = (dispWidth / 2) - PDF_SIZE_MARGIN_LEFT- (PDF_SIZE_MARGIN_LEFT/ 2) ;
                //height = (orgHeight* (width* 1000/ orgWidth))/ 1000;
                if (dispWidth < dispHeight) {
                    height = (dispHeight / 2) - PDF_SIZE_MARGIN_VERTICAL;
                    width = (orgWidth* (height* 1000/ orgHeight))/ 1000;
					marginHeight = height;
					// 算出した幅がはみ出ている場合は幅を元に高さを求める
					if (dispWidth < width) {
						width = dispWidth - PDF_SIZE_MARGIN_HORIZONTAL;
						height = (orgHeight* (width* 1000/ orgWidth))/ 1000;
					}
					marginWidth = width;
                }
                else{
                    width = (dispWidth / 2) - PDF_SIZE_MARGIN_HORIZONTAL ;
                    height = (orgHeight* (width* 1000/ orgWidth))/ 1000;
					marginWidth = width;
					// 算出した高さがはみ出ている場合は高さを元に幅を求める
					if (dispHeight < height) {
						height = dispHeight - PDF_SIZE_MARGIN_VERTICAL;
						width = (orgWidth* (height* 1000/ orgHeight))/ 1000;
					}
					marginHeight = height;
                }
				break;
			case N_UP_4:
				width = (dispWidth / 2) - PDF_SIZE_MARGIN_LEFT- (PDF_SIZE_MARGIN_LEFT/ 4) ;
				height = (orgHeight* (width* 1000/ orgWidth))/ 1000;
				marginWidth = width;
				marginHeight = height;
				break;
			}
			return;
		}
		// 縦サイズの方が大きい場合
		else {
			switch(nup) {
			case N_UP_1:
				height = dispHeight - PDF_SIZE_MARGIN_VERTICAL;
				width = (orgWidth* (height* 1000/ orgHeight))/ 1000;
				marginWidth = width;
				marginHeight = height;
				break;
			case N_UP_2:
				//height = dispHeight - PDF_SIZE_MARGIN_VERTICAL;
				//width = (orgWidth* (height* 1000/ orgHeight))/ 1000;
                if (dispWidth < dispHeight) {
                    height = (dispHeight / 2) - PDF_SIZE_MARGIN_VERTICAL;
                    width = (orgWidth* (height* 1000/ orgHeight))/ 1000;
					marginHeight = height;
					// 算出した幅がはみ出ている場合は幅を元に高さを求める
					if (dispWidth < width) {
						width = dispWidth - PDF_SIZE_MARGIN_HORIZONTAL;
						height = (orgHeight* (width* 1000/ orgWidth))/ 1000;
					}
					marginWidth = width;
                }
                else{
                    width = (dispWidth / 2) - PDF_SIZE_MARGIN_HORIZONTAL ;
                    height = (orgHeight* (width* 1000/ orgWidth))/ 1000;
					marginWidth = width;
					// 算出した高さがはみ出ている場合は高さを元に幅を求める
					if (dispHeight < height) {
						height = dispHeight - PDF_SIZE_MARGIN_VERTICAL;
						width = (orgWidth* (height* 1000/ orgHeight))/ 1000;
					}
					marginHeight = height;
                }
				break;
			case N_UP_4:
				height = (dispHeight / 2) - PDF_SIZE_MARGIN_BOTTOM - (PDF_SIZE_MARGIN_BOTTOM/ PDF_SIZE_MARGIN_HEIGHT_BETWEEN);
				width = (orgWidth* (height* 1000/ orgHeight))/ 1000;
				marginWidth = width;
				marginHeight = height;
				break;
			}
		}
		return;
	}

	// 両方とも用紙サイズより小さい場合
	// 倍率の小さな方にあわせる
	if (checkWidth > checkHeight) {
		switch(nup) {
		case N_UP_1:
			width = dispWidth - PDF_SIZE_MARGIN_HORIZONTAL;
			height = (orgHeight* (width* 1000/ orgWidth))/ 1000;
			break;
		case N_UP_2:
            //width = (dispWidth / 2) - PDF_SIZE_MARGIN_LEFT- (PDF_SIZE_MARGIN_LEFT/ 2) ;
            //height = (orgHeight* (width* 1000/ orgWidth))/ 1000;
            if (dispWidth < dispHeight) {
                height = (dispHeight / 2) - PDF_SIZE_MARGIN_VERTICAL;
                width = (orgWidth* (height* 1000/ orgHeight))/ 1000;
            }
            else{
                width = (dispWidth / 2) - PDF_SIZE_MARGIN_HORIZONTAL ;
                height = (orgHeight* (width* 1000/ orgWidth))/ 1000;
            }
			break;
		case N_UP_4:
			width = (dispWidth / 2) - PDF_SIZE_MARGIN_LEFT- (PDF_SIZE_MARGIN_LEFT/ 4) ;
			height = (orgHeight* (width* 1000/ orgWidth))/ 1000;
			break;
		}
		marginWidth = width;
		marginHeight = height;
		return;
	}
	else {
		switch(nup) {
		case N_UP_1:
			height = dispHeight - PDF_SIZE_MARGIN_VERTICAL;
			width = (orgWidth* (height* 1000/ orgHeight))/ 1000;
			break;
		case N_UP_2:
			//height = dispHeight - PDF_SIZE_MARGIN_VERTICAL;
			//width = (orgWidth* (height* 1000/ orgHeight))/ 1000;
            if (dispWidth < dispHeight) {
                height = (dispHeight / 2) - PDF_SIZE_MARGIN_VERTICAL;
                width = (orgWidth* (height* 1000/ orgHeight))/ 1000;
            }
            else{
                width = (dispWidth / 2) - PDF_SIZE_MARGIN_HORIZONTAL ;
                height = (orgHeight* (width* 1000/ orgWidth))/ 1000;
            }
			break;
		case N_UP_4:
			height = (dispHeight / 2) - PDF_SIZE_MARGIN_BOTTOM - (PDF_SIZE_MARGIN_BOTTOM/ PDF_SIZE_MARGIN_HEIGHT_BETWEEN);
			width = (orgWidth* (height* 1000/ orgHeight))/ 1000;
			break;
		}
		marginWidth = width;
		marginHeight = height;
		return;
	}

	// どこにも該当しなかった場合(異常系)
	setDefaultContentSize();
	return;
}

/**
 * calcContentX()
 * コンテンツの開始x座標を返す
 *
 */
void ContentPosition::calcContentX()
{
	switch(nup) {
	case N_UP_1:
		x = (dispWidth/ 2) - (marginWidth /2);
		break;
	case N_UP_2:
		//// 2UPレイアウトは横固定なので、画像が縦であろうと横であろうと
		//// 右から左か左から右で判断
		//if (count == 0) {
		//	if (order == NUP_ORDER_2UP_LEFT_TO_RIGHT) {
		//		x = ((dispWidth / 2)/ 2) - (marginWidth /2);
		//	} else {
		//		x = (dispWidth/ 2)+ ((dispWidth / 2)/ 2) - (marginWidth /2);
		//	}
		//} else {
		//	if (order == NUP_ORDER_2UP_LEFT_TO_RIGHT) {
		//		x = (dispWidth/ 2)+ ((dispWidth / 2)/ 2) - (marginWidth /2);
		//	} else {
		//		x = ((dispWidth / 2)/ 2) - (marginWidth /2);
		//	}
		//}
        if(dispWidth < dispHeight){
            x = (dispWidth/ 2) - (marginWidth /2);
        }
        else{
            if (count == 0) {
                if (order == NUP_ORDER_2UP_LEFT_TO_RIGHT) {
                    x = ((dispWidth / 2)/ 2) - (marginWidth /2);
                } else {
                    x = (dispWidth/ 2)+ ((dispWidth / 2)/ 2) - (marginWidth /2);
                }
            } else {
                if (order == NUP_ORDER_2UP_LEFT_TO_RIGHT) {
                    x = (dispWidth/ 2)+ ((dispWidth / 2)/ 2) - (marginWidth /2);
                } else {
                    x = ((dispWidth / 2)/ 2) - (marginWidth /2);
                }
            }
        }
		break;
	case N_UP_4:
		switch(count) {
		case 0:
			if (order == NUP_ORDER_4UP_UPPERLEFT_TO_RIGHT || order == NUP_ORDER_4UP_UPPERLEFT_TO_BOTTOM) {
				x = ((dispWidth / 2)/ 2) - (marginWidth /2);
			} else {
				x = (dispWidth/ 2)+ ((dispWidth / 2)/ 2) - (marginWidth /2);
			}
			break;
		case 1:
			if (order == NUP_ORDER_4UP_UPPERLEFT_TO_RIGHT || order == NUP_ORDER_4UP_UPPERRIGHT_TO_BOTTOM) {
				x = (dispWidth/ 2)+ ((dispWidth / 2)/ 2) - (marginWidth /2);
			} else {
				x = ((dispWidth / 2)/ 2) - (marginWidth /2);
			}
			break;
		case 2:
			if (order == NUP_ORDER_4UP_UPPERLEFT_TO_RIGHT || order == NUP_ORDER_4UP_UPPERRIGHT_TO_BOTTOM) {
				x = ((dispWidth / 2)/ 2) - (marginWidth /2);
			} else {
				x = (dispWidth/ 2)+ ((dispWidth / 2)/ 2) - (marginWidth /2);
			}
			break;
		case 3:
			if (order == NUP_ORDER_4UP_UPPERLEFT_TO_RIGHT || order == NUP_ORDER_4UP_UPPERLEFT_TO_BOTTOM) {
				x = (dispWidth/ 2)+ ((dispWidth / 2)/ 2) - (marginWidth /2);
			} else {
				x = ((dispWidth / 2)/ 2) - (marginWidth /2);
			}
			break;
		}
		break;
	}
	// 縦横変換の場合は、x値を下底、右辺の交点を設定
	if (isConvert) {
		x += marginWidth;
	}
}

/**
 * calcContentY()
 * コンテンツの開始Y座標を返す
 *
 */
void ContentPosition::calcContentY()
{
	switch(nup) {
	case N_UP_1:
        y = (dispHeight/ 2) - (marginHeight/ 2);
        break;
	case N_UP_2:
		//// 2UPレイアウトは横固定なので、画像が縦であろうと横であろうと
		//// 底辺は同じ
		//y = (dispHeight/ 2) - (marginHeight/ 2);
        if(dispWidth < dispHeight){
            if (count == 0) {
                y = (dispHeight/ 2)+ (((dispHeight/ 2)/ 2) - (marginHeight/ 2));
            }
            else{
				y = ((dispHeight/ 2)/ 2) - (marginHeight/ 2);
            }
        }
        else{
            y = (dispHeight/ 2) - (marginHeight/ 2);
        }
		break;
	case N_UP_4:
		switch(count) {
		case 0:
			y = (dispHeight/ 2)+ (((dispHeight/ 2)/ 2) - (marginHeight/ 2));
			break;
		case 1:
			if (order == NUP_ORDER_4UP_UPPERLEFT_TO_RIGHT || order == NUP_ORDER_4UP_UPPERRIGHT_TO_LEFT) {
				y = (dispHeight/ 2)+ (((dispHeight/ 2)/ 2) - (marginHeight/ 2));
			} else {
				y = ((dispHeight/ 2)/ 2) - (marginHeight/ 2);
			}
			break;
		case 2:
			if (order == NUP_ORDER_4UP_UPPERLEFT_TO_RIGHT || order == NUP_ORDER_4UP_UPPERRIGHT_TO_LEFT) {
				y = ((dispHeight/ 2)/ 2) - (marginHeight/ 2);
			} else {
				y = (dispHeight/ 2)+ (((dispHeight/ 2)/ 2) - (marginHeight/ 2));
			}
			break;
		case 3:
			y = ((dispHeight/ 2)/ 2) - (marginHeight/ 2);
			break;
		}
		break;
	}
}

