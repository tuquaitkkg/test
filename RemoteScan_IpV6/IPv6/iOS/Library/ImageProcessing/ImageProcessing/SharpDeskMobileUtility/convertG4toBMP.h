//////////////////////////////////////////////////////////////////////
//
// convertG4toBMP.h: convertG4toBMP クラスのインターフェイス
// G4圧縮の画像ファイルをBMPファイルにデコードする
//
//////////////////////////////////////////////////////////////////////

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ComDef.h"

// 圧縮パターン定義
enum NOTATION {
	P, H, V0,
	VR1, VR2, VR3,
	VL1, VL2, VL3,
	END
};

// 入力ファイルよりBMPファイルを出力する
int cnvG4BMP( const char * pInputFilePath , char * pOutputFilePath );

// バイナリデータよりBMPファイルを出力する
int cnvG4BMPFromData( BYTE * pInputImageData , int intWidth , int intHeight , const char * pOutputFilePath );

// ビットマップファイルを出力する
int createBitmapImage(int width, int height , int pageCount , int mode , const char * pOutputPath );

// 読み込んだメモリからデータを取得する
int  getValue( BYTE * list , int start , int length , int byteOrder );

// 圧縮モードを取得する
int  getMode();

// Pass modeの解析
int  pass( int * ref , int * code , int a0 , int width );

// horizontal modeの解析
int  horizontal( int * ref, int * code , int a0 , int width );

// vertical modeの解析
int  vertical(int * ref, int * code , int a0 , int shift , int width );

// B1の位置を求める
int  getB1( int color , int * ref , int a0 , int width );

// B2の位置を求める
int  getB2( int color , int * ref , int a0 , int width );

// 色の設定する長さを求める
int  getRunLength( int color );

// 色の設定する長さを求める
int  getRunLength( bool boolBW );

// 色を反転させる
int  turnColor( int color );

// 読み込んだメモリからデータを取得する
char get();

// メモリの更新を行う
void pushArray( void );

// 白色の設定する長さを求める
int  getWhiteLength( char * key );

// 黒色の設定する長さを求める
int  getBlackLength( char * key );
