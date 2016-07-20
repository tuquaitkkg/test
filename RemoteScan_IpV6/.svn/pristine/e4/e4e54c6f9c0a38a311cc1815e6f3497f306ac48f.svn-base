#include "ElementBase.h"

/**
 * ElementBase()
 * コンストラクタ
 *
 */
ElementBase::ElementBase()
{
	TRACE();

	pFile = NULL;
	path = NULL;
	width = 0;
	height = 0;
	size = 0;
}

/**
 * openElement()
 * ファイルをオープンする
 *
 */
int ElementBase::openElement()
{
	TRACE();

	pFile = fopen(path, "rb");
	if (pFile == NULL) {
		return -1;
	}
	return 0;
}

/**
 * closeElement()
 * jpegファイルをクローズする
 *
 */
int ElementBase::closeElement()
{
	TRACE();

	if (pFile != NULL) {
		fclose(pFile);
		pFile = NULL;
	}
	return 0;
}

/**
 * swapEndian()
 * エンディアンを変更する
 *
 */
WORD ElementBase::swapEndian(WORD S)
{
	return ((S & 0x00FF) << 8) | ((S & 0xFF00) >> 8)  ;
}

/**
 * getFileSize()
 * ファイルサイズを取得する
 *
 */
int ElementBase::getFileSize()
{
	long Pos;

	Pos =ftell(pFile);
	fseek(pFile, 0, SEEK_END );
	size = ftell(pFile);
	fseek(pFile, Pos, SEEK_SET );

	LOGD("size:%ld\n", size);
	return 0;
}

/**
 * isPortrait()
 * 画像が縦レイアウトかをチェックする
 *
 */
bool ElementBase::isPortrait()
{
	bool ret = true;
	ret = (width<= height);
	LOGD("portrate:%s\n", ((ret== true)? "true": "false"));
	return ret;
}

/**
 * loadElement()
 * ファイルをロードし、オブジェクトの構成を整える
 *
 */
int ElementBase::loadElement(char* pathFrom) {

	TRACE();

	// パスチェック
	if (pathFrom == NULL) {
		LOGD("loadElement() error:pathFrom == NULL\n");
		return -1;
	} else {
		path = pathFrom;
	}

	// jpegファイルをオープン
	if (openElement() != ERROR_NONE) {
		LOGD("loadElement() error:openElement() failed\n");
		return -1;
	}

	// ファイルサイズを取得
	if (getFileSize() != ERROR_NONE) {
		LOGD("loadElement() error:getFileSize() failed\n");
		return -1;
	}

	// プロパティを取得
	if (getProperty() != ERROR_NONE) {
		LOGD("loadElement() error:getProperty() failed\n");
		return -1;
	}

	return ERROR_NONE;
}

/**
 * writeElement()
 * バイナリをPDFに書き込む
 *
 */
int ElementBase::writeElement(FILE* pFileDest) {

	TRACE();

	// パスチェック
	if (pFileDest == NULL) {
		return -1;
	}

	BYTE*	buffer;
	buffer = (BYTE *)malloc(size + 1);
	if (buffer==NULL) {
		return -1;
	}

	fseek(pFile, 0, SEEK_SET);
	fread(buffer, 1, size, pFile);
	fwrite(buffer, 1, size, pFileDest);
	free(buffer);
	fseek(pFile, 0, SEEK_SET);

	TRACE();
	return 0;
}

/**
 * setWidthAndHeight()
 * 幅と高さを設定する
 *
 */
void ElementBase::setWidthAndHeight(int w, int h)
{
	width = w;
	height = h;
	LOGD("setWidthAndHeight() w(%d) h(%d)\n", w, h);
	return;
}

/**
 * virtual module dummy defined
 */
ElementBase::~ElementBase(){}
void ElementBase::init(){}
void ElementBase::clear(){}
int ElementBase::getProperty(){return 0;}
