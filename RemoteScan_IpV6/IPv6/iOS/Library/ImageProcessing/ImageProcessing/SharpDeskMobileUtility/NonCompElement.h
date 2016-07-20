#ifndef __NONCOMP_ELEMENT_H__
#define __NONCOMP_ELEMENT_H__

#include "ElementBase.h"

class NonCompElement : public ElementBase
{
	protected:
		virtual int		getProperty();
	public:
		virtual ~NonCompElement();
		virtual void	init();
		virtual void	clear();
};




#endif /* __NONCOMP_ELEMENT_H__ */
