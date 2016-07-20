#include "NonCompElement.h"

/**
 * デストラクタ
 */
NonCompElement::~NonCompElement() {
	closeElement();
}


/**
 * init()
 * メンバの初期化を行う
 *
 */
void NonCompElement::init()
{
	TRACE();
	pFile = NULL;
	path = NULL;
	width = 0;
	height = 0;
	size = 0;
	colorSpace = 1;
	type = ELMTYPE_NONECOMP;
}

/**
 * clear()
 * NonCompElementオブジェクトを破棄する
 *
 */
void NonCompElement::clear() {
	TRACE();
	closeElement();
}

/**
 * getProperty()
 * jpegのサイズ情報を取得する
 *
 */
int NonCompElement::getProperty() {
	return 0;
}

