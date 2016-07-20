//////////////////////////////////////////////////////////////////////
//
// convertG4toBMP.cpp: convertG4toBMP クラスのインターフェイス
// G4圧縮の画像ファイルをBMPファイルにデコードする
//
//////////////////////////////////////////////////////////////////////

#include "convertG4toBMP.h"

const char * strInputFilePath;		// 入力ファイル名
BYTE *       bInputImageData;		// 入力ファイル読み込み領域
int          currentListPosition;	// 読み込みデータ位置
int          currentArrayPosition;	// 読み込みデータ位置
char *       ary;					// 入力ファイル読み込み領域
char *       strOutputFilePathAll;	// 出力ファイル名

// 入力ファイルよりBMPファイルを出力する
int cnvG4BMP( const char * pInputFilePath , char * pOutputFilePath ){

	int    byteOrder      = 0;
	int    idfp           = 0;
	int    entCount       = 0;
	int    dataPointer    = 0;
	int    width          = 0;
	int    height         = 0;
	int    pageCount      = 0;
	int    pageCountAll   = 0;
	long   inputImageSize = 0;
	int    ret            = 0;
	size_t    iDotPos        = 0;
	BYTE   bTmp[1];
	FILE * rFp;

	// ファイル名取得
	strInputFilePath = pInputFilePath;

	// ファイルフォーマットチェック
	for( size_t j = strlen( strInputFilePath ) - 1 ; j != 0 ; j-- ){
		char tmp[1];
		strncpy(tmp , &strInputFilePath[j] , 1 );
		if( strncmp( tmp , "." , 1 ) == 0 ){
			iDotPos = j;
			break;
		}
	}
	// 拡張子なしは対応外
	if( iDotPos == 0 ){
		return -6;
	}

	// 拡張子が"tiff"、"tif"以外は対応外
	if( ( strcmp( &strInputFilePath[ iDotPos + 1 ] , "tiff" ) != 0 )
	&&  ( strcmp( &strInputFilePath[ iDotPos + 1 ] , "tif"  ) != 0 ) ){
		return -6;
	}

	// 入力ファイル読み込み
	rFp = fopen( strInputFilePath , "rb" );
	if( rFp == NULL ){
		return -6;
	}

	// ファイルサイズ取得
	while( !feof( rFp ) ){
		fread( (char *)bTmp , sizeof( BYTE ) , 1 , rFp );
		inputImageSize++;
    }

	// サイズ分の領域を確保
	bInputImageData = new BYTE[ inputImageSize * sizeof( BYTE ) + 1 ];
	if( bInputImageData == NULL ){
		return -2;
	}

	// 領域初期化
	memset( bInputImageData , 0 , inputImageSize * sizeof( BYTE ) + 1 );

	// 先頭に戻る
	fseek( rFp , 0 , SEEK_SET );

	// ファイル読み込み
	fread( (char *)bInputImageData , sizeof( BYTE ) , inputImageSize , rFp );

	// ファイルを閉じる
	fclose( rFp );

	// バイトオーダーを確定
	if( ( bInputImageData[0] == 0x4d ) && ( bInputImageData[0] == 0x4d ) ){
		byteOrder = 0;
	}
	else if( ( bInputImageData[0] == 0x49 ) && ( bInputImageData[0] == 0x49 ) ){
		byteOrder = 1;
	}
	else{
		// メモリ解放
		free( bInputImageData );

		return -1;
	}

	// IDFポインタ取得
	idfp = getValue( bInputImageData , 4 , 4 , byteOrder );

	while( true ){
		// ページ数
		pageCount++;

		// エントリカウント取得
		entCount = getValue( bInputImageData , idfp , 2 , byteOrder );
		if( entCount == 0 ){
			// メモリ解放
			free( bInputImageData );

			return -1;
		}

		// ポインタを進める
		idfp += 2;

		for ( int i = 0 ; i < entCount ; i++ ) {
			idfp += 12;
		}

		// 次のIDFポインタ取得
		idfp = getValue( bInputImageData , idfp , 4 , byteOrder );
		if( idfp == 0 ){
			break;
		}

		entCount = 0;
	}

	// 総ページ数取得
	pageCountAll = pageCount;
	pageCount    = 0;

	// 出力ファイル名格納領域を確保
	strOutputFilePathAll = new char[ pageCountAll * 256 + 1 ];
	if( strOutputFilePathAll == NULL ){
		// メモリ解放
		free( bInputImageData );

		return -2;
	}

	// 領域初期化
	memset( strOutputFilePathAll , '\0' , pageCountAll * 256 );

	// IDFポインタ取得
	idfp = getValue( bInputImageData , 4 , 4 , byteOrder );

	while( true ){
		// ページ数
		pageCount++;

		// エントリカウント取得
		entCount = getValue( bInputImageData , idfp , 2 , byteOrder );
		idfp += 2;

		for ( int i = 0 ; i < entCount ; i++ ) {

			//IDFエントリタグ
			int tag = getValue( bInputImageData , idfp , 2 , byteOrder );

			//データ
			int data = getValue( bInputImageData , idfp + 8 , 4 , byteOrder );

			switch( tag ){
				//ImageWidth
				case 0x0100:
					width = data;
					break;

				//ImageLength
				case 0x0101:
					height = data;
					break;

				//Compression
				case 0x0103:
					if( data != 4 ){
						// メモリ解放
						free( bInputImageData );
						free( strOutputFilePathAll );

						return -5;
					}
					break;

				//PhotometricInterpretation
				case 0x0106:
					if( data != 0 ){
						// メモリ解放
						free( bInputImageData );
						free( strOutputFilePathAll );

						return -5;
					}
					break;

				//StripOffsets
				case 0x0111:
					dataPointer = data;
					break;

				//StripByteCounts
				case 0x0117:
					break;

			}

			idfp += 12;
		}

		// データ読み込み領域確保
		ary = new char[8];
		if( ary == NULL ){
			// メモリ解放
			free( bInputImageData );
			free( strOutputFilePathAll );

			return -2;
		}

		// 最初の画像データを読み込み
		currentListPosition = dataPointer;
		pushArray();

		// BMP出力
		ret = createBitmapImage( width , height , pageCount , 0 , NULL );
		if( ret < 0 ){
			// メモリ解放
			free( bInputImageData );
			free( strOutputFilePathAll );
			free( ary );

			return ret;
		}

		// 次のIDFポインタ取得
		idfp = getValue( bInputImageData , idfp , 4 , byteOrder );
		if( idfp == 0 ){
			break;
		}

		entCount    = 0;
		dataPointer = 0;
		width       = 0;
		height      = 0;
	}

	for( int i = 0 ; i < pageCountAll ; i++ ){
		// 出力ファイル名取り出し
		strcpy( &pOutputFilePath[ 256 * i ] , &strOutputFilePathAll[ 256 * i ] );
	}

	// メモリ解放
	free( bInputImageData );
	free( strOutputFilePathAll );
	free( ary );

	return pageCountAll;
}

int cnvG4BMPFromData( BYTE * pInputImageData , int intWidth , int intHeight , const char * pOutputFilePath ){

	int width          = 0;
	int height         = 0;
	int ret            = 0;

	char strOutputFilePath[256];

	// パラメータ値取得
	width  = intWidth;
	height = intHeight;

	// イメージデータ取得
	bInputImageData = pInputImageData;

	// 出力ファイル名取得
	strcpy( strOutputFilePath , pOutputFilePath );

	// データ読み込み領域確保
	ary = new char[8];
	if( ary == NULL ){
		// メモリ解放
		free( bInputImageData );

		return -2;
	}

	// 画像データ読み込み
	currentListPosition = 0;
	pushArray();

	// BMP出力
	ret = createBitmapImage( width , height , 0 , 1 , strOutputFilePath );
	if( ret < 0 ){
		// メモリ解放
		free( bInputImageData );

		return ret;
	}

	// メモリ解放
	free( bInputImageData );
	free( ary );

	return 1;
}

// ビットマップファイルを出力する
int createBitmapImage( int width , int height , int pageCount , int mode , const char * pOutputFilePath ) {

	// デコード用
	int * ref            = new int[ width + 2 ];
	int * code           = new int[ width + 2 ];
	int   a0             = 0;
	int   writeHeightPos = 0;
	int   paddingByte    = 0;

	// 出力用
	BYTE   bWhite[3];
	BYTE   bBlack[3];
	BYTE   bPadding[1];
	BYTE   bTemp[1];
	int    iTemp[1];
	size_t    iDotPos = 0;
	char   cPageCount[256];
	char   strOutputFilePath[256];
	FILE * wFp;

	bWhite[0]   = 0xff;
	bWhite[1]   = 0xff;
	bWhite[2]   = 0xff;
	bBlack[0]   = 0x00;
	bBlack[1]   = 0x00;
	bBlack[2]   = 0x00;
	bPadding[0] = 0x00;
	memset( strOutputFilePath , '\0' , sizeof( char ) * 256 );

	// refの末端を未確定(2)に
	ref[ width + 1 ] = 2;

	// codeの末端端も未確定(2)に
	code[ width + 1 ] = 2;

	// refを白に、codeを不定(-1)に
	for (int i = 0; i < width + 1; i++ ){
		ref[i]  = 0;
		code[i] = -1;
	}

	code[0] = 0;

	// ビットマップファイルは1行あたりのバイト数が4バイト
	// 1ピクセルあたり3バイト使用する
	paddingByte = ( width * 3 ) % 4;
	if( paddingByte != 0 ){
		paddingByte = 4 - paddingByte;
	}

	// 出力ファイル名作成
	if( mode == 0 ){
		for( size_t j = strlen( strInputFilePath ) - 1 ; j != 0 ; j-- ){
			char tmp[1];
			strncpy(tmp , &strInputFilePath[j] , 1 );
			if( strncmp( tmp , "." , 1 ) == 0 ){
				iDotPos = j;
				break;
			}
		}
		if( iDotPos == 0 ){
			// メモリ解放
			free( ref );
			free( code );

			return -6;
		}

		sprintf( &cPageCount[0]    , "%d"             , pageCount );
		strncpy( strOutputFilePath , strInputFilePath , iDotPos );
		strcat(  strOutputFilePath , "_out_" );
		strcat(  strOutputFilePath , cPageCount );
		strcat(  strOutputFilePath , ".bmp" );

		// 出力ファイル名保存
		strcpy( &strOutputFilePathAll[ ( pageCount - 1 ) * 256 ] , strOutputFilePath );
	}
	else{
		strcpy( strOutputFilePath , pOutputFilePath );
	}

	// ファイル出力用
	wFp = fopen( strOutputFilePath , "wb" );
	if( wFp == NULL ){
		// メモリ解放
		free( ref );
		free( code );

		return -6;
	}

	// ビットマップヘッダ出力
	// 先頭2バイトに'BM'
	bTemp[0] = 0x42;
	fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );
	bTemp[0] = 0x4d;
	fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );

	// ファイルサイズ
	iTemp[0] = ( ( ( width * 3 ) + paddingByte ) * height ) + 54;
	fwrite( ( char * )&iTemp[0] , sizeof( int ) , 1 , wFp );

	// 予約領域0埋め
	bTemp[0] = 0x00;
	fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );
	fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );
	fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );
	fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );

	// 画像データまでのオフセットデータ
	bTemp[0] = 0x36;
	fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );
	bTemp[0] = 0x00;
	fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );
	fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );
	fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );

	// 情報ヘッダのサイズ
	bTemp[0] = 0x28;
	fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );
	bTemp[0] = 0x00;
	fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );
	fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );
	fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );

	// 画像の幅
	iTemp[0] = width;
	fwrite( ( char * )&iTemp[0] , sizeof( int ) , 1 , wFp );

	// 画像の高さ（左上から右下に書き込むのでマイナス値を書き込む）
	iTemp[0] = height - ( height * 2 );
	fwrite( ( char * )&iTemp[0] , sizeof( int ) , 1 , wFp );

	// プレーン数
	bTemp[0] = 0x01;
	fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );
	bTemp[0] = 0x00;
	fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );

	// 1画素あたりの色数
	bTemp[0] = 0x18;
	fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );
	bTemp[0] = 0x00;
	fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );

	// ヘッダ残り0埋め（24バイト）
	bTemp[0] = 0x00;
	for( int m = 0 ; m < 24 ; m++ ){
		fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );
	}

	// データ解析
	while( true ){

		switch( getMode() ){

			case P:
				a0 = pass( ref , code , a0 , width);
				break;

			case H:
				a0 = horizontal( ref , code , a0 , width );
				break;

			case V0:
				a0 = vertical( ref , code , a0 , 0  , width );
				break;

			case VR1:
				a0 = vertical( ref , code , a0 , 1  , width );
				break;

			case VR2:
				a0 = vertical( ref , code , a0 , 2  , width );
				break;

			case VR3:
				a0 = vertical( ref , code , a0 , 3  , width );
				break;

			case VL1:
				a0 = vertical( ref , code , a0 , -1  , width );
				break;

			case VL2:
				a0 = vertical( ref , code , a0 , -2  , width );
				break;

			case VL3:
				a0 = vertical( ref , code , a0 , -3  , width );
				break;

			case END:
				a0 = horizontal( ref , code , a0 , width );
				break;
				// ファイルクローズ
				fclose( wFp );

				// メモリ解放
				free( ref );
				free( code );

				return -1;
		}

		// a0が末端まで来ていたら、refを差し替えてcode確定
		if( width < a0 ){

			// code確定
			ref = code;

			// 色をファイル出力
			for( int j = 0 ; j < width ; j++ ){
				if( ref[j] == 1){
					fwrite( ( char * )bBlack , sizeof( BYTE ) , 3 , wFp );
				}
				else{
					fwrite( ( char * )bWhite , sizeof( BYTE ) , 3 , wFp );
				}
			}

			// padding分埋める
			for( int m = 0 ; m < paddingByte ; m ++ ){
				fwrite( ( char * )&bPadding[0] , sizeof( BYTE ) , 1 , wFp );
			}

			// 初期化
			code = new int[ width + 2 ];
			if( code == NULL ){
				// メモリ解放
				free( ref );
				free( code );

				return -2;
			}
			code[0]           = 0;
			code[ width + 1 ] = 2;

			for( int i = 1 ; i < width + 1 ; i++ ){
				code[i] = -1;
			}

			// 次の行へ進む
			writeHeightPos++;
			a0 = 0;

			// 最後の行まで書き込んだら終了
			if( height <= writeHeightPos ){
				break;
			}
		}

	}

	// ファイルクローズ
	fclose( wFp );

	// メモリ解放
	free( ref );
	free( code );

	return 1;
}

// 読み込んだメモリからデータを取得する
int getValue( BYTE * imageData , int start , int length , int byteOrder ){

	unsigned int result = 0x00;
	BYTE *       bt     = new BYTE[length];
	BYTE *       b      = new BYTE[length];

	for( int i = 0 ; i < length ; i++ ){
		bt[i] = imageData[ start + i ];
	}

	switch( byteOrder ){
		case 0:
			b = bt;
			break;
		case 1:
			for( int i = 0 , j = length - 1 ; i < length; i++ , j-- ){
				b[j] = bt[i];
			}
			break;
	}

	for( int j = 0 ; j < length ; j++ ){
		unsigned int intBuf = 0;
		intBuf  = b[j];
		intBuf  = intBuf << ( 8 * ( length - 1 - j ) );
		result += intBuf;
	}

	// メモリ解放
	free( bt );
	free( b );

	return result;
}

// 圧縮モードを取得する
int getMode(){

	// 1 V0
	if( get() == '1' ){
		return V0;
	}

	if( get() == '1' ){

		// 011 VR1
		if( get() == '1' ){
			return VR1;
		}

		// 010 VL1
		return VL1;
	}

	// 001 H
	if( get() == '1' ){
		return H;
	}

	// 0001 P
	if( get() == '1' ){
		return P;
	}

	if( get() == '1' ){

		// 000011 VR2
		if( get() == '1' ){
			return VR2;
		}

		// 000010 VL2
		return VL2;
	}

	if( get() == '1' ){

		// 0000011 VR3
		if( get() == '1' ){
			return VR3;
		}

		// 0000010 VL3
		return VL3;
	}

	return END;

}

// Pass modeの解析
int pass( int * ref , int * code , int a0 , int width ){

	int color = code[a0];
	int b2    = getB2( color , ref , a0 , width );

	// a0の色をb2まで書き込む
	for( int i = a0 ; i <= b2 ; i++ ){
		code[i] = color;
	}

	return b2;
}

// Horizontal modeの解析
int horizontal( int * ref, int * code , int a0 , int width ){

	int color = 0;
	int len1  = 0;
	int len2  = 0;

	if( a0 == 0 ){
		a0 = 1;
	}

	color = code[a0];

	//まだ未確定領域の場合は、refのcolorを採用する
	if( color == -1 ){
		color = ref[a0];
	}

	len1 = getRunLength(color);
	len2 = getRunLength(turnColor(color));

	for( int i = a0 ; i < a0 + len1 ; i++ ){
		if( i < width + 2 ){
			code[i] = color;
		}
		else{
			break;
		}
	}

	a0    += len1;
	color  = turnColor(color);

	for( int j = a0 ; j < a0 + len2 ; j++ ){
		if( j < width + 2 ){
			code[j] = color;
		}
		else{
			break;
		}
	}

	a0 += len2;

	if( a0 > width + 2 - 1 ){
		a0 = width + 2 - 1;

	}

	//a0の色を確定
	if( code[a0] == -1 ){
		code[a0] = turnColor( color );
	}

	return a0;
}

// Vertical modeの解析
int vertical(int * ref, int * code , int a0 , int shift , int width ){

	int color = code[a0];
	int b1    = getB1( color , ref , a0 , width );
	int a1    = b1 + shift;

	if( a1 > width + 2 - 1 ){
		a1 = width + 2 - 1;
	}

	// a1の直前までcolorをcodeに設定
	for( int i = a0 ; i < a1 ; i++ ){
		code[i] = color;
	}

	// 最後は反転させた色を設定
	if( ( a1 < width + 2 ) && ( code[a1] == -1 ) ){
		code[a1] = turnColor( color );
	}

	return a1;
}

// B1の位置を求める
int getB1( int color , int * ref , int a0 , int width ){

	// 0:初期値、1:最初のa0と同じ色の領域、
	int step = 0;
	for( int i = a0 ; i < width + 2 ; i++ ){

		// a0と同じ色
		if( ref[i] == color ){

			// 最初にrefでa0と同じ色を見つけた
			if( step == 0 ){
				step = 1;
			}

		// a0と違う色
		}
		else{
			//既に同じ色を見つけている
			if( step == 1 ){
				//ここがb1
				return i;
			}
		}
	}

	return width + 2 - 1;
}

// B2の位置を求める
int getB2( int color , int * ref , int a0 , int width ){

	// 0:初期値、1:最初のa0と同じ色の領域、
	int step = 0;
	for( int i = a0 ; i < width + 2 ; i++ ){

		// a0と同じ色
		if( ref[i] == color ){

			// 最初にrefでa0と同じ色を見つけた
			if( step == 0 ){
				step = 1;

			// 既にrefでa0と同じ色を見つけている
			}
			else if( step == 2 ){
				// ここがb2
				return i;
			}

		// a0と違う色
		}
		else{
			//既に同じ色を見つけている
			if( step == 1 ){
				//ここがb1
				step = 2;
			}
		}
	}

	return width + 2 - 1;
}

// 色の設定する長さを求める
int getRunLength( int color ){
	//                                    white                  black
	return ( color == 0 ) ? getRunLength( true ) : getRunLength( false );
}

// 色の設定する長さを求める
int getRunLength( bool boolBW ){

	char * key    = new char[14];
	int    result = 0;

	// 初期化
	memset( key , '\0' , sizeof( char ) * 14 );

	for( int i = 0 ; i <= 12 ; i++ ){

		key[i] = get();

		if( boolBW ){
			if( 9999 == getWhiteLength( key ) ){
				continue;
			}
		}
		else{
			if( 9999 == getBlackLength( key ) ){
				continue;
			}
		}

		if( boolBW ){
			result += getWhiteLength( key );
			if( getWhiteLength( key ) < 64 ){
				// メモリ解放
				free( key );

				return result;
			}
		}
		else{
			result += getBlackLength( key );
			if( getBlackLength( key ) < 64 ){
				// メモリ解放
				free( key );

				return result;
			}
		}

		// 初期化
		i = -1;
		memset( key , '\0' , sizeof( char ) * 14 );
	}

	// メモリ解放
	free( key );

	return 0;

}

// 色を反転させる
int turnColor( int color ){
	return ( color == 0 ) ? 1 : 0;
}

// 読み込んだメモリからデータを取得する
char get(){

	if( 7 < currentArrayPosition ){
		pushArray();
	}

	return ary[ currentArrayPosition++ ];
}

// メモリの更新を行う
void pushArray(){

	unsigned int intBuf = 0;
	BYTE         b[1];

	b[0]   = bInputImageData[currentListPosition];
	intBuf = b[0];

	currentListPosition++;
	currentArrayPosition = 0;

	for( int i = 0 ; i < 8 ; i++ ){

		if( ( ( intBuf >> i ) & 1 ) == 1 ){
			ary[ 7 - i ] = '1';
		}
		else{
			ary[ 7 - i ] = '0';
		}
	}
}

// 白色の設定する長さを求める
int getWhiteLength( char * key ){

	int result = 0;

	if( strcmp( key , "00110101" ) == 0 ){
		result = 0;
	}
	else if( strcmp( key , "000111" ) == 0 ){
		result = 1;
	}
	else if( strcmp( key , "0111" ) == 0 ){
		result = 2;
	}
	else if( strcmp( key , "1000" ) == 0 ){
		result = 3;
	}
	else if( strcmp( key , "1011" ) == 0 ){
		result = 4;
	}
	else if( strcmp( key , "1100" ) == 0 ){
		result = 5;
	}
	else if( strcmp( key , "1110" ) == 0 ){
		result = 6;
	}
	else if( strcmp( key , "1111" ) == 0 ){
		result = 7;
	}
	else if( strcmp( key , "10011" ) == 0 ){
		result = 8;
	}
	else if( strcmp( key , "10100" ) == 0 ){
		result = 9;
	}
	else if( strcmp( key , "00111" ) == 0 ){
		result = 10;
	}
	else if( strcmp( key , "01000" ) == 0 ){
		result = 11;
	}
	else if( strcmp( key , "001000" ) == 0 ){
		result = 12;
	}
	else if( strcmp( key , "000011" ) == 0 ){
		result = 13;
	}
	else if( strcmp( key , "110100" ) == 0 ){
		result = 14;
	}
	else if( strcmp( key , "110101" ) == 0 ){
		result = 15;
	}
	else if( strcmp( key , "101010" ) == 0 ){
		result = 16;
	}
	else if( strcmp( key , "101011" ) == 0 ){
		result = 17;
	}
	else if( strcmp( key , "0100111" ) == 0 ){
		result = 18;
	}
	else if( strcmp( key , "0001100" ) == 0 ){
		result = 19;
	}
	else if( strcmp( key , "0001000" ) == 0 ){
		result = 20;
	}
	else if( strcmp( key , "0010111" ) == 0 ){
		result = 21;
	}
	else if( strcmp( key , "0000011" ) == 0 ){
		result = 22;
	}
	else if( strcmp( key , "0000100" ) == 0 ){
		result = 23;
	}
	else if( strcmp( key , "0101000" ) == 0 ){
		result = 24;
	}
	else if( strcmp( key , "0101011" ) == 0 ){
		result = 25;
	}
	else if( strcmp( key , "0010011" ) == 0 ){
		result = 26;
	}
	else if( strcmp( key , "0100100" ) == 0 ){
		result = 27;
	}
	else if( strcmp( key , "0011000" ) == 0 ){
		result = 28;
	}
	else if( strcmp( key , "00000010" ) == 0 ){
		result = 29;
	}
	else if( strcmp( key , "00000011" ) == 0 ){
		result = 30;
	}
	else if( strcmp( key , "00011010" ) == 0 ){
		result = 31;
	}
	else if( strcmp( key , "00011011" ) == 0 ){
		result = 32;
	}
	else if( strcmp( key , "00010010" ) == 0 ){
		result = 33;
	}
	else if( strcmp( key , "00010011" ) == 0 ){
		result = 34;
	}
	else if( strcmp( key , "00010100" ) == 0 ){
		result = 35;
	}
	else if( strcmp( key , "00010101" ) == 0 ){
		result = 36;
	}
	else if( strcmp( key , "00010110" ) == 0 ){
		result = 37;
	}
	else if( strcmp( key , "00010111" ) == 0 ){
		result = 38;
	}
	else if( strcmp( key , "00101000" ) == 0 ){
		result = 39;
	}
	else if( strcmp( key , "00101001" ) == 0 ){
		result = 40;
	}
	else if( strcmp( key , "00101010" ) == 0 ){
		result = 41;
	}
	else if( strcmp( key , "00101011" ) == 0 ){
		result = 42;
	}
	else if( strcmp( key , "00101100" ) == 0 ){
		result = 43;
	}
	else if( strcmp( key , "00101101" ) == 0 ){
		result = 44;
	}
	else if( strcmp( key , "00000100" ) == 0 ){
		result = 45;
	}
	else if( strcmp( key , "00000101" ) == 0 ){
		result = 46;
	}
	else if( strcmp( key , "00001010" ) == 0 ){
		result = 47;
	}
	else if( strcmp( key , "00001011" ) == 0 ){
		result = 48;
	}
	else if( strcmp( key , "01010010" ) == 0 ){
		result = 49;
	}
	else if( strcmp( key , "01010011" ) == 0 ){
		result = 50;
	}
	else if( strcmp( key , "01010100" ) == 0 ){
		result = 51;
	}
	else if( strcmp( key , "01010101" ) == 0 ){
		result = 52;
	}
	else if( strcmp( key , "00100100" ) == 0 ){
		result = 53;
	}
	else if( strcmp( key , "00100101" ) == 0 ){
		result = 54;
	}
	else if( strcmp( key , "01011000" ) == 0 ){
		result = 55;
	}
	else if( strcmp( key , "01011001" ) == 0 ){
		result = 56;
	}
	else if( strcmp( key , "01011010" ) == 0 ){
		result = 57;
	}
	else if( strcmp( key , "01011011" ) == 0 ){
		result = 58;
	}
	else if( strcmp( key , "01001010" ) == 0 ){
		result = 59;
	}
	else if( strcmp( key , "01001011" ) == 0 ){
		result = 60;
	}
	else if( strcmp( key , "00110010" ) == 0 ){
		result = 61;
	}
	else if( strcmp( key , "00110011" ) == 0 ){
		result = 62;
	}
	else if( strcmp( key , "00110100" ) == 0 ){
		result = 63;
	}
	else if( strcmp( key , "11011" ) == 0 ){
		result = 64;
	}
	else if( strcmp( key , "10010" ) == 0 ){
		result = 128;
	}
	else if( strcmp( key , "010111" ) == 0 ){
		result = 192;
	}
	else if( strcmp( key , "0110111" ) == 0 ){
		result = 256;
	}
	else if( strcmp( key , "00110110" ) == 0 ){
		result = 320;
	}
	else if( strcmp( key , "00110111" ) == 0 ){
		result = 384;
	}
	else if( strcmp( key , "01100100" ) == 0 ){
		result = 448;
	}
	else if( strcmp( key , "01100101" ) == 0 ){
		result = 512;
	}
	else if( strcmp( key , "01101000" ) == 0 ){
		result = 576;
	}
	else if( strcmp( key , "01100111" ) == 0 ){
		result = 640;
	}
	else if( strcmp( key , "011001100" ) == 0 ){
		result = 704;
	}
	else if( strcmp( key , "011001101" ) == 0 ){
		result = 768;
	}
	else if( strcmp( key , "011010010" ) == 0 ){
		result = 832;
	}
	else if( strcmp( key , "011010011" ) == 0 ){
		result = 896;
	}
	else if( strcmp( key , "011010100" ) == 0 ){
		result = 960;
	}
	else if( strcmp( key , "011010101" ) == 0 ){
		result = 1024;
	}
	else if( strcmp( key , "011010110" ) == 0 ){
		result = 1088;
	}
	else if( strcmp( key , "011010111" ) == 0 ){
		result = 1152;
	}
	else if( strcmp( key , "011011000" ) == 0 ){
		result = 1216;
	}
	else if( strcmp( key , "011011001" ) == 0 ){
		result = 1280;
	}
	else if( strcmp( key , "011011010" ) == 0 ){
		result = 1344;
	}
	else if( strcmp( key , "011011011" ) == 0 ){
		result = 1408;
	}
	else if( strcmp( key , "010011000" ) == 0 ){
		result = 1472;
	}
	else if( strcmp( key , "010011001" ) == 0 ){
		result = 1536;
	}
	else if( strcmp( key , "010011010" ) == 0 ){
		result = 1600;
	}
	else if( strcmp( key , "011000" ) == 0 ){
		result = 1664;
	}
	else if( strcmp( key , "010011011" ) == 0 ){
		result = 1728;
	}
	else if( strcmp( key , "00000001000" ) == 0 ){
		result = 1792;
	}
	else if( strcmp( key , "00000001100" ) == 0 ){
		result = 1856;
	}
	else if( strcmp( key , "00000001101" ) == 0 ){
		result = 1920;
	}
	else if( strcmp( key , "000000010010" ) == 0 ){
		result = 1984;
	}
	else if( strcmp( key , "000000010011" ) == 0 ){
		result = 2048;
	}
	else if( strcmp( key , "000000010100" ) == 0 ){
		result = 2112;
	}
	else if( strcmp( key , "000000010101" ) == 0 ){
		result = 2176;
	}
	else if( strcmp( key , "000000010110" ) == 0 ){
		result = 2240;
	}
	else if( strcmp( key , "000000010111" ) == 0 ){
		result = 2304;
	}
	else if( strcmp( key , "000000011100" ) == 0 ){
		result = 2368;
	}
	else if( strcmp( key , "000000011101" ) == 0 ){
		result = 2432;
	}
	else if( strcmp( key , "000000011110" ) == 0 ){
		result = 2496;
	}
	else if( strcmp( key , "000000011111" ) == 0 ){
		result = 2560;
	}
	else{
		result = 9999;
	}

	return result;
}

// 黒色の設定する長さを求める
int getBlackLength( char * key ){

	int result = 0;

	if( strcmp( key , "0000110111" ) == 0 ){
		result = 0;
	}
	else if( strcmp( key , "010" ) == 0 ){
		result = 1;
	}
	else if( strcmp( key , "11" ) == 0 ){
		result = 2;
	}
	else if( strcmp( key , "10" ) == 0 ){
		result = 3;
	}
	else if( strcmp( key , "011" ) == 0 ){
		result = 4;
	}
	else if( strcmp( key , "0011" ) == 0 ){
		result = 5;
	}
	else if( strcmp( key , "0010" ) == 0 ){
		result = 6;
	}
	else if( strcmp( key , "00011" ) == 0 ){
		result = 7;
	}
	else if( strcmp( key , "000101" ) == 0 ){
		result = 8;
	}
	else if( strcmp( key , "000100" ) == 0 ){
		result = 9;
	}
	else if( strcmp( key , "0000100" ) == 0 ){
		result = 10;
	}
	else if( strcmp( key , "0000101" ) == 0 ){
		result = 11;
	}
	else if( strcmp( key , "0000111" ) == 0 ){
		result = 12;
	}
	else if( strcmp( key , "00000100" ) == 0 ){
		result = 13;
	}
	else if( strcmp( key , "00000111" ) == 0 ){
		result = 14;
	}
	else if( strcmp( key , "000011000" ) == 0 ){
		result = 15;
	}
	else if( strcmp( key , "0000010111" ) == 0 ){
		result = 16;
	}
	else if( strcmp( key , "0000011000" ) == 0 ){
		result = 17;
	}
	else if( strcmp( key , "0000001000" ) == 0 ){
		result = 18;
	}
	else if( strcmp( key , "00001100111" ) == 0 ){
		result = 19;
	}
	else if( strcmp( key , "00001101000" ) == 0 ){
		result = 20;
	}
	else if( strcmp( key , "00001101100" ) == 0 ){
		result = 21;
	}
	else if( strcmp( key , "00000110111" ) == 0 ){
		result = 22;
	}
	else if( strcmp( key , "00000101000" ) == 0 ){
		result = 23;
	}
	else if( strcmp( key , "00000010111" ) == 0 ){
		result = 24;
	}
	else if( strcmp( key , "00000011000" ) == 0 ){
		result = 25;
	}
	else if( strcmp( key , "000011001010" ) == 0 ){
		result = 26;
	}
	else if( strcmp( key , "000011001011" ) == 0 ){
		result = 27;
	}
	else if( strcmp( key , "000011001100" ) == 0 ){
		result = 28;
	}
	else if( strcmp( key , "000011001101" ) == 0 ){
		result = 29;
	}
	else if( strcmp( key , "000001101000" ) == 0 ){
		result = 30;
	}
	else if( strcmp( key , "000001101001" ) == 0 ){
		result = 31;
	}
	else if( strcmp( key , "000001101010" ) == 0 ){
		result = 32;
	}
	else if( strcmp( key , "000001101011" ) == 0 ){
		result = 33;
	}
	else if( strcmp( key , "000011010010" ) == 0 ){
		result = 34;
	}
	else if( strcmp( key , "000011010011" ) == 0 ){
		result = 35;
	}
	else if( strcmp( key , "000011010100" ) == 0 ){
		result = 36;
	}
	else if( strcmp( key , "000011010101" ) == 0 ){
		result = 37;
	}
	else if( strcmp( key , "000011010110" ) == 0 ){
		result = 38;
	}
	else if( strcmp( key , "000011010111" ) == 0 ){
		result = 39;
	}
	else if( strcmp( key , "000001101100" ) == 0 ){
		result = 40;
	}
	else if( strcmp( key , "000001101101" ) == 0 ){
		result = 41;
	}
	else if( strcmp( key , "000011011010" ) == 0 ){
		result = 42;
	}
	else if( strcmp( key , "000011011011" ) == 0 ){
		result = 43;
	}
	else if( strcmp( key , "000001010100" ) == 0 ){
		result = 44;
	}
	else if( strcmp( key , "000001010101" ) == 0 ){
		result = 45;
	}
	else if( strcmp( key , "000001010110" ) == 0 ){
		result = 46;
	}
	else if( strcmp( key , "000001010111" ) == 0 ){
		result = 47;
	}
	else if( strcmp( key , "000001100100" ) == 0 ){
		result = 48;
	}
	else if( strcmp( key , "000001100101" ) == 0 ){
		result = 49;
	}
	else if( strcmp( key , "000001010010" ) == 0 ){
		result = 50;
	}
	else if( strcmp( key , "000001010011" ) == 0 ){
		result = 51;
	}
	else if( strcmp( key , "000000100100" ) == 0 ){
		result = 52;
	}
	else if( strcmp( key , "000000110111" ) == 0 ){
		result = 53;
	}
	else if( strcmp( key , "000000111000" ) == 0 ){
		result = 54;
	}
	else if( strcmp( key , "000000100111" ) == 0 ){
		result = 55;
	}
	else if( strcmp( key , "000000101000" ) == 0 ){
		result = 56;
	}
	else if( strcmp( key , "000001011000" ) == 0 ){
		result = 57;
	}
	else if( strcmp( key , "000001011001" ) == 0 ){
		result = 58;
	}
	else if( strcmp( key , "000000101011" ) == 0 ){
		result = 59;
	}
	else if( strcmp( key , "000000101100" ) == 0 ){
		result = 60;
	}
	else if( strcmp( key , "000001011010" ) == 0 ){
		result = 61;
	}
	else if( strcmp( key , "000001100110" ) == 0 ){
		result = 62;
	}
	else if( strcmp( key , "000001100111" ) == 0 ){
		result = 63;
	}
	else if( strcmp( key , "0000001111" ) == 0 ){
		result = 64;
	}
	else if( strcmp( key , "000011001000" ) == 0 ){
		result = 128;
	}
	else if( strcmp( key , "000011001001" ) == 0 ){
		result = 192;
	}
	else if( strcmp( key , "000001011011" ) == 0 ){
		result = 256;
	}
	else if( strcmp( key , "000000110011" ) == 0 ){
		result = 320;
	}
	else if( strcmp( key , "000000110100" ) == 0 ){
		result = 384;
	}
	else if( strcmp( key , "000000110101" ) == 0 ){
		result = 448;
	}
	else if( strcmp( key , "0000001101100" ) == 0 ){
		result = 512;
	}
	else if( strcmp( key , "0000001101101" ) == 0 ){
		result = 576;
	}
	else if( strcmp( key , "0000001001010" ) == 0 ){
		result = 640;
	}
	else if( strcmp( key , "0000001001011" ) == 0 ){
		result = 704;
	}
	else if( strcmp( key , "0000001001100" ) == 0 ){
		result = 768;
	}
	else if( strcmp( key , "0000001001101" ) == 0 ){
		result = 832;
	}
	else if( strcmp( key , "0000001110010" ) == 0 ){
		result = 896;
	}
	else if( strcmp( key , "0000001110011" ) == 0 ){
		result = 960;
	}
	else if( strcmp( key , "0000001110100" ) == 0 ){
		result = 1024;
	}
	else if( strcmp( key , "0000001110101" ) == 0 ){
		result = 1088;
	}
	else if( strcmp( key , "0000001110110" ) == 0 ){
		result = 1152;
	}
	else if( strcmp( key , "0000001110111" ) == 0 ){
		result = 1216;
	}
	else if( strcmp( key , "0000001010010" ) == 0 ){
		result = 1280;
	}
	else if( strcmp( key , "0000001010011" ) == 0 ){
		result = 1344;
	}
	else if( strcmp( key , "0000001010100" ) == 0 ){
		result = 1408;
	}
	else if( strcmp( key , "0000001010101" ) == 0 ){
		result = 1472;
	}
	else if( strcmp( key , "0000001011010" ) == 0 ){
		result = 1536;
	}
	else if( strcmp( key , "0000001011011" ) == 0 ){
		result = 1600;
	}
	else if( strcmp( key , "0000001100100" ) == 0 ){
		result = 1664;
	}
	else if( strcmp( key , "0000001100101" ) == 0 ){
		result = 1728;
	}
	else if( strcmp( key , "00000001000" ) == 0 ){
		result = 1792;
	}
	else if( strcmp( key , "00000001100" ) == 0 ){
		result = 1856;
	}
	else if( strcmp( key , "00000001101" ) == 0 ){
		result = 1920;
	}
	else if( strcmp( key , "000000010010" ) == 0 ){
		result = 1984;
	}
	else if( strcmp( key , "000000010011" ) == 0 ){
		result = 2048;
	}
	else if( strcmp( key , "000000010100" ) == 0 ){
		result = 2112;
	}
	else if( strcmp( key , "000000010101" ) == 0 ){
		result = 2176;
	}
	else if( strcmp( key , "000000010110" ) == 0 ){
		result = 2240;
	}
	else if( strcmp( key , "000000010111" ) == 0 ){
		result = 2304;
	}
	else if( strcmp( key , "000000011100" ) == 0 ){
		result = 2368;
	}
	else if( strcmp( key , "000000011101" ) == 0 ){
		result = 2432;
	}
	else if( strcmp( key , "000000011110" ) == 0 ){
		result = 2496;
	}
	else if( strcmp( key , "000000011111" ) == 0 ){
		result = 2560;
	}
	else{
		result = 9999;
	}

	return result;
}
