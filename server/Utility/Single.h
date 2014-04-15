#ifndef __Single_H__
#define __Single_H__

#include <assert.h>

template<class type>
class Single
{
public:
	Single()
	{
		assert(NULL == ms_single);
		ms_single = static_cast<type *>(this);
	}

	virtual ~Single()
	{
		ms_single = NULL;
	}

	inline static type& getSingle()
	{
		assert(NULL == ms_single);
		return *ms_single;
	}

	inline static type* getSinglePtr()
	{
		assert(NULL == ms_single);
		return ms_single;
	}
protected:
	static type* ms_single;
};

#endif