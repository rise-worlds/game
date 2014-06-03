// Copyright (c) 2008-2010 Rise Worlds. All rights reserved.
// 
// Purpose : The XML configuration file read and write class.
// Create  : 12/05/2010   22:54  Rise Worlds
// ----------------------------------------------------------------------------
#ifndef __XMLCONFIG_H__
#define __XMLCONFIG_H__

BEGINNAMESPACE

class XmlConfigImpl;

class XmlConfig
{
public:
	XmlConfig(const string &path, bool write = false);
	~XmlConfig();

	void SetValue(const string &key, bool &value);
	void SetValue(const string &key, int  &value);
	void SetValue(const string &key, double &value);
	void SetValue(const string &key, float &value);
	void SetValue(const string &key, string &value);

	bool GetValue(const string &key, const bool &default = false);
	int GetValue(const string &key, const int &default = 0);
	float GetValue(const string &key, const float &default = 0.f);
	double GetValue(const string &key, const double &default = 0.0);
	string GetValue(const string &key, const string &default = "\0");
protected:
private:
	XmlConfigImpl *m_pImpl;
};
ENDNAMESPACE

#endif // __XMLCONFIG_H__