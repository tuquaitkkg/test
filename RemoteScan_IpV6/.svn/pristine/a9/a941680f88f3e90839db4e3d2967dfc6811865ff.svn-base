#ifndef __CONTENT_POSITION_H__
#define __CONTENT_POSITION_H__

#include "ComDef.h"

class ContentPosition
{
	private:
		int		dispWidth;
		int		dispHeight;
		int		nup;
		int		order;
		int		count;
		int		orgWidth;
		int		orgHeight;
	public:
		int		width;
		int		height;
		int		marginWidth;
		int		marginHeight;
		int		x;
		int		y;
		bool	isConvert;
	public:
		ContentPosition();
		ContentPosition(int, int, int, int, int, int, int);
		~ContentPosition();
		void	setDisplaySize(int, int);
		void	setPortrait(bool);
		void	setCountInNup(int);
		void	setDiplayNup(int);
		void	setDiplayNupOrder(int);
		void	setContentSize(int, int);
		void	calc();
	private:
		void	checkPriority();
		void	setDefaultContentSize();
		void	calcContentSize();
		void	calcContentX();
		void	calcContentY();
};


#endif /* __CONTENT_POSITION_H__ */
