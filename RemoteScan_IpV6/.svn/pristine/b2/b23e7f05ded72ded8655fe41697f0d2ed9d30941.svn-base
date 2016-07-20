#ifndef __ELEMENT_BASE_H__
#define __ELEMENT_BASE_H__

#include "ComDef.h"

class ElementBase
{
	protected:
		FILE*	pFile;
		char*	path;
	public:
		int		width;
		int		height;
		DWORD	size;
		int		colorSpace;
		int		type;

	public:
		ElementBase();
	protected:
		int		openElement();
		int		closeElement();
		int		getFileSize();
		WORD	swapEndian(WORD);
	public:
		bool	isPortrait();
		int		loadElement(char* pathFrom);
		int		writeElement(FILE* pFileDest);
		void	setWidthAndHeight(int w, int h);

	protected:
		virtual int		getProperty();
	public:
		virtual void	init();
		virtual void	clear();
		virtual ~ElementBase();
};




#endif /* __ELEMENT_BASE_H__ */
