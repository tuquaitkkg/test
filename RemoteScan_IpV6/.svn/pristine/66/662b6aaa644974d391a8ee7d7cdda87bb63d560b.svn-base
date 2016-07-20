#include "PDFCreator.h"
#include "JpegElement.h"
#include "G4Element.h"
#include "G3Element.h"
#include "NonCompElement.h"
#include "ContentPosition.h"


/**
 * PDFElement()
 * コンストラクタ
 *
 */
PDFElement::PDFElement()
{
	pNext = NULL;
	index = 0;
	position = 0;
	type = TYPE_UNDEFINED;
}

/*************************************************************************************/
/*************************************************************************************/
/*************************************************************************************/
/**
 * PDFElementManager()
 * コンストラクタ
 *
 */
PDFElementManager::PDFElementManager()
{
	pTop = NULL;
	pLast = NULL;
	num = 0;
	positionXref = 0;
}

/**
 * ~PDFElementManager()
 * デストラクタ
 *
 */
PDFElementManager::~PDFElementManager()
{
	clear();
}

/**
 * createPDFElement()
 * PDFエレメントを生成する
 *
 */
PDFElement* PDFElementManager::createPDFElement()
{
	PDFElement* e = new PDFElement();
	if (pTop == NULL) {
		pTop = e;
	}
	if (pLast != NULL) {
		pLast->pNext = e;
	}
	pLast = e;
	e->index = num;
	num++;
	return e;
}

/**
 * clear()
 * PDFエレメントをすべて廃棄する
 *
 */
void PDFElementManager::clear()
{
	PDFElement* e = pTop;
	for (int i= 0; i< num; i++) {
		PDFElement* next = e->pNext;
		delete e;
		e = next;
		num--;
	}

	return;
}

/**
 * searchIndex()
 * 指定されたタイプのインデックスを返す
 *
 */
int PDFElementManager::searchIndex(int specifed)
{
	for (PDFElement* e = pTop; e!= NULL; e= e->pNext) {
		if (e->type == specifed) {
			return e->index;
		}
	}

	return TYPE_UNDEFINED;
}

/**
 * searchIndex()
 * パラメタ指定されたエレメント以降の
 * 指定されたタイプのインデックスを返す
 *
 */
int PDFElementManager::searchIndex(PDFElement* prev, int specifed)
{
	bool found = false;
	for (PDFElement* e = pTop; e!= NULL; e= e->pNext) {
		if (e == prev) {
			found = true;
			continue;
		}
		if (e->type == specifed && found) {
			return e->index;
		}
	}

	return TYPE_UNDEFINED;
}

/**
 * searchIndex()
 * パラメタ指定されたエレメント以降の
 * 指定されたタイプのインデックスを返す
 *
 */
int PDFElementManager::searchIndex(int prev, int specifed)
{
	bool found = false;
	for (PDFElement* e = pTop; e!= NULL; e= e->pNext) {
		if (e->index == prev) {
			found = true;
			continue;
		}
		if (e->type == specifed && found) {
			return e->index;
		}
	}

	return TYPE_UNDEFINED;
}

/**
 * getNumOfType()
 * 指定されたタイプのPDFエレメント数を返す
 *
 */
int PDFElementManager::getNumOfType(int specifed)
{
	int count = 0;
	for (PDFElement* e = pTop; e!= NULL; e= e->pNext) {
		if (e->type == specifed) {
			count++;
		}
	}

	return count;
}

/**
 * getTopElement()
 * TOPPDFエレメントを返す
 *
 */
PDFElement* PDFElementManager::getTopElement()
{
	return pTop;
}

/**
 * getTopElement()
 * TOPPDFエレメントを返す
 *
 */
PDFElement* PDFElementManager::getNextElement(PDFElement* cur)
{
	return (cur == NULL)? NULL: cur->pNext;
}

/**
 * getTopElement()
 * TOPPDFエレメントを返す
 *
 */
PDFElement* PDFElementManager::searchElement(int specifed)
{
	for (PDFElement* e = pTop; e!= NULL; e= e->pNext) {
		if (e->type == specifed) {
			return e;
		}
	}
	return NULL;
}

/*************************************************************************************/
/*************************************************************************************/
/*************************************************************************************/
/**
 * PDFCreator()
 * コンストラクタ
 *
 */
PDFCreator::PDFCreator()
{
	TRACE();

	numElements = 0;
	consumedJpegNum = 0;
	pElmManager = new PDFElementManager();
}

/**
 * ~PDFCreator()
 * デストラクタ
 *
 */
PDFCreator::~PDFCreator()
{
	TRACE();
	clear();
	delete pElmManager;
}

/**
 * setNup()
 * N-UP情報を設定する
 *
 */
int PDFCreator::setNup(int srcNup)
{
	switch (srcNup) {
	case N_UP_1:
	case N_UP_2:
	case N_UP_4:
		nup = srcNup;
		break;
	case N_UP_NONE:
	default:
		LOGD("error:invalid param NUP(%d)\n", srcNup);
		return ERROR_INVALID_PARAM_NUP;
	}

	LOGD("nup:%d\n", nup);
	return ERROR_NONE;
}

/**
 * setOrder()
 * 並び順を設定する
 *
 */
int PDFCreator::setOrder(int srcOrder)
{
	switch (nup) {
	case N_UP_1:
		order = NUP_ORDER_2UP_LEFT_TO_RIGHT;
		break;
	case N_UP_2:
		switch (srcOrder) {
		case NUP_ORDER_2UP_LEFT_TO_RIGHT:
		case NUP_ORDER_2UP_RIGHT_TO_LEFT:
			order = srcOrder;
			break;
		case NUP_ORDER_4UP_UPPERLEFT_TO_RIGHT:
		case NUP_ORDER_4UP_UPPERLEFT_TO_BOTTOM:
		case NUP_ORDER_4UP_UPPERRIGHT_TO_LEFT:
		case NUP_ORDER_4UP_UPPERRIGHT_TO_BOTTOM:
			LOGD("NOTICE!! 2UP but ORDER is(%d) -> LEFT_TO_RIGHT\n", srcOrder);
			order = NUP_ORDER_2UP_LEFT_TO_RIGHT;
			break;
		default:
			LOGD("error:invalid param ORDER(%d)\n", srcOrder);
			return ERROR_INVALID_PARAM;
		}
		break;
	case N_UP_4:
		switch (srcOrder) {
		case NUP_ORDER_2UP_LEFT_TO_RIGHT:
		case NUP_ORDER_2UP_RIGHT_TO_LEFT:
			LOGD("NOTICE!! 4UP but ORDER is(%d) -> UPPERLEFT_TO_RIGHT\n", srcOrder);
			order = NUP_ORDER_4UP_UPPERLEFT_TO_RIGHT;
			break;
		case NUP_ORDER_4UP_UPPERLEFT_TO_RIGHT:
		case NUP_ORDER_4UP_UPPERLEFT_TO_BOTTOM:
		case NUP_ORDER_4UP_UPPERRIGHT_TO_LEFT:
		case NUP_ORDER_4UP_UPPERRIGHT_TO_BOTTOM:
			order = srcOrder;
			break;
		default:
			LOGD("error:invalid param ORDER(%d)\n", srcOrder);
			return ERROR_INVALID_PARAM;
		}
		break;
	default:
		LOGD("error:invalid param ORDER(%d)\n", srcOrder);
		return ERROR_INVALID_PARAM;
	}

	LOGD("order:%d\n", order);
	return ERROR_NONE;
}

/**
 * setPrintForm()
 * 用紙サイズを設定する
 *
 */
int PDFCreator::setPrintForm(int printForm)
{
	switch (printForm) {
	case PAPER_SIZE_A3_WIDE:
	case PAPER_SIZE_A3:
	case PAPER_SIZE_A4:
	case PAPER_SIZE_A5:
	case PAPER_SIZE_B4:
	case PAPER_SIZE_B5:
	case PAPER_SIZE_LEDGER:
	case PAPER_SIZE_LETTER:
	case PAPER_SIZE_LEGAL:
	case PAPER_SIZE_EXECUTIVE:
	case PAPER_SIZE_INVOICE:
	case PAPER_SIZE_FOOLSCAP:
	case PAPER_SIZE_S8k:
	case PAPER_SIZE_S16k:
	case PAPER_SIZE_DL:
	case PAPER_SIZE_C5:
	case PAPER_SIZE_COM10:
	case PAPER_SIZE_MONARCH:
	case PAPER_SIZE_JPOST:
	case PAPER_SIZE_KAKUGATA2:
	case PAPER_SIZE_CHOKEI3:
	case PAPER_SIZE_YOKEI2:
	case PAPER_SIZE_YOKEI4:
		LOGD("paper size:%d\n", printForm);
		paperSize = printForm;
		break;
	default:
		LOGD("error:print form is invalid(%d)\n", printForm);
		return ERROR_INVALID_PARAM;
	}

	return ERROR_NONE;
}

/**
 * setTargetPaperSize()
 * ページの縦横サイズを設定する
 *
 */
int PDFCreator::setTargetPaperSize()
{
	switch (paperSize) {
	case PAPER_SIZE_A3_WIDE:
		pageWidth = (nup== N_UP_2)? PDF_PT_A3WIDE_HEIGHT: PDF_PT_A3WIDE_WIDTH;
		pageHeight = (nup== N_UP_2)? PDF_PT_A3WIDE_WIDTH: PDF_PT_A3WIDE_HEIGHT;
		break;
	case PAPER_SIZE_A3:
		pageWidth = (nup== N_UP_2)? PDF_PT_A3_HEIGHT: PDF_PT_A3_WIDTH;
		pageHeight = (nup== N_UP_2)? PDF_PT_A3_WIDTH: PDF_PT_A3_HEIGHT;
		break;
	case PAPER_SIZE_A4:
		pageWidth = (nup== N_UP_2)? PDF_PT_A4_HEIGHT: PDF_PT_A4_WIDTH;
		pageHeight = (nup== N_UP_2)? PDF_PT_A4_WIDTH: PDF_PT_A4_HEIGHT;
		break;
	case PAPER_SIZE_A5:
		pageWidth = (nup== N_UP_2)? PDF_PT_A5_HEIGHT: PDF_PT_A5_WIDTH;
		pageHeight = (nup== N_UP_2)? PDF_PT_A5_WIDTH: PDF_PT_A5_HEIGHT;
		break;
	case PAPER_SIZE_B4:
		pageWidth = (nup== N_UP_2)? PDF_PT_B4_HEIGHT: PDF_PT_B4_WIDTH;
		pageHeight = (nup== N_UP_2)? PDF_PT_B4_WIDTH: PDF_PT_B4_HEIGHT;
		break;
	case PAPER_SIZE_B5:
		pageWidth = (nup== N_UP_2)? PDF_PT_B5_HEIGHT: PDF_PT_B5_WIDTH;
		pageHeight = (nup== N_UP_2)? PDF_PT_B5_WIDTH: PDF_PT_B5_HEIGHT;
		break;
	case PAPER_SIZE_LEDGER:
		pageWidth = (nup== N_UP_2)? PDF_PT_LEDGER_HEIGHT: PDF_PT_LEDGER_WIDTH;
		pageHeight = (nup== N_UP_2)? PDF_PT_LEDGER_WIDTH: PDF_PT_LEDGER_HEIGHT;
		break;
	case PAPER_SIZE_LETTER:
		pageWidth = (nup== N_UP_2)? PDF_PT_LETTER_HEIGHT: PDF_PT_LETTER_WIDTH;
		pageHeight = (nup== N_UP_2)? PDF_PT_LETTER_WIDTH: PDF_PT_LETTER_HEIGHT;
		break;
	case PAPER_SIZE_LEGAL:
		pageWidth = (nup== N_UP_2)? PDF_PT_LEGAL_HEIGHT: PDF_PT_LEGAL_WIDTH;
		pageHeight = (nup== N_UP_2)? PDF_PT_LEGAL_WIDTH: PDF_PT_LEGAL_HEIGHT;
		break;
	case PAPER_SIZE_EXECUTIVE:
		pageWidth = (nup== N_UP_2)? PDF_PT_EXECUTIVE_HEIGHT: PDF_PT_EXECUTIVE_WIDTH;
		pageHeight = (nup== N_UP_2)? PDF_PT_EXECUTIVE_WIDTH: PDF_PT_EXECUTIVE_HEIGHT;
		break;
	case PAPER_SIZE_INVOICE:
		pageWidth = (nup== N_UP_2)? PDF_PT_INVOICE_HEIGHT: PDF_PT_INVOICE_WIDTH;
		pageHeight = (nup== N_UP_2)? PDF_PT_INVOICE_WIDTH: PDF_PT_INVOICE_HEIGHT;
		break;
	case PAPER_SIZE_FOOLSCAP:
		pageWidth = (nup== N_UP_2)? PDF_PT_FOOLSCAP_HEIGHT: PDF_PT_FOOLSCAP_WIDTH;
		pageHeight = (nup== N_UP_2)? PDF_PT_FOOLSCAP_WIDTH: PDF_PT_FOOLSCAP_HEIGHT;
		break;
	case PAPER_SIZE_S8k:
		pageWidth = (nup== N_UP_2)? PDF_PT_S8k_HEIGHT: PDF_PT_S8k_WIDTH;
		pageHeight = (nup== N_UP_2)? PDF_PT_S8k_WIDTH: PDF_PT_S8k_HEIGHT;
		break;
	case PAPER_SIZE_S16k:
		pageWidth = (nup== N_UP_2)? PDF_PT_S16k_HEIGHT: PDF_PT_S16k_WIDTH;
		pageHeight = (nup== N_UP_2)? PDF_PT_S16k_WIDTH: PDF_PT_S16k_HEIGHT;
		break;
	case PAPER_SIZE_DL:
		pageWidth = (nup== N_UP_2)? PDF_PT_DL_HEIGHT: PDF_PT_DL_WIDTH;
		pageHeight = (nup== N_UP_2)? PDF_PT_DL_WIDTH: PDF_PT_DL_HEIGHT;
		break;
	case PAPER_SIZE_C5:
		pageWidth = (nup== N_UP_2)? PDF_PT_C5_HEIGHT: PDF_PT_C5_WIDTH;
		pageHeight = (nup== N_UP_2)? PDF_PT_C5_WIDTH: PDF_PT_C5_HEIGHT;
		break;
	case PAPER_SIZE_COM10:
		pageWidth = (nup== N_UP_2)? PDF_PT_COM10_HEIGHT: PDF_PT_COM10_WIDTH;
		pageHeight = (nup== N_UP_2)? PDF_PT_COM10_WIDTH: PDF_PT_COM10_HEIGHT;
		break;
	case PAPER_SIZE_MONARCH:
		pageWidth = (nup== N_UP_2)? PDF_PT_MONARCH_HEIGHT: PDF_PT_MONARCH_WIDTH;
		pageHeight = (nup== N_UP_2)? PDF_PT_MONARCH_WIDTH: PDF_PT_MONARCH_HEIGHT;
		break;
	case PAPER_SIZE_JPOST:
		pageWidth = (nup== N_UP_2)? PDF_PT_JPOST_HEIGHT: PDF_PT_JPOST_WIDTH;
		pageHeight = (nup== N_UP_2)? PDF_PT_JPOST_WIDTH: PDF_PT_JPOST_HEIGHT;
		break;
	case PAPER_SIZE_KAKUGATA2:
		pageWidth = (nup== N_UP_2)? PDF_PT_KAKUGATA2_HEIGHT: PDF_PT_KAKUGATA2_WIDTH;
		pageHeight = (nup== N_UP_2)? PDF_PT_KAKUGATA2_WIDTH: PDF_PT_KAKUGATA2_HEIGHT;
		break;
	case PAPER_SIZE_CHOKEI3:
		pageWidth = (nup== N_UP_2)? PDF_PT_CHOKEI3_HEIGHT: PDF_PT_CHOKEI3_WIDTH;
		pageHeight = (nup== N_UP_2)? PDF_PT_CHOKEI3_WIDTH: PDF_PT_CHOKEI3_HEIGHT;
		break;
	case PAPER_SIZE_YOKEI2:
		pageWidth = (nup== N_UP_2)? PDF_PT_YOKEI2_HEIGHT: PDF_PT_YOKEI2_WIDTH;
		pageHeight = (nup== N_UP_2)? PDF_PT_YOKEI2_WIDTH: PDF_PT_YOKEI2_HEIGHT;
		break;
	case PAPER_SIZE_YOKEI4:
		pageWidth = (nup== N_UP_2)? PDF_PT_YOKEI4_HEIGHT: PDF_PT_YOKEI4_WIDTH;
		pageHeight = (nup== N_UP_2)? PDF_PT_YOKEI4_WIDTH: PDF_PT_YOKEI4_HEIGHT;
		break;
	default:
		LOGD("error:element == NULL\n");
		return ERROR_INVALID_PARAM;
	}

	LOGD("form(%d) width:%d height:%d\n", paperSize, pageWidth, pageHeight);
	return ERROR_NONE;
}

/**
 * changeTargetPaperLayout()
 * ページの縦フォーマット、横フォーマットを変更する
 *
 */
int PDFCreator::changeTargetPaperLayout()
{
	//switch (nup) {
	//case N_UP_1:
	//case N_UP_2:
	//	// 1UP時は縦レイアウトPDF固定
	//	// 2UP時は横レイアウトPDF固定
	//	return ERROR_NONE;
	//}
	// 1UP、4UP時に１枚目の画像が横であれば
	// PDFレイアウトを横に変更する
	// 2UP時に１枚目の画像が横であれば
	// PDFレイアウトを縦に変更する
	if (!isPortrait) {
		int temp = pageWidth;
		pageWidth = pageHeight;
		pageHeight = temp;
	}
	return ERROR_NONE;
}

/**
 * getPageNum()
 * 生成必要なページ数を返す
 *
 */
int PDFCreator::getPageNum()
{
	int pageNum = 0;
	switch(nup) {
	case N_UP_1:
		pageNum = numElements;
		break;
	case N_UP_2:
		pageNum = (numElements% 2) == 0? (numElements/ 2): (numElements/ 2) + 1;
		break;
	case N_UP_4:
		pageNum = (numElements% 4) == 0? (numElements/ 4): (numElements/ 4) + 1;
		break;
	}

	LOGD("pageNum:%d\n", pageNum);
	return pageNum;
}

/**
 * getContentWidth()
 * コンテンツの幅を返す
 *
 */
int PDFCreator::getContentWidth(int imageNum)
{
	int width = 0;
	switch(nup) {
	case N_UP_1:
		width = pageWidth - PDF_SIZE_MARGIN_HORIZONTAL;
		break;
	case N_UP_2:
		width = (pageWidth / 2) - PDF_SIZE_MARGIN_LEFT- (PDF_SIZE_MARGIN_LEFT/ 2) ;
		break;
	case N_UP_4:
		width = (pageWidth / 2) - PDF_SIZE_MARGIN_LEFT- (PDF_SIZE_MARGIN_LEFT/ 4) ;
		break;
	}

	LOGD("imageNum:%d width:%d\n", imageNum, width);
	return width;
}

/**
 * getContentHeight()
 * コンテンツの高さを返す
 *
 */
int PDFCreator::getContentHeight(int imageNum)
{
	int height = 0;
	switch(nup) {
	case N_UP_1:
	case N_UP_2:
		height = pageHeight - PDF_SIZE_MARGIN_VERTICAL;
		break;
	case N_UP_4:
		height = (pageHeight / 2) - PDF_SIZE_MARGIN_BOTTOM - (PDF_SIZE_MARGIN_BOTTOM/ PDF_SIZE_MARGIN_HEIGHT_BETWEEN);
		break;
	}

	LOGD("imageNum:%d height:%d\n", imageNum, height);
	return height;
}

/**
 * getContentX()
 * コンテンツの開始x座標を返す
 *
 */
int PDFCreator::getContentX(int count)
{
	int x = 0;
	switch(nup) {
	case N_UP_1:
		x = PDF_SIZE_MARGIN_LEFT;
		break;
	case N_UP_2:
		// 2UPレイアウトは横固定なので、画像が縦であろうと横であろうと
		// 右から左か左から右で判断
		if (count == 0) {
			if (order == NUP_ORDER_2UP_LEFT_TO_RIGHT) {
				x = PDF_SIZE_MARGIN_LEFT;
			} else {
				x = (pageWidth/ 2)+ (PDF_SIZE_MARGIN_LEFT/2);
			}
		} else {
			if (order == NUP_ORDER_2UP_LEFT_TO_RIGHT) {
				x = (pageWidth/ 2)+ (PDF_SIZE_MARGIN_LEFT/2);
			} else {
				x = PDF_SIZE_MARGIN_LEFT;
			}
		}
		break;
	case N_UP_4:
		switch(count) {
		case 0:
			if (order == NUP_ORDER_4UP_UPPERLEFT_TO_RIGHT || order == NUP_ORDER_4UP_UPPERLEFT_TO_BOTTOM) {
				x = PDF_SIZE_MARGIN_LEFT;
			} else {
				x = (pageWidth/ 2)+ (PDF_SIZE_MARGIN_LEFT/ 4);
			}
			break;
		case 1:
			if (order == NUP_ORDER_4UP_UPPERLEFT_TO_RIGHT || order == NUP_ORDER_4UP_UPPERRIGHT_TO_BOTTOM) {
				x = (pageWidth/ 2)+ (PDF_SIZE_MARGIN_LEFT/ 4);
			} else {
				x = PDF_SIZE_MARGIN_LEFT;
			}
			break;
		case 2:
			if (order == NUP_ORDER_4UP_UPPERLEFT_TO_RIGHT || order == NUP_ORDER_4UP_UPPERRIGHT_TO_BOTTOM) {
				x = PDF_SIZE_MARGIN_LEFT;
			} else {
				x = (pageWidth/ 2)+ PDF_SIZE_MARGIN_LEFT;
			}
			break;
		case 3:
			if (order == NUP_ORDER_4UP_UPPERLEFT_TO_RIGHT || order == NUP_ORDER_4UP_UPPERLEFT_TO_BOTTOM) {
				x = (pageWidth/ 2)+ (PDF_SIZE_MARGIN_LEFT/ 4);
			} else {
				x = PDF_SIZE_MARGIN_LEFT;
			}
			break;
		}
		break;
	}

	LOGD("x:%d\n", x);
	return x;
}

/**
 * getContentY()
 * コンテンツの開始Y座標を返す
 *
 */
int PDFCreator::getContentY(int count)
{
	int y = 0;
	switch(nup) {
	case N_UP_1:
	case N_UP_2:
		// 2UPレイアウトは横固定なので、画像が縦であろうと横であろうと
		// 底辺は同じ
		y = PDF_SIZE_MARGIN_TOP;
		break;
	case N_UP_4:
		switch(count) {
		case 0:
			y = (pageHeight/ 2)+ (PDF_SIZE_MARGIN_BOTTOM/ PDF_SIZE_MARGIN_HEIGHT_BETWEEN);
			break;
		case 1:
			if (order == NUP_ORDER_4UP_UPPERLEFT_TO_RIGHT || order == NUP_ORDER_4UP_UPPERRIGHT_TO_LEFT) {
				y = (pageHeight/ 2)+ (PDF_SIZE_MARGIN_BOTTOM/ PDF_SIZE_MARGIN_HEIGHT_BETWEEN);
			} else {
				y = PDF_SIZE_MARGIN_BOTTOM;
			}
			break;
		case 2:
			if (order == NUP_ORDER_4UP_UPPERLEFT_TO_RIGHT || order == NUP_ORDER_4UP_UPPERRIGHT_TO_LEFT) {
				y = PDF_SIZE_MARGIN_BOTTOM;
			} else {
				y = (pageHeight/ 2)+ (PDF_SIZE_MARGIN_BOTTOM/ PDF_SIZE_MARGIN_HEIGHT_BETWEEN);
			}
			break;
		case 3:
			y = PDF_SIZE_MARGIN_BOTTOM;
			break;
		}
		break;
	}

	LOGD("y:%d\n", y);
	return y;
}

/**
 * isRotation()
 * コンテンツの90度変換が必要かをチェックする
 *
 */
bool PDFCreator::isRotation(int count)
{
	// index チェック
	if (numElements <= count) {
		LOGD("error invalid index:%d in:%d", count, numElements)
		return false;
	}

	// ElementBase NULLチェック
	ElementBase* element = elements[count];
	if (element == NULL) {
		LOGD("error ElementBase:NULL");
		return false;
	}

	switch (nup) {
	//case N_UP_1:
	//case N_UP_2:
	//	// 1UP/2UP時は縦固定のため
	//	// 画像のレイアウトが横であれば変換必要
	//	if (!element->isPortrait()) {
	//		LOGD("Rotation:%d", count);
	//		return true;
	//	}
	//	break;
    case N_UP_1:
    case N_UP_2:
	case N_UP_4:
		// 1UP、4UP時はPDFレイアウトと画像のレイアウトが逆であれば
		// 90度変換が必要
		if (isPortrait) {
			if (!element->isPortrait()) {
				LOGD("Rotation:%d", count);
				return true;
			}
		} else {
			if (element->isPortrait()) {
				LOGD("Rotation:%d", count);
				return true;
			}
		}
		break;
	}
	return false;
}


/**
 * createElements()
 * JPEG,G4,G3,NoneCompエレメントを生成する
 *
 */
int PDFCreator::createElements(char* pathJpeg[])
{
	return createElements(pathJpeg, ELMTYPE_JPEG, NULL, NULL);
}
int PDFCreator::createElements(char* pathJpeg[], int type, int width[], int height[])
{
	LOGD("num:%d type:%d\n", numElements, type);

	elements = new ElementBase*[numElements];
	if (elements == NULL) {
		LOGD("error:elements == NULL\n");
		return -1;
	}

	for (int i= 0; i< numElements; i++ ){
		ElementBase* element = NULL;
		switch (type) {
		case ELMTYPE_JPEG:
			element = new JpegElement();
			element->init();
			break;
		case ELMTYPE_G4:
			element = new G4Element();
			element->init();
			element->setWidthAndHeight(width[i], height[i]);
			break;
		case ELMTYPE_G3:
			element = new G3Element();
			element->init();
			element->setWidthAndHeight(width[i], height[i]);
			break;
		case ELMTYPE_NONECOMP:
			element = new NonCompElement();
			element->init();
			element->setWidthAndHeight(width[i], height[i]);
			break;
		}
		if (element == NULL) {
			LOGD("error:element == NULL\n");
			return -1;
		}

		/***********************************************/
		LOGD("element->type:%d\n", element->type);

		// jpegファイルをロード
		if (element->loadElement(pathJpeg[i]) != ERROR_NONE) {
			LOGD("error:loadJpegFile == error\n");
			return -1;
		}
		// １枚目の画像の向きで作成するPDFのレイアウトを決定する
		if (i == 0) {
			isPortrait = element->isPortrait();
			changeTargetPaperLayout();
		}

		elements[i] = element;
	}

	return ERROR_NONE;
}

/**
 * openCreatePDFFile()
 * PDF生成用ファイルをopenする
 *
 */
int PDFCreator::openCreatePDFFile()
{
	pFile = fopen(path, "wb+");
	if(pFile == NULL) {
		LOGD("openCreatePDFFile() error:fopen failed\n");
		return -1;
	}

	return ERROR_NONE;
}

/**
 * createPreDifinedElements()
 * 先に生成が必要なエレメントの生成を行う
 *
 */
int PDFCreator::createPreDifinedElements()
{
	LOGD("createPreDifinedElements()\n");
	createNonUsedReference();
	createPageListElement();
	createCatalogElement();
	return ERROR_NONE;
}

/**
 * createNonUsedReference()
 * 相互参照のオブジェクト0(使用しない)を生成する
 *
 */
int PDFCreator::createNonUsedReference()
{
	PDFElement* elem = pElmManager->createPDFElement();
	elem->type = TYPE_NONE_USED;
	return ERROR_NONE;
}

/**
 * createPageListElement()
 * ページリストオブジェクトを生成する
 *
 */
int PDFCreator::createPageListElement()
{
	PDFElement* elem = pElmManager->createPDFElement();
	elem->type = TYPE_PAGE_LIST;
	return ERROR_NONE;
}

/**
 * createCatalogElement()
 * カタログオブジェクトを生成する
 *
 */
int PDFCreator::createCatalogElement()
{
	PDFElement* elem = pElmManager->createPDFElement();
	elem->type = TYPE_CATALOG;
	return ERROR_NONE;
}

/**
 * setVersion()
 * バージョン情報を設定する
 *
 */
int PDFCreator::setVersion()
{
	fprintf(pFile, "%%PDF-1.4 SharpDeskMobile NUP\n");
	fprintf(pFile, "%%Sharp Non-Encryption\n");
	return ERROR_NONE;
}

/**
 * setCatalog()
 * カタログ情報を設定する
 *
 */
int PDFCreator::setCatalog()
{
	TRACE();

	PDFElement* elem = pElmManager->searchElement(TYPE_CATALOG);
	elem->position = ftell(pFile);

	fprintf(pFile,"%d 0 obj\n",elem->index);
	fprintf(pFile,"<<\n");
	fprintf(pFile,"/Type /Catalog\n");
	fprintf(pFile,"/Pages %d 0 R\n", pElmManager->searchIndex(TYPE_PAGE_LIST));
	fprintf(pFile,">>\n");
	fprintf(pFile,"endobj\n");

	return ERROR_NONE;
}

/**
 * setPageList()
 * ページリスト情報を設定する
 *
 */
int PDFCreator::setPageList()
{
	TRACE();

	PDFElement* elem = pElmManager->searchElement(TYPE_PAGE_LIST);
	elem->position = ftell(pFile);

	fprintf(pFile,"%d 0 obj\n",elem->index);
	fprintf(pFile,"<<\n");
	fprintf(pFile,"/Type /Pages\n");

	// ページ数と最初のインデックスを取得しておく
	int pageNum = pElmManager->getNumOfType(TYPE_PAGE);
	int index = pElmManager->searchIndex(TYPE_PAGE);
	fprintf(pFile,"/Kids [ ");
	// ページを設定
	for (int i= 0; i< pageNum; i++ ){
		fprintf(pFile,"%d 0 R ", index);
		index = pElmManager->searchIndex(index, TYPE_PAGE);
	}
	fprintf(pFile,"]\n");

	fprintf(pFile,"/Count %d\n", pageNum);
	fprintf(pFile,">>\n");
	fprintf(pFile,"endobj\n");
	return ERROR_NONE;
}

/**
 * setKidsPage()
 * ページ情報を設定する
 *
 */
int PDFCreator::setKidsPage()
{
	TRACE();

	PDFElement* elem = pElmManager->createPDFElement();
	elem->type = TYPE_PAGE;
	elem->position = ftell(pFile);

	fprintf(pFile,"%d 0 obj\n", elem->index);
	fprintf(pFile,"<<\n");
	fprintf(pFile,"/Type /Page\n");
	fprintf(pFile,"/Parent %d 0 R\n", pElmManager->searchIndex(TYPE_PAGE_LIST));
	// リソースとコンテンツはこのページの連番をオブジェクトIDとするため
	// 必ず、この次にリソースとコンテンツを設定する必要がある
	fprintf(pFile,"/Resources %d 0 R\n", elem->index+ 1);
	fprintf(pFile,"/Contents %d 0 R\n", elem->index+ 2);
	fprintf(pFile,"/MediaBox [0 0 %d %d]\n",pageWidth,pageHeight);
	fprintf(pFile,">>\n");
	fprintf(pFile,"endobj\n");

	return ERROR_NONE;
}

/**
 * setResource()
 * リソースを設定する
 *
 */
int PDFCreator::setResource()
{
	TRACE();

	PDFElement* elem = pElmManager->createPDFElement();
	elem->type = TYPE_RES;
	elem->position = ftell(pFile);

	fprintf(pFile,"%d 0 obj\n", elem->index);
	fprintf(pFile,"<<\n");

	ElementBase* element = elements[consumedJpegNum];
	int type = (element == NULL)? ELMTYPE_JPEG: element->type;
	switch (type) {
	case ELMTYPE_JPEG:
		fprintf(pFile,"/ProcSet [/PDF /ImageC]\n");
		break;
	case ELMTYPE_G4:
	case ELMTYPE_G3:
	case ELMTYPE_NONECOMP:
		fprintf(pFile,"/ProcSet [/PDF /ImageB]\n");
		break;
	}

	// リソースの次はコンテンツ、その次にXOBject
	fprintf(pFile,"/XObject << ");
	int imageNum = consumedJpegNum+ 1;
	int xobjeId = elem->index+ 2;
	LOGD("consumedJpegNum:%d imageNum:%d", consumedJpegNum, imageNum);
	for (int i= 0; i< nup; i++) {
		if (numElements<= imageNum- 1) {
			LOGD("no resource in the queue. num:%d consumed:%d \n", numElements, imageNum- 1);
			break;;
		}
		fprintf(pFile,"/Img%d %d 0 R ", imageNum++, xobjeId++);
	}
	fprintf(pFile,">>\n");
	fprintf(pFile,">>\n");
	fprintf(pFile,"endobj\n");
	return ERROR_NONE;
}

/**
 * setContent()
 * コンテンツを設定する
 *
 */
int PDFCreator::setContent()
{
	TRACE();

	PDFElement* elem = pElmManager->createPDFElement();
	elem->type = TYPE_CONTENT;
	elem->position = ftell(pFile);

	ElementBase* element = NULL;
	char stream[512];
	char temp[128];
	int imageNum = consumedJpegNum+ 1;
	char command[] = "q\n%d 0 0 %d %d %d cm\n/Img%d Do\nQ";
	char cmdRotate[] = "q\n%d 0 0 %d %d %d cm\n0 1 -1 0 0 0 cm\n/Img%d Do\nQ";
	char* imageCmd = NULL;

	memset(stream, 0, sizeof(stream));
	for (int i= 0; i< nup; i++ ){
		if (numElements<= imageNum- 1) {
			LOGD("no contents in the queue. num:%d consumed:%d \n", numElements, consumedJpegNum);
			break;;
		}

		// コンテンツ対象のElementBaseを取得
		element = elements[consumedJpegNum+ i];
		if (element == NULL) {
			LOGD("error ElementBase:NULL");
			continue;
		}

		// ポジションオブジェクトを生成し配置を計算
		ContentPosition* contentPosition = new ContentPosition(pageWidth, pageHeight, element->width, element->height, nup, order, i);
		contentPosition->setPortrait(element->isPortrait());
		contentPosition->calc();

		// バッファを初期化
		memset(temp, 0, sizeof(temp));

		// ローテーションチェック
		if (isRotation(imageNum- 1)) {
			imageCmd = cmdRotate;
		} else {
			imageCmd = command;
		}

		// stream生成
		sprintf(temp, imageCmd,
				contentPosition->width, contentPosition->height,
				contentPosition->x, contentPosition->y,
				imageNum++
		);

		if (i== 0) {
			strcpy(stream, temp);
		} else {
			strcat(stream, "\n");
			strcat(stream, temp);
		}
	}
	size_t len = strlen(stream);

	/* content length */
	fprintf(pFile,"%d 0 obj\n", elem->index);
	fprintf(pFile,"<<\n");
	fprintf(pFile,"/Length %ld\n", len);
	fprintf(pFile,">>\n");
	fprintf(pFile,"stream\n");

	/* stream */
	fprintf(pFile,"%s\n", stream);
	fprintf(pFile,"endstream\n");
	fprintf(pFile,"endobj\n");

	TRACE();
	return ERROR_NONE;
}

/**
 * setXObject()
 * XObjectを設定する
 *
 */
int PDFCreator::setXObject()
{
	if (numElements<= consumedJpegNum) {
		LOGD("no file in the queue. num:%d consumed:%d \n", numElements, consumedJpegNum);
		return ERROR_NONE;
	}
	TRACE();

	PDFElement* elem = pElmManager->createPDFElement();
	elem->type = TYPE_XOBJECT;
	elem->position = ftell(pFile);
	ElementBase* element = elements[consumedJpegNum];

	fprintf(pFile,"%d 0 obj\n", elem->index);
	fprintf(pFile,"<<\n");
	fprintf(pFile,"/Type /XObject\n");
	fprintf(pFile,"/Subtype /Image\n");
	fprintf(pFile,"/Name /Img%d\n", consumedJpegNum+ 1);

	switch (element->type) {
	case ELMTYPE_G4:
		fprintf(pFile,"/Filter /CCITTFaxDecode\n");
		fprintf(pFile,"/DecodeParms <<  /K -1 /Columns %d /Rows %d >>\n", element->width, element->height);
		fprintf(pFile,"/Width %d\n", element->width);
		fprintf(pFile,"/Height %d\n", element->height);
		fprintf(pFile,"/BitsPerComponent 1\n");
		break;
	case ELMTYPE_G3:
		fprintf(pFile,"/Filter /CCITTFaxDecode\n");
		fprintf(pFile,"/DecodeParms <<  /K 0 /Columns %d /Rows %d >>\n", element->width, element->height);
		fprintf(pFile,"/Width %d\n", element->width);
		fprintf(pFile,"/Height %d\n", element->height);
		fprintf(pFile,"/BitsPerComponent 1\n");
		break;
	case ELMTYPE_NONECOMP:
		fprintf(pFile,"/Width %d\n", element->width);
		fprintf(pFile,"/Height %d\n", element->height);
		fprintf(pFile,"/BitsPerComponent 1\n");
		break;
	case ELMTYPE_JPEG:
	default:
		fprintf(pFile,"/Filter /DCTDecode\n");
		fprintf(pFile,"/Width %d\n", element->width);
		fprintf(pFile,"/Height %d\n", element->height);
		fprintf(pFile,"/BitsPerComponent 8\n");
		break;
	}

	switch (element->colorSpace) {
	case 1:
		fprintf(pFile,"/ColorSpace /DeviceGray\n");
		break;
	case 3:
		fprintf(pFile,"/ColorSpace /DeviceRGB\n");
		break;
	case 4:
		fprintf(pFile,"/ColorSpace /DeviceCMYK\n");
		fprintf(pFile,"/Decode[1 0 1 0 1 0 1 0]\n"); /* Photoshop CMYK (NOT BIT) */
		break;
	}
	fprintf(pFile,"/Length %ld\n",element->size);
	fprintf(pFile,">>\n");
	fprintf(pFile,"stream\n");
	if (element->writeElement(pFile) == -1) {
		LOGD("mergeJpegToPdf() WriteJpegFile error! \n");
		return(-1);
	} else {
		consumedJpegNum++;
	}
	fprintf(pFile,"\nendstream\n");
	fprintf(pFile,"endobj\n");

	LOGD("No.%d done \n", consumedJpegNum);
	return ERROR_NONE;
}

/**
 * setCrossReferenceTable()
 * PDFにCrossReferenceTableを書き込む
 *
 */
int PDFCreator::setCrossReferenceTable()
{
	TRACE();

	pElmManager->positionXref = ftell(pFile);
	fprintf(pFile,"xref\n");
	fprintf(pFile,"0 %d\n", pElmManager->num);

	for (
		PDFElement* elem = pElmManager->getTopElement();
		elem !=NULL;
		elem = pElmManager->getNextElement(elem)
	) {
		if (elem->type == TYPE_NONE_USED) {
			fprintf(pFile,"0000000000 65535 f \n");
		} else {
			fprintf(pFile,"%0.10ld 00000 n \n",elem->position);
		}
	}
	return ERROR_NONE;
}

/**
 * setTrailer()
 * trailer情報を書き込む
 *
 */
int PDFCreator::setTrailer()
{
	TRACE();

	/* trailer */
	fprintf(pFile,"trailer\n");
	fprintf(pFile,"<<\n");
	fprintf(pFile,"/Size %d\n", pElmManager->num);
	fprintf(pFile,"/Root %d 0 R\n", pElmManager->searchIndex(TYPE_CATALOG));
	fprintf(pFile,">>\n");
	fprintf(pFile,"startxref\n");
	fprintf(pFile,"%ld\n", pElmManager->positionXref);
	fprintf(pFile,"%%%%EOF\n");
	return ERROR_NONE;
}

/**
 * createPDF()
 * PDFを生成する
 *
 */
int PDFCreator::createPDF()
{
	LOGD("start \n");

	// 先に生成が必要なオブジェクトを生成
	if (createPreDifinedElements() != ERROR_NONE) {
		return -1;
	}

	// バージョンをセット
	if (setVersion() != ERROR_NONE) {
		return -1;
	}

	// 各ページの設定を行う
	int pageNum = getPageNum();
	LOGD("pageNum:%d \n", pageNum);
	for (int i= 0; i< pageNum; i++ ){
		// 各ページ情報をセット
		if (setKidsPage() != ERROR_NONE) {
			return -1;
		}

		// リソース情報をセット
		if (setResource() != ERROR_NONE) {
			return -1;
		}

		// コンテント情報をセット
		if (setContent() != ERROR_NONE) {
			return -1;
		}

		for (int j= 0; j< nup; j++ ){
			// XObject情報をセット
			if (setXObject() != ERROR_NONE) {
				return -1;
			}
		}
	}

	// ページリスト情報をセット
	if (setPageList() != ERROR_NONE) {
		return -1;
	}

	// カタログ情報をセット
	if (setCatalog() != ERROR_NONE) {
		return -1;
	}

	// 相互参照情報をセット
	if (setCrossReferenceTable() != ERROR_NONE) {
		return -1;
	}

	// trailer情報をセット
	if (setTrailer() != ERROR_NONE) {
		return -1;
	}

	LOGD("done \n");
	return ERROR_NONE;
}

/**
 * mergeJpegToPdf()
 * 複数JpegファイルをN-UP対応しPDFを生成する
 *
 */
int PDFCreator::mergeJpegToPdf(char* pathJpeg[], int numFile, char* pathPdf, int printForm, int nupFrom, int srcOrder, bool printBorder)
{

	TRACE();

	// パスチェック
	path = pathPdf;
	if (pathPdf == NULL || pathJpeg == NULL) {
		LOGD("error:invalid param\n");
		return -1;
	}

	// jpeg ファイル数チェック
	numElements = numFile;
	if ( numFile == 0) {
		LOGD("error:numFile == 0\n");
		return -1;
	}

	// nupチェック
	if (setNup(nupFrom) != ERROR_NONE) {
		return -1;
	}

	// ORDERチェック
	if (setOrder(srcOrder) != ERROR_NONE) {
		return -1;
	}

	// 用紙サイズチェック
	if (setPrintForm(printForm) != ERROR_NONE) {
		return -1;
	}

	// 枠線用不要パラム設定
	hasPrintBorder = printBorder;

	LOGD("nup:%d hasPrintBorder:%d numElements:%d order:%d\n", nup, hasPrintBorder, numElements, order);

	// ページの縦横サイズを設定する
	if (setTargetPaperSize() != ERROR_NONE) {
		return -1;
	}

	// エレメント生成
	if (createElements(pathJpeg) != ERROR_NONE) {
		return -1;
	}

	// PDF生成ファイルをオープン
	if (openCreatePDFFile() != ERROR_NONE) {
		return -1;
	}

	// PDFを生成する
	if (createPDF() != ERROR_NONE) {
		return -1;
	}

	clear();
	TRACE();

	return ERROR_NONE;
}

/**
 * mergeToPdf()
 * N-UP対応PDFを生成する
 *
 */
int PDFCreator::mergeToPdf(char* pathJpeg[], int numFile, int width[], int height[], int type, char* pathPdf, int printForm, int nupFrom, int srcOrder, bool printBorder)
{

	TRACE();

	// パスチェック
	path = pathPdf;
	if (pathPdf == NULL || pathJpeg == NULL) {
		LOGD("error:invalid param\n");
		return -1;
	}

	// jpeg ファイル数チェック
	numElements = numFile;
	if ( numFile == 0) {
		LOGD("error:numFile == 0\n");
		return -1;
	}

	// nupチェック
	if (setNup(nupFrom) != ERROR_NONE) {
		return -1;
	}

	// ORDERチェック
	if (setOrder(srcOrder) != ERROR_NONE) {
		return -1;
	}

	// 用紙サイズチェック
	if (setPrintForm(printForm) != ERROR_NONE) {
		return -1;
	}

	// 枠線用不要パラム設定
	hasPrintBorder = printBorder;

	LOGD("nup:%d hasPrintBorder:%d numElements:%d order:%d\n", nup, hasPrintBorder, numElements, order);

	// ページの縦横サイズを設定する
	if (setTargetPaperSize() != ERROR_NONE) {
		return -1;
	}

	// エレメント生成
	if (createElements(pathJpeg, type, width, height) != ERROR_NONE) {
		return -1;
	}

	// PDF生成ファイルをオープン
	if (openCreatePDFFile() != ERROR_NONE) {
		return -1;
	}

	// PDFを生成する
	if (createPDF() != ERROR_NONE) {
		return -1;
	}

	clear();
	TRACE();

	return ERROR_NONE;
}

/**
 * clear()
 * PDFCreatorオブジェクトを破棄する
 *
 */
void PDFCreator::clear() {

	TRACE();

	// PDF生成ファイルをclose
	if (pFile != NULL) {
		fclose(pFile);
		pFile = NULL;
	}

	if (elements == NULL) {
		return;
	}

	for (int i= 0; i< numElements; i++ ){
		// jpegエレメントを解放
		ElementBase* element = elements[i];
		if (element != NULL) {
			element->clear();
			delete element;
		}
	}

	// Jpegエレメント配列を解放
	delete elements;
	elements = NULL;
	return;
}





