#ifndef __PDFCREATOR_H__
#define __PDFCREATOR_H__

#include "ComDef.h"
#include "JpegElement.h"
#include "ElementBase.h"

const int TYPE_UNDEFINED = -1;
const int TYPE_NONE_USED = 0;
const int TYPE_PAGE_LIST = 1;
const int TYPE_CATALOG = 2;
const int TYPE_PAGE = 3;
const int TYPE_RES = 4;
const int TYPE_CONTENT = 5;
const int TYPE_XOBJECT = 6;


class PDFElement
{
	public:
		int		index;
		DWORD	position;
		int		type;
	public:
		PDFElement*		pNext;
		PDFElement();
};

class PDFElementManager
{
	private:
		PDFElement*		pTop;
		PDFElement*		pLast;
	public:
		int		num;
		DWORD	positionXref;
	public:
		PDFElementManager();
		~PDFElementManager();
		PDFElement*		createPDFElement();
		int		searchIndex(int);
		int		searchIndex(int, int);
		int		searchIndex(PDFElement*, int);
		int		getNumOfType(int);
		void	clear();
		PDFElement*		getTopElement();
		PDFElement*		getNextElement(PDFElement*);
		PDFElement*		searchElement(int);

};

class PDFCreator
{
	private:
		FILE*	pFile;
		JpegElement** jpegElements;
		ElementBase** elements;
		int		numElements;
		int		pageWidth;
		int		pageHeight;
		int		consumedJpegNum;

	public:
		char*	path;
		int		nup;
		int		order;
		bool	hasPrintBorder;
		bool	isPortrait;
		int		paperSize;
	protected:
		PDFElementManager	*pElmManager;

	public:
		PDFCreator();
		~PDFCreator();
		void	clear();
		int		mergeJpegToPdf(char* pathJpeg[], int numFile, char* pathPdf, int printForm, int nup, int order, bool printBorder);
		int		mergeToPdf(char* pathJpeg[], int numFile, int width[], int height[], int type , char* pathPdf, int printForm, int nup, int order, bool printBorder);

	private:
		int		createJpegElements(char* pathJpeg[]);
		int		createElements(char* pathJpeg[]);
		int		createElements(char* pathJpeg[], int type, int width[], int height[]);
		int		openCreatePDFFile();
		int		changeTargetPaperLayout();
		int		getPageNum();
		int		getContentWidth(int);
		int		getContentHeight(int);
		int		getContentX(int);
		int		getContentY(int);
		bool	isRotation(int);
		int		setNup(int);
		int		setOrder(int);
		int		setPrintForm(int);
		int		setTargetPaperSize();
		int		createPDF();
		int		createPreDifinedElements();
		int		createNonUsedReference();
		int		createCatalogElement();
		int		createPageListElement();
		int		setVersion();
		int		setCatalog();
		int		setPageList();
		int		setKidsPage();
		int		setResource();
		int		setContent();
		int		setXObject();
		int		setCrossReferenceTable();
		int		setTrailer();
};


#endif /* __PDFCREATOR_H__ */
