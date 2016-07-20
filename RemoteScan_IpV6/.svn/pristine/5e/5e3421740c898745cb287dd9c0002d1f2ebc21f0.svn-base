#include "G3Element.h"

/**
 * デストラクタ
 */
G3Element::~G3Element() {
	closeElement();
}


/**
 * init()
 * メンバの初期化を行う
 *
 */
void G3Element::init()
{
	TRACE();
	pFile = NULL;
	path = NULL;
	width = 0;
	height = 0;
	size = 0;
	colorSpace = 1;
	type = ELMTYPE_G3;
}

/**
 * clear()
 * G3Elementオブジェクトを破棄する
 *
 */
void G3Element::clear() {
	TRACE();
	closeElement();
}

/**
 * getProperty()
 * jpegのサイズ情報を取得する
 *
 */
int G3Element::getProperty() {
	return 0;
}

