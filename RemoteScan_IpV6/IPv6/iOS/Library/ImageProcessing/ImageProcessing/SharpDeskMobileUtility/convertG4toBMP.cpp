//////////////////////////////////////////////////////////////////////
//
// convertG4toBMP.cpp: convertG4toBMP �N���X�̃C���^�[�t�F�C�X
// G4���k�̉摜�t�@�C����BMP�t�@�C���Ƀf�R�[�h����
//
//////////////////////////////////////////////////////////////////////

#include "convertG4toBMP.h"

const char * strInputFilePath;		// ���̓t�@�C����
BYTE *       bInputImageData;		// ���̓t�@�C���ǂݍ��ݗ̈�
int          currentListPosition;	// �ǂݍ��݃f�[�^�ʒu
int          currentArrayPosition;	// �ǂݍ��݃f�[�^�ʒu
char *       ary;					// ���̓t�@�C���ǂݍ��ݗ̈�
char *       strOutputFilePathAll;	// �o�̓t�@�C����

// ���̓t�@�C�����BMP�t�@�C�����o�͂���
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

	// �t�@�C�����擾
	strInputFilePath = pInputFilePath;

	// �t�@�C���t�H�[�}�b�g�`�F�b�N
	for( size_t j = strlen( strInputFilePath ) - 1 ; j != 0 ; j-- ){
		char tmp[1];
		strncpy(tmp , &strInputFilePath[j] , 1 );
		if( strncmp( tmp , "." , 1 ) == 0 ){
			iDotPos = j;
			break;
		}
	}
	// �g���q�Ȃ��͑Ή��O
	if( iDotPos == 0 ){
		return -6;
	}

	// �g���q��"tiff"�A"tif"�ȊO�͑Ή��O
	if( ( strcmp( &strInputFilePath[ iDotPos + 1 ] , "tiff" ) != 0 )
	&&  ( strcmp( &strInputFilePath[ iDotPos + 1 ] , "tif"  ) != 0 ) ){
		return -6;
	}

	// ���̓t�@�C���ǂݍ���
	rFp = fopen( strInputFilePath , "rb" );
	if( rFp == NULL ){
		return -6;
	}

	// �t�@�C���T�C�Y�擾
	while( !feof( rFp ) ){
		fread( (char *)bTmp , sizeof( BYTE ) , 1 , rFp );
		inputImageSize++;
    }

	// �T�C�Y���̗̈���m��
	bInputImageData = new BYTE[ inputImageSize * sizeof( BYTE ) + 1 ];
	if( bInputImageData == NULL ){
		return -2;
	}

	// �̈揉����
	memset( bInputImageData , 0 , inputImageSize * sizeof( BYTE ) + 1 );

	// �擪�ɖ߂�
	fseek( rFp , 0 , SEEK_SET );

	// �t�@�C���ǂݍ���
	fread( (char *)bInputImageData , sizeof( BYTE ) , inputImageSize , rFp );

	// �t�@�C�������
	fclose( rFp );

	// �o�C�g�I�[�_�[���m��
	if( ( bInputImageData[0] == 0x4d ) && ( bInputImageData[0] == 0x4d ) ){
		byteOrder = 0;
	}
	else if( ( bInputImageData[0] == 0x49 ) && ( bInputImageData[0] == 0x49 ) ){
		byteOrder = 1;
	}
	else{
		// ���������
		free( bInputImageData );

		return -1;
	}

	// IDF�|�C���^�擾
	idfp = getValue( bInputImageData , 4 , 4 , byteOrder );

	while( true ){
		// �y�[�W��
		pageCount++;

		// �G���g���J�E���g�擾
		entCount = getValue( bInputImageData , idfp , 2 , byteOrder );
		if( entCount == 0 ){
			// ���������
			free( bInputImageData );

			return -1;
		}

		// �|�C���^��i�߂�
		idfp += 2;

		for ( int i = 0 ; i < entCount ; i++ ) {
			idfp += 12;
		}

		// ����IDF�|�C���^�擾
		idfp = getValue( bInputImageData , idfp , 4 , byteOrder );
		if( idfp == 0 ){
			break;
		}

		entCount = 0;
	}

	// ���y�[�W���擾
	pageCountAll = pageCount;
	pageCount    = 0;

	// �o�̓t�@�C�����i�[�̈���m��
	strOutputFilePathAll = new char[ pageCountAll * 256 + 1 ];
	if( strOutputFilePathAll == NULL ){
		// ���������
		free( bInputImageData );

		return -2;
	}

	// �̈揉����
	memset( strOutputFilePathAll , '\0' , pageCountAll * 256 );

	// IDF�|�C���^�擾
	idfp = getValue( bInputImageData , 4 , 4 , byteOrder );

	while( true ){
		// �y�[�W��
		pageCount++;

		// �G���g���J�E���g�擾
		entCount = getValue( bInputImageData , idfp , 2 , byteOrder );
		idfp += 2;

		for ( int i = 0 ; i < entCount ; i++ ) {

			//IDF�G���g���^�O
			int tag = getValue( bInputImageData , idfp , 2 , byteOrder );

			//�f�[�^
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
						// ���������
						free( bInputImageData );
						free( strOutputFilePathAll );

						return -5;
					}
					break;

				//PhotometricInterpretation
				case 0x0106:
					if( data != 0 ){
						// ���������
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

		// �f�[�^�ǂݍ��ݗ̈�m��
		ary = new char[8];
		if( ary == NULL ){
			// ���������
			free( bInputImageData );
			free( strOutputFilePathAll );

			return -2;
		}

		// �ŏ��̉摜�f�[�^��ǂݍ���
		currentListPosition = dataPointer;
		pushArray();

		// BMP�o��
		ret = createBitmapImage( width , height , pageCount , 0 , NULL );
		if( ret < 0 ){
			// ���������
			free( bInputImageData );
			free( strOutputFilePathAll );
			free( ary );

			return ret;
		}

		// ����IDF�|�C���^�擾
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
		// �o�̓t�@�C�������o��
		strcpy( &pOutputFilePath[ 256 * i ] , &strOutputFilePathAll[ 256 * i ] );
	}

	// ���������
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

	// �p�����[�^�l�擾
	width  = intWidth;
	height = intHeight;

	// �C���[�W�f�[�^�擾
	bInputImageData = pInputImageData;

	// �o�̓t�@�C�����擾
	strcpy( strOutputFilePath , pOutputFilePath );

	// �f�[�^�ǂݍ��ݗ̈�m��
	ary = new char[8];
	if( ary == NULL ){
		// ���������
		free( bInputImageData );

		return -2;
	}

	// �摜�f�[�^�ǂݍ���
	currentListPosition = 0;
	pushArray();

	// BMP�o��
	ret = createBitmapImage( width , height , 0 , 1 , strOutputFilePath );
	if( ret < 0 ){
		// ���������
		free( bInputImageData );

		return ret;
	}

	// ���������
	free( bInputImageData );
	free( ary );

	return 1;
}

// �r�b�g�}�b�v�t�@�C�����o�͂���
int createBitmapImage( int width , int height , int pageCount , int mode , const char * pOutputFilePath ) {

	// �f�R�[�h�p
	int * ref            = new int[ width + 2 ];
	int * code           = new int[ width + 2 ];
	int   a0             = 0;
	int   writeHeightPos = 0;
	int   paddingByte    = 0;

	// �o�͗p
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

	// ref�̖��[�𖢊m��(2)��
	ref[ width + 1 ] = 2;

	// code�̖��[�[�����m��(2)��
	code[ width + 1 ] = 2;

	// ref�𔒂ɁAcode��s��(-1)��
	for (int i = 0; i < width + 1; i++ ){
		ref[i]  = 0;
		code[i] = -1;
	}

	code[0] = 0;

	// �r�b�g�}�b�v�t�@�C����1�s������̃o�C�g����4�o�C�g
	// 1�s�N�Z��������3�o�C�g�g�p����
	paddingByte = ( width * 3 ) % 4;
	if( paddingByte != 0 ){
		paddingByte = 4 - paddingByte;
	}

	// �o�̓t�@�C�����쐬
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
			// ���������
			free( ref );
			free( code );

			return -6;
		}

		sprintf( &cPageCount[0]    , "%d"             , pageCount );
		strncpy( strOutputFilePath , strInputFilePath , iDotPos );
		strcat(  strOutputFilePath , "_out_" );
		strcat(  strOutputFilePath , cPageCount );
		strcat(  strOutputFilePath , ".bmp" );

		// �o�̓t�@�C�����ۑ�
		strcpy( &strOutputFilePathAll[ ( pageCount - 1 ) * 256 ] , strOutputFilePath );
	}
	else{
		strcpy( strOutputFilePath , pOutputFilePath );
	}

	// �t�@�C���o�͗p
	wFp = fopen( strOutputFilePath , "wb" );
	if( wFp == NULL ){
		// ���������
		free( ref );
		free( code );

		return -6;
	}

	// �r�b�g�}�b�v�w�b�_�o��
	// �擪2�o�C�g��'BM'
	bTemp[0] = 0x42;
	fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );
	bTemp[0] = 0x4d;
	fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );

	// �t�@�C���T�C�Y
	iTemp[0] = ( ( ( width * 3 ) + paddingByte ) * height ) + 54;
	fwrite( ( char * )&iTemp[0] , sizeof( int ) , 1 , wFp );

	// �\��̈�0����
	bTemp[0] = 0x00;
	fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );
	fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );
	fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );
	fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );

	// �摜�f�[�^�܂ł̃I�t�Z�b�g�f�[�^
	bTemp[0] = 0x36;
	fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );
	bTemp[0] = 0x00;
	fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );
	fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );
	fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );

	// ���w�b�_�̃T�C�Y
	bTemp[0] = 0x28;
	fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );
	bTemp[0] = 0x00;
	fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );
	fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );
	fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );

	// �摜�̕�
	iTemp[0] = width;
	fwrite( ( char * )&iTemp[0] , sizeof( int ) , 1 , wFp );

	// �摜�̍����i���ォ��E���ɏ������ނ̂Ń}�C�i�X�l���������ށj
	iTemp[0] = height - ( height * 2 );
	fwrite( ( char * )&iTemp[0] , sizeof( int ) , 1 , wFp );

	// �v���[����
	bTemp[0] = 0x01;
	fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );
	bTemp[0] = 0x00;
	fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );

	// 1��f������̐F��
	bTemp[0] = 0x18;
	fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );
	bTemp[0] = 0x00;
	fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );

	// �w�b�_�c��0���߁i24�o�C�g�j
	bTemp[0] = 0x00;
	for( int m = 0 ; m < 24 ; m++ ){
		fwrite( ( char * )bTemp , sizeof( BYTE ) , 1 , wFp );
	}

	// �f�[�^���
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
				// �t�@�C���N���[�Y
				fclose( wFp );

				// ���������
				free( ref );
				free( code );

				return -1;
		}

		// a0�����[�܂ŗ��Ă�����Aref�������ւ���code�m��
		if( width < a0 ){

			// code�m��
			ref = code;

			// �F���t�@�C���o��
			for( int j = 0 ; j < width ; j++ ){
				if( ref[j] == 1){
					fwrite( ( char * )bBlack , sizeof( BYTE ) , 3 , wFp );
				}
				else{
					fwrite( ( char * )bWhite , sizeof( BYTE ) , 3 , wFp );
				}
			}

			// padding�����߂�
			for( int m = 0 ; m < paddingByte ; m ++ ){
				fwrite( ( char * )&bPadding[0] , sizeof( BYTE ) , 1 , wFp );
			}

			// ������
			code = new int[ width + 2 ];
			if( code == NULL ){
				// ���������
				free( ref );
				free( code );

				return -2;
			}
			code[0]           = 0;
			code[ width + 1 ] = 2;

			for( int i = 1 ; i < width + 1 ; i++ ){
				code[i] = -1;
			}

			// ���̍s�֐i��
			writeHeightPos++;
			a0 = 0;

			// �Ō�̍s�܂ŏ������񂾂�I��
			if( height <= writeHeightPos ){
				break;
			}
		}

	}

	// �t�@�C���N���[�Y
	fclose( wFp );

	// ���������
	free( ref );
	free( code );

	return 1;
}

// �ǂݍ��񂾃���������f�[�^���擾����
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

	// ���������
	free( bt );
	free( b );

	return result;
}

// ���k���[�h���擾����
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

// Pass mode�̉��
int pass( int * ref , int * code , int a0 , int width ){

	int color = code[a0];
	int b2    = getB2( color , ref , a0 , width );

	// a0�̐F��b2�܂ŏ�������
	for( int i = a0 ; i <= b2 ; i++ ){
		code[i] = color;
	}

	return b2;
}

// Horizontal mode�̉��
int horizontal( int * ref, int * code , int a0 , int width ){

	int color = 0;
	int len1  = 0;
	int len2  = 0;

	if( a0 == 0 ){
		a0 = 1;
	}

	color = code[a0];

	//�܂����m��̈�̏ꍇ�́Aref��color���̗p����
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

	//a0�̐F���m��
	if( code[a0] == -1 ){
		code[a0] = turnColor( color );
	}

	return a0;
}

// Vertical mode�̉��
int vertical(int * ref, int * code , int a0 , int shift , int width ){

	int color = code[a0];
	int b1    = getB1( color , ref , a0 , width );
	int a1    = b1 + shift;

	if( a1 > width + 2 - 1 ){
		a1 = width + 2 - 1;
	}

	// a1�̒��O�܂�color��code�ɐݒ�
	for( int i = a0 ; i < a1 ; i++ ){
		code[i] = color;
	}

	// �Ō�͔��]�������F��ݒ�
	if( ( a1 < width + 2 ) && ( code[a1] == -1 ) ){
		code[a1] = turnColor( color );
	}

	return a1;
}

// B1�̈ʒu�����߂�
int getB1( int color , int * ref , int a0 , int width ){

	// 0:�����l�A1:�ŏ���a0�Ɠ����F�̗̈�A
	int step = 0;
	for( int i = a0 ; i < width + 2 ; i++ ){

		// a0�Ɠ����F
		if( ref[i] == color ){

			// �ŏ���ref��a0�Ɠ����F��������
			if( step == 0 ){
				step = 1;
			}

		// a0�ƈႤ�F
		}
		else{
			//���ɓ����F�������Ă���
			if( step == 1 ){
				//������b1
				return i;
			}
		}
	}

	return width + 2 - 1;
}

// B2�̈ʒu�����߂�
int getB2( int color , int * ref , int a0 , int width ){

	// 0:�����l�A1:�ŏ���a0�Ɠ����F�̗̈�A
	int step = 0;
	for( int i = a0 ; i < width + 2 ; i++ ){

		// a0�Ɠ����F
		if( ref[i] == color ){

			// �ŏ���ref��a0�Ɠ����F��������
			if( step == 0 ){
				step = 1;

			// ����ref��a0�Ɠ����F�������Ă���
			}
			else if( step == 2 ){
				// ������b2
				return i;
			}

		// a0�ƈႤ�F
		}
		else{
			//���ɓ����F�������Ă���
			if( step == 1 ){
				//������b1
				step = 2;
			}
		}
	}

	return width + 2 - 1;
}

// �F�̐ݒ肷�钷�������߂�
int getRunLength( int color ){
	//                                    white                  black
	return ( color == 0 ) ? getRunLength( true ) : getRunLength( false );
}

// �F�̐ݒ肷�钷�������߂�
int getRunLength( bool boolBW ){

	char * key    = new char[14];
	int    result = 0;

	// ������
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
				// ���������
				free( key );

				return result;
			}
		}
		else{
			result += getBlackLength( key );
			if( getBlackLength( key ) < 64 ){
				// ���������
				free( key );

				return result;
			}
		}

		// ������
		i = -1;
		memset( key , '\0' , sizeof( char ) * 14 );
	}

	// ���������
	free( key );

	return 0;

}

// �F�𔽓]������
int turnColor( int color ){
	return ( color == 0 ) ? 1 : 0;
}

// �ǂݍ��񂾃���������f�[�^���擾����
char get(){

	if( 7 < currentArrayPosition ){
		pushArray();
	}

	return ary[ currentArrayPosition++ ];
}

// �������̍X�V���s��
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

// ���F�̐ݒ肷�钷�������߂�
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

// ���F�̐ݒ肷�钷�������߂�
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
