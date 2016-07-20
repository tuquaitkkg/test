#include "G4Element.h"

/**
 * デストラクタ
 */
G4Element::~G4Element() {
	closeElement();
}


/**
 * init()
 * メンバの初期化を行う
 *
 */
void G4Element::init()
//G4Element::G4Element()
{
	TRACE();
	pFile = NULL;
	path = NULL;
	width = 0;
	height = 0;
	size = 0;
	colorSpace = 1;
	type = ELMTYPE_G4;
}

/**
 * clear()
 * G4Elementオブジェクトを破棄する
 *
 */
void G4Element::clear() {
	TRACE();
	closeElement();
}

/**
 * getProperty()
 * jpegのサイズ情報を取得する
 *
 */
int G4Element::getProperty() {
	return 0;
}

