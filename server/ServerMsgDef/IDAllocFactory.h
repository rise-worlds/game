#ifndef __IDALLOCFACTORY_H__
#define __IDALLOCFACTORY_H__
#include <vector>

template<class T, int INIT_ID	= 1>
class IDAllocFactory
{
public:
	IDAllocFactory()
	{
		m_nPos	= INIT_ID;
	}

	~IDAllocFactory()
	{

	}

	void	SetStartID(T id)
	{
		m_FreeID.clear();
		m_nPos	= id;
	}

	T	AllocID()
	{
		T	nID	= 0;
		if (m_FreeID.size())
		{
			nID	= m_FreeID.back();
			m_FreeID.pop_back();
		}
		else
		{
			nID	= m_nPos++;
		}

		return nID;
	}

	void	FreeID(T nID)
	{
		m_FreeID.push_back(nID);
	}

	std::vector<T>		m_FreeID;
	T					m_nPos;
};

#endif // __IDALLOCFACTORY_H__