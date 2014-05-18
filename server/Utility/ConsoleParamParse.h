#ifndef __ConsoleParamParse_H__
#define __ConsoleParamParse_H__

#include <vector>
#include <string>
#include <string.h>
#include <stdlib.h>

BEGINNAMESPACE

class CParamParse
{
public:
	CParamParse(const char* pParam)
	{
		int	nMaxLen	= int(strlen(pParam));

		int nPos		= 0;
		std::string strParam;

		while (nPos < nMaxLen)
		{
			if (pParam[nPos] == ' ')
			{
				m_pParamStr.push_back(strParam);
				strParam	= "";
			}

			if (pParam[nPos] != ' ')
			{
				strParam	+= pParam[nPos];
			}

			nPos++;
		}

		m_pParamStr.push_back(strParam);
	}

	~CParamParse()
	{
	}

	std::string GetString(int nIndex)
	{
		return GetParam(nIndex);
	}

	int GetInt(int nIndex)
	{
		return atoi(GetParam(nIndex).c_str());
	}

	float GetFloat(int nIndex)
	{
		return static_cast<float>(atof(GetParam(nIndex).c_str()));
	}

private:
	std::string GetParam(int nIndex)
	{
		if (nIndex < static_cast<int>(m_pParamStr.size()))
		{
			return m_pParamStr[nIndex];
		}
		return std::string("");
	}

private:
	std::vector<std::string>	m_pParamStr;
};

ENDNAMESPACE

#endif // __ConsoleParamParse_H__