//////////////////////////////////////////////////////////////////////////////////////////////
//
// mergeTiffBinalyToMultiPageTiff.cpp: mergeTiffBinalyToMultiPageTiff クラスのインターフェイス
// 複数のTiff画像バイナリデータを一つのマルチページTiffにマージする
//
//////////////////////////////////////////////////////////////////////////////////////////////

#include "mergeTiffBinalyToMultiPageTiff.h"

int mrgTIFFDataTIFFFile( char * imageDataPath[]
					   , int    type
					   , int    intDPI[]
					   , int    intWidth[]
					   , int    intHeight[]
					   , int    intImageDataLength[]
					   , int    binalyDataCount
					   , char * pOutputFilePath ){

	FILE *         wFp;
	FILE *         rFp;
	BYTE           bTemp[1];
	unsigned int   iTemp[1];
	unsigned short sTemp[1];
	short          entryCount = 0;
	short          entryLoop  = 14;
	int            writePos   = 0;

	// 出力ファイルオープン
	wFp = fopen( pOutputFilePath , "wb" );
	if( wFp == NULL ){
		return -6;
	}

	bTemp[0] = 0x49;
	fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );
	fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );
	writePos += 2;

	// バージョン書き込み
	sTemp[0] = 42;
	fwrite( ( char * )sTemp , sizeof( short ) , 1 , wFp );
	writePos += 2;

	// 1番目のIFDへのポインタ書き込み
	iTemp[0] = 8;
	fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
	writePos += 4;

	// バイナリイデータの数分書き込む
	for( int i = 0 ; i < binalyDataCount ; i++ ){

		// バイナリデータファイルオープン
		rFp = fopen( imageDataPath[i] , "rb" );
		if( rFp == NULL ){
			fclose( wFp );
			return -6;
		}

		// エントリカウント書き込み
		if( type == 7 ){
			entryCount = 14;
		}
		else{
			entryCount = 13;
		}
		sTemp[0] = entryCount;
		fwrite( ( char * )sTemp , sizeof( short ) , 1 , wFp );
		writePos += 2;

		// 各種オフセット格納用
		int intBitsPerSampleOffsets       = 0;
		int intXResolusionOffsets         = 0;
		int intYResolusionOffsets         = 0;
		int intReferenceBlackWhiteOffsets = 0;
		int intStripOffsets               = 0;
		int intNextIFDOffsets             = 0;

		if( type == 7 ){
			// BitsPerSampleのオフセットを求める
			intBitsPerSampleOffsets = writePos + ( 12 * entryCount ) + 4;

			// XResolusionのオフセットを求める
			intXResolusionOffsets = writePos + ( 12 * entryCount ) + 4 + 6;

			// YResolusionのオフセットを求める
			intYResolusionOffsets = writePos + ( 12 * entryCount ) + 4 + 6 + 8;

			// ReferenceBlackWhiteのオフセットを求める
			intReferenceBlackWhiteOffsets = writePos + ( 12 * entryCount ) + 4 + 6 + 8 + 8;

			// イメージデータのオフセットを求める
			intStripOffsets = writePos + ( 12 * entryCount ) + 4 + 6 + 8 + 8 + 48;

			// 次のIFDのオフセットを求める
			if( i == binalyDataCount - 1 ){
				intNextIFDOffsets = 0;
			}
			else{
				intNextIFDOffsets = writePos + ( 12 * entryCount ) + 4 + 6 + 8 + 8 + 48 + intImageDataLength[i];
			}
		}
		else{
			// XResolusionのオフセットを求める
			intXResolusionOffsets = writePos + ( 12 * entryCount ) + 4;

			// YResolusionのオフセットを求める
			intYResolusionOffsets = writePos + ( 12 * entryCount ) + 4 + 8;

			// イメージデータのオフセットを求める
			intStripOffsets = writePos + ( 12 * entryCount ) + 4 + 8 + 8;

			// 次のIFDのオフセットを求める
			if( i == binalyDataCount - 1 ){
				intNextIFDOffsets = 0;
			}
			else{
				intNextIFDOffsets = writePos + ( 12 * entryCount ) + 4 + 8 + 8 + intImageDataLength[i];
			}
		}

		// エントリカウント分
		for( int j = 0 ; j < entryLoop ; j++ ){
			// タグ・データ型・データ数・データ書き込み
			switch( j ){
				case 0:
					// タグ
					sTemp[0] = 0x00fe;
					fwrite( ( char * )sTemp , sizeof( short ) , 1 , wFp );
					// データ型
					sTemp[0] = 0x0004;
					fwrite( ( char * )sTemp , sizeof( short ) , 1 , wFp );
					// データ数
					iTemp[0] = 0x0001;
					fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
					// データ
					iTemp[0] = 0x0002;
					fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
					// ポインタ更新
					writePos += 12;
					break;
				case 1:
					// タグ
					sTemp[0] = 0x0100;
					fwrite( ( char * )sTemp , sizeof( short ) , 1 , wFp );
					// データ型
					sTemp[0] = 0x0004;
					fwrite( ( char * )sTemp , sizeof( short ) , 1 , wFp );
					// データ数
					iTemp[0] = 0x0001;
					fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
					// データ
					iTemp[0] = intWidth[i];
					fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
					// ポインタ更新
					writePos += 12;
					break;
				case 2:
					// タグ
					sTemp[0] = 0x0101;
					fwrite( ( char * )sTemp , sizeof( short ) , 1 , wFp );
					// データ型
					sTemp[0] = 0x0004;
					fwrite( ( char * )sTemp , sizeof( short ) , 1 , wFp );
					// データ数
					iTemp[0] = 0x0001;
					fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
					// データ
					iTemp[0] = intHeight[i];
					fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
					// ポインタ更新
					writePos += 12;
					break;
				case 3:
					// タグ
					sTemp[0] = 0x0102;
					fwrite( ( char * )sTemp , sizeof( short ) , 1 , wFp );
					// データ型
					sTemp[0] = 0x0003;
					fwrite( ( char * )sTemp , sizeof( short ) , 1 , wFp );
					if( type == 7 ){
						// データ数
						iTemp[0] = 0x0003;
						fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
						// データ
						iTemp[0] = intBitsPerSampleOffsets;
						fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
					}
					else{
						// データ数
						iTemp[0] = 0x0001;
						fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
						// データ
						iTemp[0] = 0x0001;
						fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
					}
					// ポインタ更新
					writePos += 12;
					break;
				case 4:
					// タグ
					sTemp[0] = 0x0103;
					fwrite( ( char * )sTemp , sizeof( short ) , 1 , wFp );
					// データ型
					sTemp[0] = 0x0003;
					fwrite( ( char * )sTemp , sizeof( short ) , 1 , wFp );
					// データ数
					iTemp[0] = 0x0001;
					fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
					// データ
					iTemp[0] = type;
					fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
					// ポインタ更新
					writePos += 12;
					break;
				case 5:
					// タグ
					sTemp[0] = 0x0106;
					fwrite( ( char * )sTemp , sizeof( short ) , 1 , wFp );
					// データ型
					sTemp[0] = 0x0003;
					fwrite( ( char * )sTemp , sizeof( short ) , 1 , wFp );
					// データ数
					iTemp[0] = 0x0001;
					fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
					// データ
					if( type == 7 ){
						iTemp[0] = 0x0006;
						fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
					}
					else{
						iTemp[0] = 0x0000;
						fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
					}
					// ポインタ更新
					writePos += 12;
					break;
				case 6:
					// タグ
					sTemp[0] = 0x0111;
					fwrite( ( char * )sTemp , sizeof( short ) , 1 , wFp );
					// データ型
					sTemp[0] = 0x0004;
					fwrite( ( char * )sTemp , sizeof( short ) , 1 , wFp );
					// データ数
					iTemp[0] = 0x0001;
					fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
					// データ
					iTemp[0] = intStripOffsets;
					fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
					// ポインタ更新
					writePos += 12;
					break;
				case 7:
					if( type == 7 ){
						// タグ
						sTemp[0] = 0x0115;
						fwrite( ( char * )sTemp , sizeof( short ) , 1 , wFp );
						// データ型
						sTemp[0] = 0x0003;
						fwrite( ( char * )sTemp , sizeof( short ) , 1 , wFp );
						// データ数
						iTemp[0] = 0x0001;
						fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
						// データ
						iTemp[0] = 0x0003;
						fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
						// ポインタ更新
						writePos += 12;
					}
					break;
				case 8:
					// タグ
					sTemp[0] = 0x0116;
					fwrite( ( char * )sTemp , sizeof( short ) , 1 , wFp );
					// データ型
					sTemp[0] = 0x0004;
					fwrite( ( char * )sTemp , sizeof( short ) , 1 , wFp );
					// データ数
					iTemp[0] = 0x0001;
					fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
					// データ
					iTemp[0] = intHeight[i];
					fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
					// ポインタ更新
					writePos += 12;
					break;
				case 9:
					// タグ
					sTemp[0] = 0x0117;
					fwrite( ( char * )sTemp , sizeof( short ) , 1 , wFp );
					// データ型
					sTemp[0] = 0x0004;
					fwrite( ( char * )sTemp , sizeof( short ) , 1 , wFp );
					// データ数
					iTemp[0] = 0x0001;
					fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
					// データ
					iTemp[0] = intImageDataLength[i];
					fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
					// ポインタ更新
					writePos += 12;
					break;
				case 10:
					// タグ
					sTemp[0] = 0x011a;
					fwrite( ( char * )sTemp , sizeof( short ) , 1 , wFp );
					// データ型
					sTemp[0] = 0x0005;
					fwrite( ( char * )sTemp , sizeof( short ) , 1 , wFp );
					// データ数
					iTemp[0] = 0x0001;
					fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
					// データ
					iTemp[0] = intXResolusionOffsets;
					fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
					// ポインタ更新
					writePos += 12;
					break;
				case 11:
					// タグ
					sTemp[0] = 0x011b;
					fwrite( ( char * )sTemp , sizeof( short ) , 1 , wFp );
					// データ型
					sTemp[0] = 0x0005;
					fwrite( ( char * )sTemp , sizeof( short ) , 1 , wFp );
					// データ数
					iTemp[0] = 0x0001;
					fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
					// データ
					iTemp[0] = intYResolusionOffsets;
					fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
					// ポインタ更新
					writePos += 12;
					break;
				case 12:
					// タグ
					sTemp[0] = 0x0128;
					fwrite( ( char * )sTemp , sizeof( short ) , 1 , wFp );
					// データ型
					sTemp[0] = 0x0003;
					fwrite( ( char * )sTemp , sizeof( short ) , 1 , wFp );
					// データ数
					iTemp[0] = 0x0001;
					fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
					// データ
					iTemp[0] = 0x0002;
					fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
					// ポインタ更新
					writePos += 12;
					break;
				case 13:
					// タグ
					sTemp[0] = 0x0129;
					fwrite( ( char * )sTemp , sizeof( short ) , 1 , wFp );
					// データ型
					sTemp[0] = 0x0003;
					fwrite( ( char * )sTemp , sizeof( short ) , 1 , wFp );
					// データ数
					iTemp[0] = 0x0002;
					fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
					// データ
					iTemp[0] = i;
					fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
					// ポインタ更新
					writePos += 12;
					break;
				default:
					break;
			}
		}

		// 次のIFDのオフセット書き込み
		iTemp[0] = intNextIFDOffsets;
		fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
		writePos += 4;

		if( type == 7 ){
			// BitsPerSample書き込み
			sTemp[0] = 0x0008;
			fwrite( ( char * )sTemp , sizeof( short ) , 1 , wFp );
			fwrite( ( char * )sTemp , sizeof( short ) , 1 , wFp );
			fwrite( ( char * )sTemp , sizeof( short ) , 1 , wFp );
			writePos += 6;
		}

		// XResolusion書き込み
		iTemp[0] = intDPI[i];
		fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
		writePos += 4;
		iTemp[0] = 0x0001;
		fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
		writePos += 4;

		// YResolusion書き込み
		iTemp[0] = intDPI[i];
		fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
		writePos += 4;
		iTemp[0] = 0x0001;
		fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
		writePos += 4;

		if( type == 7 ){
			// ReferenceBlackWhite書き込み
			iTemp[0] = 0x0000;
			fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
			writePos += 4;
			iTemp[0] = 0x0001;
			fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
			writePos += 4;
			iTemp[0] = 0x00ff;
			fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
			writePos += 4;
			iTemp[0] = 0x0001;
			fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
			writePos += 4;
			iTemp[0] = 0x0008;
			fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
			writePos += 4;
			iTemp[0] = 0x0001;
			fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
			writePos += 4;
			iTemp[0] = 0x00ff;
			fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
			writePos += 4;
			iTemp[0] = 0x0001;
			fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
			writePos += 4;
			iTemp[0] = 0x0008;
			fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
			writePos += 4;
			iTemp[0] = 0x0001;
			fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
			writePos += 4;
			iTemp[0] = 0x00ff;
			fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
			writePos += 4;
			iTemp[0] = 0x0001;
			fwrite( ( char * )iTemp , sizeof( int ) , 1 , wFp );
			writePos += 4;
		}

		// イメージデータ書き込み
		for( int m = 0 ; m < intImageDataLength[i] ; m++ ){
			// 1バイト読み込み
			fread( ( char * )bTemp , sizeof( BYTE ) , 1 , rFp );

			// 1バイト書き込み
			fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );

			writePos++;
		}

		// ファイルクローズ
		fclose( rFp );

	}

	// ファイルクローズ
	fclose( wFp );

	return 1;
}

