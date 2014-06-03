// Copyright (c) 2008-2010 Rise Worlds. All rights reserved.
// 
// Purpose : The XML configuration file read and write class.
// Create  : 12/05/2010   22:54  Rise Worlds
// ----------------------------------------------------------------------------
#include "stdafx.h"
#include "XmlConfig.h"



#include <boost/foreach.hpp>
#include <boost/property_tree/ptree.hpp>
#include <boost/property_tree/xml_parser.hpp>

using namespace boost::property_tree;
using namespace boost::property_tree::xml_parser;

BEGINNAMESPACE

xml_writer_settings<char> ms_xwss('*', 0, "gb18030");

class XmlConfigImpl
{
public:
	XmlConfigImpl(const string &path, bool write/* = false*/)
		:m_path(path), m_write(write)
	{
		if (m_write)
		{
		}
		try
		{
			read_xml(path, m_pt);
		}
		catch (...)
		{
		}
	}

	~XmlConfigImpl()
	{
		if (m_write)
		{
			try
			{
				write_xml(m_path, m_pt, std::locale(), ms_xwss);
			}
			catch (...)
			{
			}
		}
	}

	template<class T>
	void SetValue(const string &key, T &value)
	{
		try
		{
			m_pt.put<T>(key, value);
		}
		catch (...)
		{
		}
	}

	template<class T>
	T GetValue(const string &key, const T &default)
	{
		try
		{
			return m_pt.get<T>(key, default);
		}
		catch (...)
		{
			return default;
		}
	}
protected:
private:
	string m_path;
	bool m_write;

	ptree m_pt;
};

XmlConfig::XmlConfig(const string &path, bool write/* = false*/)
{
	m_pImpl = new XmlConfigImpl(path, write);
}

XmlConfig::~XmlConfig()
{
	if (m_pImpl)
	{
		delete m_pImpl;
	}
}

void XmlConfig::SetValue(const string& key, bool& value)
{
	m_pImpl->SetValue<bool>(key, value);
}

void XmlConfig::SetValue(const string& key, int& value)
{
	m_pImpl->SetValue<int>(key, value);
}

void XmlConfig::SetValue(const string& key, float& value)
{
	m_pImpl->SetValue<float>(key, value);
}

void XmlConfig::SetValue(const string& key, double& value)
{
	m_pImpl->SetValue<double>(key, value);
}

void XmlConfig::SetValue(const string& key, string& value)
{
	m_pImpl->SetValue<string>(key, value);
}

bool XmlConfig::GetValue(const string& key, const bool &default/* = 0*/)
{
	return m_pImpl->GetValue<bool>(key, default);
}

int XmlConfig::GetValue(const string& key, const int &default/* = 0*/)
{
	return m_pImpl->GetValue<int>(key, default);
}

float XmlConfig::GetValue(const string& key, const float &default/* = 0*/)
{
	return m_pImpl->GetValue<float>(key, default);
}

double XmlConfig::GetValue(const string& key, const double &default/* = 0.0*/)
{
	return m_pImpl->GetValue<double>(key, default);
}

string XmlConfig::GetValue(const string& key, const string &default/* = "\0"*/)
{
	return m_pImpl->GetValue<string>(key, default);
}

ENDNAMESPACE
