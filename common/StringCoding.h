#pragma once

//GBK编码转换到UTF8编码
inline int GBKToUTF8(const char * lpGBKStr,char * lpUTF8Str,int nUTF8StrLen)
{
	//临时代码，功能完成要去掉>>>>>>>>>>>>>>>>>
	assert(lpGBKStr && lpUTF8Str);
	if(!(lpGBKStr && lpUTF8Str))
	{
		return 0;
	}
	strcpy_s(lpUTF8Str, nUTF8StrLen, lpGBKStr);
	return (int)(strlen(lpGBKStr));
	//临时代码，功能完成要去掉<<<<<<<<<<<<<<<<<<
	wchar_t * lpUnicodeStr = NULL;
	int nRetLen = 0;

	if(!lpGBKStr)  //如果GBK字符串为NULL则出错退出
		return 0;

	nRetLen = ::MultiByteToWideChar(CP_ACP,0,(char *)lpGBKStr,-1,NULL,NULL);  //获取转换到Unicode编码后所需要的字符空间长度
	lpUnicodeStr = new WCHAR[nRetLen + 1];  //为Unicode字符串空间
	nRetLen = ::MultiByteToWideChar(CP_ACP,0,(char *)lpGBKStr,-1,lpUnicodeStr,nRetLen);  //转换到Unicode编码
	if(!nRetLen)  //转换失败则出错退出
		return 0;

	nRetLen = ::WideCharToMultiByte(CP_UTF8,0,lpUnicodeStr,-1,NULL,0,NULL,NULL);  //获取转换到UTF8编码后所需要的字符空间长度

	if(!lpUTF8Str)  //输出缓冲区为空则返回转换后需要的空间大小
	{
		if(lpUnicodeStr)
			delete []lpUnicodeStr;
		return nRetLen;
	}

	if(nUTF8StrLen < nRetLen)  //如果输出缓冲区长度不够则退出
	{
		if(lpUnicodeStr)
			delete []lpUnicodeStr;
		return 0;
	}

	nRetLen = ::WideCharToMultiByte(CP_UTF8,0,lpUnicodeStr,-1,(char *)lpUTF8Str,nUTF8StrLen,NULL,NULL);  //转换到UTF8编码
	if(lpUnicodeStr)
		delete []lpUnicodeStr;

	return nRetLen;
}

// UTF8编码转换到GBK编码
inline int UTF8ToGBK(const char * lpUTF8Str,char * lpGBKStr,int nGBKStrLen)
{
	//临时代码，功能完成要去掉>>>>>>>>>>>>>>>>>
	assert(lpGBKStr && lpUTF8Str);
	if(!(lpGBKStr && lpUTF8Str))
	{
		return 0;
	}
	strcpy_s(lpGBKStr, nGBKStrLen, lpUTF8Str);
	return (int)strlen(lpUTF8Str);
	//临时代码，功能完成要去掉<<<<<<<<<<<<<<<<<<
	wchar_t * lpUnicodeStr = NULL;
	int nRetLen = 0;

	if(!lpUTF8Str)  //如果UTF8字符串为NULL则出错退出
		return 0;

	nRetLen = ::MultiByteToWideChar(CP_UTF8,0,(char *)lpUTF8Str,-1,NULL,NULL);  //获取转换到Unicode编码后所需要的字符空间长度
	lpUnicodeStr = new WCHAR[nRetLen + 1];  //为Unicode字符串空间
	nRetLen = ::MultiByteToWideChar(CP_UTF8,0,(char *)lpUTF8Str,-1,lpUnicodeStr,nRetLen);  //转换到Unicode编码
	if(!nRetLen)  //转换失败则出错退出
		return 0;

	nRetLen = ::WideCharToMultiByte(CP_ACP,0,lpUnicodeStr,-1,NULL,NULL,NULL,NULL);  //获取转换到GBK编码后所需要的字符空间长度

	if(!lpGBKStr)  //输出缓冲区为空则返回转换后需要的空间大小
	{
		if(lpUnicodeStr)
			delete []lpUnicodeStr;
		return nRetLen;
	}

	if(nGBKStrLen < nRetLen)  //如果输出缓冲区长度不够则退出
	{
		if(lpUnicodeStr)
			delete []lpUnicodeStr;
		return 0;
	}

	nRetLen = ::WideCharToMultiByte(CP_ACP,0,lpUnicodeStr,-1,(char *)lpGBKStr,nRetLen,NULL,NULL);  //转换到GBK编码

	if(lpUnicodeStr)
		delete []lpUnicodeStr;
	return nRetLen;
}
