#include "JpegElement.h"

/**
 * デストラクタ
 */
JpegElement::~JpegElement() {
	closeElement();
}


/**
 * init()
 * メンバの初期化を行う
 *
 */
void JpegElement::init()
{
	TRACE();
	pFile = NULL;
	path = NULL;
	width = 0;
	height = 0;
	size = 0;
	colorSpace = 3;
	type = ELMTYPE_JPEG;
}

/**
 * clear()
 * JpegElementオブジェクトを破棄する
 *
 */
void JpegElement::clear() {
	TRACE();
	closeElement();
}

/**
 * getProperty()
 * jpegのサイズ情報を取得する
 *
 */
int JpegElement::getProperty() {

	TRACE();

	if (pFile == NULL) {
		return -1;
	}

	WORD wrk;
	BYTE Sampling;

	WORD SOF0 =0xFFC0; /* Normal */
	WORD SOF2 =0xFFC2; /* Progressive */

	/* イメージ開始位置をチェック */
	if (fread(&wrk, sizeof(WORD), 1, pFile)< 1) {
		return -1;
	}
	if (swapEndian(wrk) != 0xFFD8) {
		return -1;
	}

	while (true) {
		if (fread(&wrk, sizeof(WORD), 1, pFile)< 1) {
			return -1;
		} else {
			wrk = swapEndian(wrk);
		}
		/* JPEG Maker */
		if ((wrk==SOF0) | (wrk==SOF2)) {
			/* Skip Segment Length  */
			if (fseek(pFile, ftell(pFile)+2, SEEK_SET)) {
				return -1;
			}

			/* Skip Sample */
			if (fseek(pFile, ftell(pFile)+1, SEEK_SET)) {
				return -1;
			}

			/* Height */
			if (fread(&wrk, sizeof(WORD), 1, pFile)< 1) {
				return -1;
			} else {
				height = swapEndian(wrk);
			}

			/* Width */
			if (fread(&wrk, sizeof(WORD), 1, pFile)< 1) {
				return -1;
			} else {
				width = swapEndian(wrk);
			}

			/* ColorMode */
			if (fread(&Sampling, sizeof(BYTE), 1, pFile)< 1) {
				return -1;
			}
			switch (Sampling) {
			case 1:
				colorSpace = 1;
				break;
			case 3:
				colorSpace = 3;
				break;
			case 4:
				colorSpace = 4;
				break;
			default:
				colorSpace = 3;
				break;
			}
			break;
		}
		else if ((wrk==0xFFFF) | (wrk==0xFFD9)) {
			return -1;
		}

		/* Skip Segment */
		if (fread(&wrk, sizeof(WORD), 1, pFile)< 1) {
			return -1;
		}

		if (fseek(pFile, ftell(pFile)+ swapEndian(wrk)- 2, SEEK_SET )) {
			return -1;
		}
	}

	LOGD("h:%d w:%d\n", height, width);

	return 0;
}

