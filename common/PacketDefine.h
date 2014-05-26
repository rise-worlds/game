#pragma once

#include <string>

#define MSGPACK_DEFINE(...) \
	virtual	void	Pack(WriteBuf& buffer) \
	{ \
		PackCommon::Pack(buffer); \
		TMakeMessageDefine(__VA_ARGS__).MessagePack(buffer); \
	} \
	virtual	void	UnPack(ReadBuf& buffer) \
	{ \
		PackCommon::UnPack(buffer); \
		TMakeMessageDefine(__VA_ARGS__).MessageUnPack(buffer); \
	} \
	virtual	int		GetPackSize() \
	{ \
		return PackCommon::GetPackSize() + TMakeMessageDefine(__VA_ARGS__).MessageSize(); \
	}


template <typename Type>
inline int	TGetTypeSize(const Type& value)
{
	return sizeof(Type);
}

#define GET_TYPESIZE_VALUE(value) TGetTypeSize(value)
#define GET_TYPESIZE_TYPE(type) TGetTypeSize(type())

#define DEF_TYPESIZE(type, value) \
	template<> \
	inline int TGetTypeSize<type>(const type& value)

template <>
inline int	TGetTypeSize<std::string>(const std::string& value)
{
	return int(value.length() + 1);
}

template <>
inline int	TGetTypeSize<char*>(char* const& value)
{
	return int(strlen(value) + 1);
}



template <typename A0 = void, typename A1 = void, typename A2 = void, typename A3 = void, typename A4 = void, typename A5 = void, typename A6 = void, typename A7 = void, typename A8 = void, typename A9 = void, typename A10 = void, typename A11 = void, typename A12 = void, typename A13 = void, typename A14 = void, typename A15 = void, typename A16 = void, typename A17 = void, typename A18 = void, typename A19 = void, typename A20 = void, typename A21 = void, typename A22 = void, typename A23 = void, typename A24 = void, typename A25 = void, typename A26 = void, typename A27 = void, typename A28 = void, typename A29 = void, typename A30 = void, typename A31 = void, typename A32 = void>
struct TMessageDefine;

template <>
struct TMessageDefine<>
{
	TMessageDefine()
	{}
	
	template <typename Buffer>
	void MessagePack(Buffer& pk) const
	{
	}

	template <typename Buffer>
	void MessageUnPack(Buffer& pk) const
	{
	}

	int MessageSize() const
	{
		return 0;
	}
};

template <typename A0>
struct TMessageDefine<A0>
{
	TMessageDefine(A0& _a0):
	a0(_a0) {}
	
	template <typename Buffer>
	void MessagePack(Buffer& pk) const
	{
		pk << a0;
	}

	template <typename Buffer>
	void MessageUnPack(Buffer& pk) const
	{
		pk >> a0;
	}

	int MessageSize() const
	{
		return GET_TYPESIZE_VALUE(a0);
	}

	A0& a0;
};

template <typename A0, typename A1>
struct TMessageDefine<A0, A1>
{
	TMessageDefine(A0& _a0, A1& _a1) :
	a0(_a0), a1(_a1) {}
	
	template <typename Buffer>
	void MessagePack(Buffer& pk) const
	{
		pk << a0;
		pk << a1;
	}

	template <typename Buffer>
	void MessageUnPack(Buffer& pk) const
	{
		pk >> a0;
		pk >> a1;
	}

	int MessageSize() const
	{
		return GET_TYPESIZE_VALUE(a0) + GET_TYPESIZE_VALUE(a1);
	}

	A0& a0;
	A1& a1;
};

template <typename A0, typename A1, typename A2>
struct TMessageDefine<A0, A1, A2>
{
	TMessageDefine(A0& _a0, A1& _a1, A2& _a2) :
	a0(_a0), a1(_a1), a2(_a2) {}
	
	template <typename Buffer>
	void MessagePack(Buffer& pk) const
	{
		pk << a0;
		pk << a1;
		pk << a2;
	}

	template <typename Buffer>
	void MessageUnPack(Buffer& pk) const
	{
		pk >> a0;
		pk >> a1;
		pk >> a2;
	}

	int MessageSize() const
	{
		return GET_TYPESIZE_VALUE(a0) + GET_TYPESIZE_VALUE(a1) + GET_TYPESIZE_VALUE(a2);
	}

	A0& a0;
	A1& a1;
	A2& a2;
};

template <typename A0, typename A1, typename A2, typename A3>
struct TMessageDefine<A0, A1, A2, A3>
{
	TMessageDefine(A0& _a0, A1& _a1, A2& _a2, A3& _a3) :
	a0(_a0), a1(_a1), a2(_a2), a3(_a3) {}
	
	template <typename Buffer>
	void MessagePack(Buffer& pk) const
	{
		pk << a0;
		pk << a1;
		pk << a2;
		pk << a3;
	}

	template <typename Buffer>
	void MessageUnPack(Buffer& pk) const
	{
		pk >> a0;
		pk >> a1;
		pk >> a2;
		pk >> a3;
	}

	int MessageSize() const
	{
		return GET_TYPESIZE_VALUE(a0) + GET_TYPESIZE_VALUE(a1) + GET_TYPESIZE_VALUE(a2) + GET_TYPESIZE_VALUE(a3);
	}

	A0& a0;
	A1& a1;
	A2& a2;
	A3& a3;
};

template <typename A0, typename A1, typename A2, typename A3, typename A4>
struct TMessageDefine<A0, A1, A2, A3, A4>
{
	TMessageDefine(A0& _a0, A1& _a1, A2& _a2, A3& _a3, A4& _a4) :
	a0(_a0), a1(_a1), a2(_a2), a3(_a3), a4(_a4) {}
	
	template <typename Buffer>
	void MessagePack(Buffer& pk) const
	{
		pk << a0;
		pk << a1;
		pk << a2;
		pk << a3;
		pk << a4;
	}

	template <typename Buffer>
	void MessageUnPack(Buffer& pk) const
	{
		pk >> a0;
		pk >> a1;
		pk >> a2;
		pk >> a3;
		pk >> a4;
	}

	int MessageSize() const
	{
		return GET_TYPESIZE_VALUE(a0)
			+ GET_TYPESIZE_VALUE(a1)
			+ GET_TYPESIZE_VALUE(a2)
			+ GET_TYPESIZE_VALUE(a3)
			+ GET_TYPESIZE_VALUE(a4);
	}

	A0& a0;
	A1& a1;
	A2& a2;
	A3& a3;
	A4& a4;
};

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5>
struct TMessageDefine<A0, A1, A2, A3, A4, A5>
{
	TMessageDefine(A0& _a0, A1& _a1, A2& _a2, A3& _a3, A4& _a4, A5& _a5) :
	a0(_a0), a1(_a1), a2(_a2), a3(_a3), a4(_a4), a5(_a5) {}
	
	template <typename Buffer>
	void MessagePack(Buffer& pk) const
	{
		pk << a0;
		pk << a1;
		pk << a2;
		pk << a3;
		pk << a4;
		pk << a5;
	}

	template <typename Buffer>
	void MessageUnPack(Buffer& pk) const
	{
		pk >> a0;
		pk >> a1;
		pk >> a2;
		pk >> a3;
		pk >> a4;
		pk >> a5;
	}

	int MessageSize() const
	{
		return GET_TYPESIZE_VALUE(a0)
			+ GET_TYPESIZE_VALUE(a1)
			+ GET_TYPESIZE_VALUE(a2)
			+ GET_TYPESIZE_VALUE(a3)
			+ GET_TYPESIZE_VALUE(a4)
			+ GET_TYPESIZE_VALUE(a5);
	}

	A0& a0;
	A1& a1;
	A2& a2;
	A3& a3;
	A4& a4;
	A5& a5;
};

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6>
struct TMessageDefine<A0, A1, A2, A3, A4, A5, A6>
{
	TMessageDefine(A0& _a0, A1& _a1, A2& _a2, A3& _a3, A4& _a4, A5& _a5, A6& _a6) :
	a0(_a0), a1(_a1), a2(_a2), a3(_a3), a4(_a4), a5(_a5), a6(_a6) {}
	
	template <typename Buffer>
	void MessagePack(Buffer& pk) const
	{
		pk << a0;
		pk << a1;
		pk << a2;
		pk << a3;
		pk << a4;
		pk << a5;
		pk << a6;
	}

	template <typename Buffer>
	void MessageUnPack(Buffer& pk) const
	{
		pk >> a0;
		pk >> a1;
		pk >> a2;
		pk >> a3;
		pk >> a4;
		pk >> a5;
		pk >> a6;
	}

	int MessageSize() const
	{
		return GET_TYPESIZE_VALUE(a0)
			+ GET_TYPESIZE_VALUE(a1)
			+ GET_TYPESIZE_VALUE(a2)
			+ GET_TYPESIZE_VALUE(a3)
			+ GET_TYPESIZE_VALUE(a4)
			+ GET_TYPESIZE_VALUE(a5)
			+ GET_TYPESIZE_VALUE(a6);
	}

	A0& a0;
	A1& a1;
	A2& a2;
	A3& a3;
	A4& a4;
	A5& a5;
	A6& a6;
};

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7>
struct TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7>
{
	TMessageDefine(A0& _a0, A1& _a1, A2& _a2, A3& _a3, A4& _a4, A5& _a5, A6& _a6, A7& _a7) :
	a0(_a0), a1(_a1), a2(_a2), a3(_a3), a4(_a4), a5(_a5), a6(_a6), a7(_a7) {}
	
	template <typename Buffer>
	void MessagePack(Buffer& pk) const
	{
		pk << a0;
		pk << a1;
		pk << a2;
		pk << a3;
		pk << a4;
		pk << a5;
		pk << a6;
		pk << a7;
	}

	template <typename Buffer>
	void MessageUnPack(Buffer& pk) const
	{
		pk >> a0;
		pk >> a1;
		pk >> a2;
		pk >> a3;
		pk >> a4;
		pk >> a5;
		pk >> a6;
		pk >> a7;
	}

	int MessageSize() const
	{
		return GET_TYPESIZE_VALUE(a0)
			+ GET_TYPESIZE_VALUE(a1)
			+ GET_TYPESIZE_VALUE(a2)
			+ GET_TYPESIZE_VALUE(a3)
			+ GET_TYPESIZE_VALUE(a4)
			+ GET_TYPESIZE_VALUE(a5)
			+ GET_TYPESIZE_VALUE(a6)
			+ GET_TYPESIZE_VALUE(a7);
	}

	A0& a0;
	A1& a1;
	A2& a2;
	A3& a3;
	A4& a4;
	A5& a5;
	A6& a6;
	A7& a7;
};

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8>
struct TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8>
{
	TMessageDefine(A0& _a0, A1& _a1, A2& _a2, A3& _a3, A4& _a4, A5& _a5, A6& _a6, A7& _a7, A8& _a8) :
	a0(_a0), a1(_a1), a2(_a2), a3(_a3), a4(_a4), a5(_a5), a6(_a6), a7(_a7), a8(_a8) {}
	
	template <typename Buffer>
	void MessagePack(Buffer& pk) const
	{
		pk << a0;
		pk << a1;
		pk << a2;
		pk << a3;
		pk << a4;
		pk << a5;
		pk << a6;
		pk << a7;
		pk << a8;
	}

	template <typename Buffer>
	void MessageUnPack(Buffer& pk) const
	{
		pk >> a0;
		pk >> a1;
		pk >> a2;
		pk >> a3;
		pk >> a4;
		pk >> a5;
		pk >> a6;
		pk >> a7;
		pk >> a8;
	}

	int MessageSize() const
	{
		return GET_TYPESIZE_VALUE(a0)
			+ GET_TYPESIZE_VALUE(a1)
			+ GET_TYPESIZE_VALUE(a2)
			+ GET_TYPESIZE_VALUE(a3)
			+ GET_TYPESIZE_VALUE(a4)
			+ GET_TYPESIZE_VALUE(a5)
			+ GET_TYPESIZE_VALUE(a6)
			+ GET_TYPESIZE_VALUE(a7)
			+ GET_TYPESIZE_VALUE(a8);
	}

	A0& a0;
	A1& a1;
	A2& a2;
	A3& a3;
	A4& a4;
	A5& a5;
	A6& a6;
	A7& a7;
	A8& a8;
};

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9>
struct TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9>
{
	TMessageDefine(A0& _a0, A1& _a1, A2& _a2, A3& _a3, A4& _a4, A5& _a5, A6& _a6, A7& _a7, A8& _a8, A9& _a9) :
	a0(_a0), a1(_a1), a2(_a2), a3(_a3), a4(_a4), a5(_a5), a6(_a6), a7(_a7), a8(_a8), a9(_a9) {}
	
	template <typename Buffer>
	void MessagePack(Buffer& pk) const
	{
		pk << a0;
		pk << a1;
		pk << a2;
		pk << a3;
		pk << a4;
		pk << a5;
		pk << a6;
		pk << a7;
		pk << a8;
		pk << a9;
	}

	template <typename Buffer>
	void MessageUnPack(Buffer& pk) const
	{
		pk >> a0;
		pk >> a1;
		pk >> a2;
		pk >> a3;
		pk >> a4;
		pk >> a5;
		pk >> a6;
		pk >> a7;
		pk >> a8;
		pk >> a9;
	}

	int MessageSize() const
	{
		return GET_TYPESIZE_VALUE(a0)
			+ GET_TYPESIZE_VALUE(a1)
			+ GET_TYPESIZE_VALUE(a2)
			+ GET_TYPESIZE_VALUE(a3)
			+ GET_TYPESIZE_VALUE(a4)
			+ GET_TYPESIZE_VALUE(a5)
			+ GET_TYPESIZE_VALUE(a6)
			+ GET_TYPESIZE_VALUE(a7)
			+ GET_TYPESIZE_VALUE(a8)
			+ GET_TYPESIZE_VALUE(a9);
	}

	A0& a0;
	A1& a1;
	A2& a2;
	A3& a3;
	A4& a4;
	A5& a5;
	A6& a6;
	A7& a7;
	A8& a8;
	A9& a9;
};

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10>
struct TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10>
{
	TMessageDefine(A0& _a0, A1& _a1, A2& _a2, A3& _a3, A4& _a4, A5& _a5, A6& _a6, A7& _a7, A8& _a8, A9& _a9, A10& _a10) :
	a0(_a0), a1(_a1), a2(_a2), a3(_a3), a4(_a4), a5(_a5), a6(_a6), a7(_a7), a8(_a8), a9(_a9), a10(_a10) {}
	
	template <typename Buffer>
	void MessagePack(Buffer& pk) const
	{
		pk << a0;
		pk << a1;
		pk << a2;
		pk << a3;
		pk << a4;
		pk << a5;
		pk << a6;
		pk << a7;
		pk << a8;
		pk << a9;
		pk << a10;
	}

	template <typename Buffer>
	void MessageUnPack(Buffer& pk) const
	{
		pk >> a0;
		pk >> a1;
		pk >> a2;
		pk >> a3;
		pk >> a4;
		pk >> a5;
		pk >> a6;
		pk >> a7;
		pk >> a8;
		pk >> a9;
		pk >> a10;
	}

	int MessageSize() const
	{
		return GET_TYPESIZE_VALUE(a0)
			+ GET_TYPESIZE_VALUE(a1)
			+ GET_TYPESIZE_VALUE(a2)
			+ GET_TYPESIZE_VALUE(a3)
			+ GET_TYPESIZE_VALUE(a4)
			+ GET_TYPESIZE_VALUE(a5)
			+ GET_TYPESIZE_VALUE(a6)
			+ GET_TYPESIZE_VALUE(a7)
			+ GET_TYPESIZE_VALUE(a8)
			+ GET_TYPESIZE_VALUE(a9)
			+ GET_TYPESIZE_VALUE(a10);
	}

	A0& a0;
	A1& a1;
	A2& a2;
	A3& a3;
	A4& a4;
	A5& a5;
	A6& a6;
	A7& a7;
	A8& a8;
	A9& a9;
	A10& a10;
};

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11>
struct TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11>
{
	TMessageDefine(A0& _a0, A1& _a1, A2& _a2, A3& _a3, A4& _a4, A5& _a5, A6& _a6, A7& _a7, A8& _a8, A9& _a9, A10& _a10, A11& _a11) :
	a0(_a0), a1(_a1), a2(_a2), a3(_a3), a4(_a4), a5(_a5), a6(_a6), a7(_a7), a8(_a8), a9(_a9), a10(_a10), a11(_a11) {}
	
	template <typename Buffer>
	void MessagePack(Buffer& pk) const
	{
		pk << a0;
		pk << a1;
		pk << a2;
		pk << a3;
		pk << a4;
		pk << a5;
		pk << a6;
		pk << a7;
		pk << a8;
		pk << a9;
		pk << a10;
		pk << a11;
	}

	template <typename Buffer>
	void MessageUnPack(Buffer& pk) const
	{
		pk >> a0;
		pk >> a1;
		pk >> a2;
		pk >> a3;
		pk >> a4;
		pk >> a5;
		pk >> a6;
		pk >> a7;
		pk >> a8;
		pk >> a9;
		pk >> a10;
		pk >> a11;
	}

	int MessageSize() const
	{
		return GET_TYPESIZE_VALUE(a0)
			+ GET_TYPESIZE_VALUE(a1)
			+ GET_TYPESIZE_VALUE(a2)
			+ GET_TYPESIZE_VALUE(a3)
			+ GET_TYPESIZE_VALUE(a4)
			+ GET_TYPESIZE_VALUE(a5)
			+ GET_TYPESIZE_VALUE(a6)
			+ GET_TYPESIZE_VALUE(a7)
			+ GET_TYPESIZE_VALUE(a8)
			+ GET_TYPESIZE_VALUE(a9)
			+ GET_TYPESIZE_VALUE(a10)
			+ GET_TYPESIZE_VALUE(a11);
	}

	A0& a0;
	A1& a1;
	A2& a2;
	A3& a3;
	A4& a4;
	A5& a5;
	A6& a6;
	A7& a7;
	A8& a8;
	A9& a9;
	A10& a10;
	A11& a11;
};

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12>
struct TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12>
{
	TMessageDefine(A0& _a0, A1& _a1, A2& _a2, A3& _a3, A4& _a4, A5& _a5, A6& _a6, A7& _a7, A8& _a8, A9& _a9, A10& _a10, A11& _a11, A12& _a12) :
	a0(_a0), a1(_a1), a2(_a2), a3(_a3), a4(_a4), a5(_a5), a6(_a6), a7(_a7), a8(_a8), a9(_a9), a10(_a10), a11(_a11), a12(_a12) {}
	
	template <typename Buffer>
	void MessagePack(Buffer& pk) const
	{
		pk << a0;
		pk << a1;
		pk << a2;
		pk << a3;
		pk << a4;
		pk << a5;
		pk << a6;
		pk << a7;
		pk << a8;
		pk << a9;
		pk << a10;
		pk << a11;
		pk << a12;
	}

	template <typename Buffer>
	void MessageUnPack(Buffer& pk) const
	{
		pk >> a0;
		pk >> a1;
		pk >> a2;
		pk >> a3;
		pk >> a4;
		pk >> a5;
		pk >> a6;
		pk >> a7;
		pk >> a8;
		pk >> a9;
		pk >> a10;
		pk >> a11;
		pk >> a12;
	}

	int MessageSize() const
	{
		return GET_TYPESIZE_VALUE(a0)
			+ GET_TYPESIZE_VALUE(a1)
			+ GET_TYPESIZE_VALUE(a2)
			+ GET_TYPESIZE_VALUE(a3)
			+ GET_TYPESIZE_VALUE(a4)
			+ GET_TYPESIZE_VALUE(a5)
			+ GET_TYPESIZE_VALUE(a6)
			+ GET_TYPESIZE_VALUE(a7)
			+ GET_TYPESIZE_VALUE(a8)
			+ GET_TYPESIZE_VALUE(a9)
			+ GET_TYPESIZE_VALUE(a10)
			+ GET_TYPESIZE_VALUE(a11)
			+ GET_TYPESIZE_VALUE(a12);
	}

	A0& a0;
	A1& a1;
	A2& a2;
	A3& a3;
	A4& a4;
	A5& a5;
	A6& a6;
	A7& a7;
	A8& a8;
	A9& a9;
	A10& a10;
	A11& a11;
	A12& a12;
};

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12, typename A13>
struct TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13>
{
	TMessageDefine(A0& _a0, A1& _a1, A2& _a2, A3& _a3, A4& _a4, A5& _a5, A6& _a6, A7& _a7, A8& _a8, A9& _a9, A10& _a10, A11& _a11, A12& _a12, A13& _a13) :
	a0(_a0), a1(_a1), a2(_a2), a3(_a3), a4(_a4), a5(_a5), a6(_a6), a7(_a7), a8(_a8), a9(_a9), a10(_a10), a11(_a11), a12(_a12), a13(_a13) {}
	
	template <typename Buffer>
	void MessagePack(Buffer& pk) const
	{
		pk << a0;
		pk << a1;
		pk << a2;
		pk << a3;
		pk << a4;
		pk << a5;
		pk << a6;
		pk << a7;
		pk << a8;
		pk << a9;
		pk << a10;
		pk << a11;
		pk << a12;
		pk << a13;
	}

	template <typename Buffer>
	void MessageUnPack(Buffer& pk) const
	{
		pk >> a0;
		pk >> a1;
		pk >> a2;
		pk >> a3;
		pk >> a4;
		pk >> a5;
		pk >> a6;
		pk >> a7;
		pk >> a8;
		pk >> a9;
		pk >> a10;
		pk >> a11;
		pk >> a12;
		pk >> a13;
	}

	int MessageSize() const
	{
		return GET_TYPESIZE_VALUE(a0)
			+ GET_TYPESIZE_VALUE(a1)
			+ GET_TYPESIZE_VALUE(a2)
			+ GET_TYPESIZE_VALUE(a3)
			+ GET_TYPESIZE_VALUE(a4)
			+ GET_TYPESIZE_VALUE(a5)
			+ GET_TYPESIZE_VALUE(a6)
			+ GET_TYPESIZE_VALUE(a7)
			+ GET_TYPESIZE_VALUE(a8)
			+ GET_TYPESIZE_VALUE(a9)
			+ GET_TYPESIZE_VALUE(a10)
			+ GET_TYPESIZE_VALUE(a11)
			+ GET_TYPESIZE_VALUE(a12)
			+ GET_TYPESIZE_VALUE(a13);
	}

	A0& a0;
	A1& a1;
	A2& a2;
	A3& a3;
	A4& a4;
	A5& a5;
	A6& a6;
	A7& a7;
	A8& a8;
	A9& a9;
	A10& a10;
	A11& a11;
	A12& a12;
	A13& a13;
};

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12, typename A13, typename A14>
struct TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14>
{
	TMessageDefine(A0& _a0, A1& _a1, A2& _a2, A3& _a3, A4& _a4, A5& _a5, A6& _a6, A7& _a7, A8& _a8, A9& _a9, A10& _a10, A11& _a11, A12& _a12, A13& _a13, A14& _a14) :
	a0(_a0), a1(_a1), a2(_a2), a3(_a3), a4(_a4), a5(_a5), a6(_a6), a7(_a7), a8(_a8), a9(_a9), a10(_a10), a11(_a11), a12(_a12), a13(_a13), a14(_a14) {}
	
	template <typename Buffer>
	void MessagePack(Buffer& pk) const
	{
		pk << a0;
		pk << a1;
		pk << a2;
		pk << a3;
		pk << a4;
		pk << a5;
		pk << a6;
		pk << a7;
		pk << a8;
		pk << a9;
		pk << a10;
		pk << a11;
		pk << a12;
		pk << a13;
		pk << a14;
	}

	template <typename Buffer>
	void MessageUnPack(Buffer& pk) const
	{
		pk >> a0;
		pk >> a1;
		pk >> a2;
		pk >> a3;
		pk >> a4;
		pk >> a5;
		pk >> a6;
		pk >> a7;
		pk >> a8;
		pk >> a9;
		pk >> a10;
		pk >> a11;
		pk >> a12;
		pk >> a13;
		pk >> a14;
	}

	int MessageSize() const
	{
		return GET_TYPESIZE_VALUE(a0)
			+ GET_TYPESIZE_VALUE(a1)
			+ GET_TYPESIZE_VALUE(a2)
			+ GET_TYPESIZE_VALUE(a3)
			+ GET_TYPESIZE_VALUE(a4)
			+ GET_TYPESIZE_VALUE(a5)
			+ GET_TYPESIZE_VALUE(a6)
			+ GET_TYPESIZE_VALUE(a7)
			+ GET_TYPESIZE_VALUE(a8)
			+ GET_TYPESIZE_VALUE(a9)
			+ GET_TYPESIZE_VALUE(a10)
			+ GET_TYPESIZE_VALUE(a11)
			+ GET_TYPESIZE_VALUE(a12)
			+ GET_TYPESIZE_VALUE(a13)
			+ GET_TYPESIZE_VALUE(a14);
	}

	A0& a0;
	A1& a1;
	A2& a2;
	A3& a3;
	A4& a4;
	A5& a5;
	A6& a6;
	A7& a7;
	A8& a8;
	A9& a9;
	A10& a10;
	A11& a11;
	A12& a12;
	A13& a13;
	A14& a14;
};

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12, typename A13, typename A14, typename A15>
struct TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15>
{
	TMessageDefine(A0& _a0, A1& _a1, A2& _a2, A3& _a3, A4& _a4, A5& _a5, A6& _a6, A7& _a7, A8& _a8, A9& _a9, A10& _a10, A11& _a11, A12& _a12, A13& _a13, A14& _a14, A15& _a15) :
	a0(_a0), a1(_a1), a2(_a2), a3(_a3), a4(_a4), a5(_a5), a6(_a6), a7(_a7), a8(_a8), a9(_a9), a10(_a10), a11(_a11), a12(_a12), a13(_a13), a14(_a14), a15(_a15) {}
	
	template <typename Buffer>
	void MessagePack(Buffer& pk) const
	{
		pk << a0;
		pk << a1;
		pk << a2;
		pk << a3;
		pk << a4;
		pk << a5;
		pk << a6;
		pk << a7;
		pk << a8;
		pk << a9;
		pk << a10;
		pk << a11;
		pk << a12;
		pk << a13;
		pk << a14;
		pk << a15;
	}

	template <typename Buffer>
	void MessageUnPack(Buffer& pk) const
	{
		pk >> a0;
		pk >> a1;
		pk >> a2;
		pk >> a3;
		pk >> a4;
		pk >> a5;
		pk >> a6;
		pk >> a7;
		pk >> a8;
		pk >> a9;
		pk >> a10;
		pk >> a11;
		pk >> a12;
		pk >> a13;
		pk >> a14;
		pk >> a15;
	}

	int MessageSize() const
	{
		return GET_TYPESIZE_VALUE(a0)
			+ GET_TYPESIZE_VALUE(a1)
			+ GET_TYPESIZE_VALUE(a2)
			+ GET_TYPESIZE_VALUE(a3)
			+ GET_TYPESIZE_VALUE(a4)
			+ GET_TYPESIZE_VALUE(a5)
			+ GET_TYPESIZE_VALUE(a6)
			+ GET_TYPESIZE_VALUE(a7)
			+ GET_TYPESIZE_VALUE(a8)
			+ GET_TYPESIZE_VALUE(a9)
			+ GET_TYPESIZE_VALUE(a10)
			+ GET_TYPESIZE_VALUE(a11)
			+ GET_TYPESIZE_VALUE(a12)
			+ GET_TYPESIZE_VALUE(a13)
			+ GET_TYPESIZE_VALUE(a14)
			+ GET_TYPESIZE_VALUE(a15);
	}

	A0& a0;
	A1& a1;
	A2& a2;
	A3& a3;
	A4& a4;
	A5& a5;
	A6& a6;
	A7& a7;
	A8& a8;
	A9& a9;
	A10& a10;
	A11& a11;
	A12& a12;
	A13& a13;
	A14& a14;
	A15& a15;
};

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12, typename A13, typename A14, typename A15, typename A16>
struct TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16>
{
	TMessageDefine(A0& _a0, A1& _a1, A2& _a2, A3& _a3, A4& _a4, A5& _a5, A6& _a6, A7& _a7, A8& _a8, A9& _a9, A10& _a10, A11& _a11, A12& _a12, A13& _a13, A14& _a14, A15& _a15, A16& _a16) :
	a0(_a0), a1(_a1), a2(_a2), a3(_a3), a4(_a4), a5(_a5), a6(_a6), a7(_a7), a8(_a8), a9(_a9), a10(_a10), a11(_a11), a12(_a12), a13(_a13), a14(_a14), a15(_a15), a16(_a16) {}
	
	template <typename Buffer>
	void MessagePack(Buffer& pk) const
	{
		pk << a0;
		pk << a1;
		pk << a2;
		pk << a3;
		pk << a4;
		pk << a5;
		pk << a6;
		pk << a7;
		pk << a8;
		pk << a9;
		pk << a10;
		pk << a11;
		pk << a12;
		pk << a13;
		pk << a14;
		pk << a15;
		pk << a16;
	}

	template <typename Buffer>
	void MessageUnPack(Buffer& pk) const
	{
		pk >> a0;
		pk >> a1;
		pk >> a2;
		pk >> a3;
		pk >> a4;
		pk >> a5;
		pk >> a6;
		pk >> a7;
		pk >> a8;
		pk >> a9;
		pk >> a10;
		pk >> a11;
		pk >> a12;
		pk >> a13;
		pk >> a14;
		pk >> a15;
		pk >> a16;
	}

	int MessageSize() const
	{
		return GET_TYPESIZE_VALUE(a0)
			+ GET_TYPESIZE_VALUE(a1)
			+ GET_TYPESIZE_VALUE(a2)
			+ GET_TYPESIZE_VALUE(a3)
			+ GET_TYPESIZE_VALUE(a4)
			+ GET_TYPESIZE_VALUE(a5)
			+ GET_TYPESIZE_VALUE(a6)
			+ GET_TYPESIZE_VALUE(a7)
			+ GET_TYPESIZE_VALUE(a8)
			+ GET_TYPESIZE_VALUE(a9)
			+ GET_TYPESIZE_VALUE(a10)
			+ GET_TYPESIZE_VALUE(a11)
			+ GET_TYPESIZE_VALUE(a12)
			+ GET_TYPESIZE_VALUE(a13)
			+ GET_TYPESIZE_VALUE(a14)
			+ GET_TYPESIZE_VALUE(a15)
			+ GET_TYPESIZE_VALUE(a16);
	}

	A0& a0;
	A1& a1;
	A2& a2;
	A3& a3;
	A4& a4;
	A5& a5;
	A6& a6;
	A7& a7;
	A8& a8;
	A9& a9;
	A10& a10;
	A11& a11;
	A12& a12;
	A13& a13;
	A14& a14;
	A15& a15;
	A16& a16;
};

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12, typename A13, typename A14, typename A15, typename A16, typename A17>
struct TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17>
{
	TMessageDefine(A0& _a0, A1& _a1, A2& _a2, A3& _a3, A4& _a4, A5& _a5, A6& _a6, A7& _a7, A8& _a8, A9& _a9, A10& _a10, A11& _a11, A12& _a12, A13& _a13, A14& _a14, A15& _a15, A16& _a16, A17& _a17) :
	a0(_a0), a1(_a1), a2(_a2), a3(_a3), a4(_a4), a5(_a5), a6(_a6), a7(_a7), a8(_a8), a9(_a9), a10(_a10), a11(_a11), a12(_a12), a13(_a13), a14(_a14), a15(_a15), a16(_a16), a17(_a17) {}
	
	template <typename Buffer>
	void MessagePack(Buffer& pk) const
	{
		pk << a0;
		pk << a1;
		pk << a2;
		pk << a3;
		pk << a4;
		pk << a5;
		pk << a6;
		pk << a7;
		pk << a8;
		pk << a9;
		pk << a10;
		pk << a11;
		pk << a12;
		pk << a13;
		pk << a14;
		pk << a15;
		pk << a16;
		pk << a17;
	}

	template <typename Buffer>
	void MessageUnPack(Buffer& pk) const
	{
		pk >> a0;
		pk >> a1;
		pk >> a2;
		pk >> a3;
		pk >> a4;
		pk >> a5;
		pk >> a6;
		pk >> a7;
		pk >> a8;
		pk >> a9;
		pk >> a10;
		pk >> a11;
		pk >> a12;
		pk >> a13;
		pk >> a14;
		pk >> a15;
		pk >> a16;
		pk >> a17;
	}

	int MessageSize() const
	{
		return GET_TYPESIZE_VALUE(a0)
			+ GET_TYPESIZE_VALUE(a1)
			+ GET_TYPESIZE_VALUE(a2)
			+ GET_TYPESIZE_VALUE(a3)
			+ GET_TYPESIZE_VALUE(a4)
			+ GET_TYPESIZE_VALUE(a5)
			+ GET_TYPESIZE_VALUE(a6)
			+ GET_TYPESIZE_VALUE(a7)
			+ GET_TYPESIZE_VALUE(a8)
			+ GET_TYPESIZE_VALUE(a9)
			+ GET_TYPESIZE_VALUE(a10)
			+ GET_TYPESIZE_VALUE(a11)
			+ GET_TYPESIZE_VALUE(a12)
			+ GET_TYPESIZE_VALUE(a13)
			+ GET_TYPESIZE_VALUE(a14)
			+ GET_TYPESIZE_VALUE(a15)
			+ GET_TYPESIZE_VALUE(a16)
			+ GET_TYPESIZE_VALUE(a17);
	}

	A0& a0;
	A1& a1;
	A2& a2;
	A3& a3;
	A4& a4;
	A5& a5;
	A6& a6;
	A7& a7;
	A8& a8;
	A9& a9;
	A10& a10;
	A11& a11;
	A12& a12;
	A13& a13;
	A14& a14;
	A15& a15;
	A16& a16;
	A17& a17;
};

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12, typename A13, typename A14, typename A15, typename A16, typename A17, typename A18>
struct TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18>
{
	TMessageDefine(A0& _a0, A1& _a1, A2& _a2, A3& _a3, A4& _a4, A5& _a5, A6& _a6, A7& _a7, A8& _a8, A9& _a9, A10& _a10, A11& _a11, A12& _a12, A13& _a13, A14& _a14, A15& _a15, A16& _a16, A17& _a17, A18& _a18) :
	a0(_a0), a1(_a1), a2(_a2), a3(_a3), a4(_a4), a5(_a5), a6(_a6), a7(_a7), a8(_a8), a9(_a9), a10(_a10), a11(_a11), a12(_a12), a13(_a13), a14(_a14), a15(_a15), a16(_a16), a17(_a17), a18(_a18) {}
	
	template <typename Buffer>
	void MessagePack(Buffer& pk) const
	{
		pk << a0;
		pk << a1;
		pk << a2;
		pk << a3;
		pk << a4;
		pk << a5;
		pk << a6;
		pk << a7;
		pk << a8;
		pk << a9;
		pk << a10;
		pk << a11;
		pk << a12;
		pk << a13;
		pk << a14;
		pk << a15;
		pk << a16;
		pk << a17;
		pk << a18;
	}

	template <typename Buffer>
	void MessageUnPack(Buffer& pk) const
	{
		pk >> a0;
		pk >> a1;
		pk >> a2;
		pk >> a3;
		pk >> a4;
		pk >> a5;
		pk >> a6;
		pk >> a7;
		pk >> a8;
		pk >> a9;
		pk >> a10;
		pk >> a11;
		pk >> a12;
		pk >> a13;
		pk >> a14;
		pk >> a15;
		pk >> a16;
		pk >> a17;
		pk >> a18;
	}

	int MessageSize() const
	{
		return GET_TYPESIZE_VALUE(a0)
			+ GET_TYPESIZE_VALUE(a1)
			+ GET_TYPESIZE_VALUE(a2)
			+ GET_TYPESIZE_VALUE(a3)
			+ GET_TYPESIZE_VALUE(a4)
			+ GET_TYPESIZE_VALUE(a5)
			+ GET_TYPESIZE_VALUE(a6)
			+ GET_TYPESIZE_VALUE(a7)
			+ GET_TYPESIZE_VALUE(a8)
			+ GET_TYPESIZE_VALUE(a9)
			+ GET_TYPESIZE_VALUE(a10)
			+ GET_TYPESIZE_VALUE(a11)
			+ GET_TYPESIZE_VALUE(a12)
			+ GET_TYPESIZE_VALUE(a13)
			+ GET_TYPESIZE_VALUE(a14)
			+ GET_TYPESIZE_VALUE(a15)
			+ GET_TYPESIZE_VALUE(a16)
			+ GET_TYPESIZE_VALUE(a17)
			+ GET_TYPESIZE_VALUE(a18);
	}

	A0& a0;
	A1& a1;
	A2& a2;
	A3& a3;
	A4& a4;
	A5& a5;
	A6& a6;
	A7& a7;
	A8& a8;
	A9& a9;
	A10& a10;
	A11& a11;
	A12& a12;
	A13& a13;
	A14& a14;
	A15& a15;
	A16& a16;
	A17& a17;
	A18& a18;
};

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12, typename A13, typename A14, typename A15, typename A16, typename A17, typename A18, typename A19>
struct TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19>
{
	TMessageDefine(A0& _a0, A1& _a1, A2& _a2, A3& _a3, A4& _a4, A5& _a5, A6& _a6, A7& _a7, A8& _a8, A9& _a9, A10& _a10, A11& _a11, A12& _a12, A13& _a13, A14& _a14, A15& _a15, A16& _a16, A17& _a17, A18& _a18, A19& _a19) :
	a0(_a0), a1(_a1), a2(_a2), a3(_a3), a4(_a4), a5(_a5), a6(_a6), a7(_a7), a8(_a8), a9(_a9), a10(_a10), a11(_a11), a12(_a12), a13(_a13), a14(_a14), a15(_a15), a16(_a16), a17(_a17), a18(_a18), a19(_a19) {}
	
	template <typename Buffer>
	void MessagePack(Buffer& pk) const
	{
		pk << a0;
		pk << a1;
		pk << a2;
		pk << a3;
		pk << a4;
		pk << a5;
		pk << a6;
		pk << a7;
		pk << a8;
		pk << a9;
		pk << a10;
		pk << a11;
		pk << a12;
		pk << a13;
		pk << a14;
		pk << a15;
		pk << a16;
		pk << a17;
		pk << a18;
		pk << a19;
	}

	template <typename Buffer>
	void MessageUnPack(Buffer& pk) const
	{
		pk >> a0;
		pk >> a1;
		pk >> a2;
		pk >> a3;
		pk >> a4;
		pk >> a5;
		pk >> a6;
		pk >> a7;
		pk >> a8;
		pk >> a9;
		pk >> a10;
		pk >> a11;
		pk >> a12;
		pk >> a13;
		pk >> a14;
		pk >> a15;
		pk >> a16;
		pk >> a17;
		pk >> a18;
		pk >> a19;
	}

	int MessageSize() const
	{
		return GET_TYPESIZE_VALUE(a0)
			+ GET_TYPESIZE_VALUE(a1)
			+ GET_TYPESIZE_VALUE(a2)
			+ GET_TYPESIZE_VALUE(a3)
			+ GET_TYPESIZE_VALUE(a4)
			+ GET_TYPESIZE_VALUE(a5)
			+ GET_TYPESIZE_VALUE(a6)
			+ GET_TYPESIZE_VALUE(a7)
			+ GET_TYPESIZE_VALUE(a8)
			+ GET_TYPESIZE_VALUE(a9)
			+ GET_TYPESIZE_VALUE(a10)
			+ GET_TYPESIZE_VALUE(a11)
			+ GET_TYPESIZE_VALUE(a12)
			+ GET_TYPESIZE_VALUE(a13)
			+ GET_TYPESIZE_VALUE(a14)
			+ GET_TYPESIZE_VALUE(a15)
			+ GET_TYPESIZE_VALUE(a16)
			+ GET_TYPESIZE_VALUE(a17)
			+ GET_TYPESIZE_VALUE(a18)
			+ GET_TYPESIZE_VALUE(a19);
	}

	A0& a0;
	A1& a1;
	A2& a2;
	A3& a3;
	A4& a4;
	A5& a5;
	A6& a6;
	A7& a7;
	A8& a8;
	A9& a9;
	A10& a10;
	A11& a11;
	A12& a12;
	A13& a13;
	A14& a14;
	A15& a15;
	A16& a16;
	A17& a17;
	A18& a18;
	A19& a19;
};

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12, typename A13, typename A14, typename A15, typename A16, typename A17, typename A18, typename A19, typename A20>
struct TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20>
{
	TMessageDefine(A0& _a0, A1& _a1, A2& _a2, A3& _a3, A4& _a4, A5& _a5, A6& _a6, A7& _a7, A8& _a8, A9& _a9, A10& _a10, A11& _a11, A12& _a12, A13& _a13, A14& _a14, A15& _a15, A16& _a16, A17& _a17, A18& _a18, A19& _a19, A20& _a20) :
	a0(_a0), a1(_a1), a2(_a2), a3(_a3), a4(_a4), a5(_a5), a6(_a6), a7(_a7), a8(_a8), a9(_a9), a10(_a10), a11(_a11), a12(_a12), a13(_a13), a14(_a14), a15(_a15), a16(_a16), a17(_a17), a18(_a18), a19(_a19), a20(_a20) {}
	
	template <typename Buffer>
	void MessagePack(Buffer& pk) const
	{
		pk << a0;
		pk << a1;
		pk << a2;
		pk << a3;
		pk << a4;
		pk << a5;
		pk << a6;
		pk << a7;
		pk << a8;
		pk << a9;
		pk << a10;
		pk << a11;
		pk << a12;
		pk << a13;
		pk << a14;
		pk << a15;
		pk << a16;
		pk << a17;
		pk << a18;
		pk << a19;
		pk << a20;
	}

	template <typename Buffer>
	void MessageUnPack(Buffer& pk) const
	{
		pk >> a0;
		pk >> a1;
		pk >> a2;
		pk >> a3;
		pk >> a4;
		pk >> a5;
		pk >> a6;
		pk >> a7;
		pk >> a8;
		pk >> a9;
		pk >> a10;
		pk >> a11;
		pk >> a12;
		pk >> a13;
		pk >> a14;
		pk >> a15;
		pk >> a16;
		pk >> a17;
		pk >> a18;
		pk >> a19;
		pk >> a20;
	}

	int MessageSize() const
	{
		return GET_TYPESIZE_VALUE(a0)
			+ GET_TYPESIZE_VALUE(a1)
			+ GET_TYPESIZE_VALUE(a2)
			+ GET_TYPESIZE_VALUE(a3)
			+ GET_TYPESIZE_VALUE(a4)
			+ GET_TYPESIZE_VALUE(a5)
			+ GET_TYPESIZE_VALUE(a6)
			+ GET_TYPESIZE_VALUE(a7)
			+ GET_TYPESIZE_VALUE(a8)
			+ GET_TYPESIZE_VALUE(a9)
			+ GET_TYPESIZE_VALUE(a10)
			+ GET_TYPESIZE_VALUE(a11)
			+ GET_TYPESIZE_VALUE(a12)
			+ GET_TYPESIZE_VALUE(a13)
			+ GET_TYPESIZE_VALUE(a14)
			+ GET_TYPESIZE_VALUE(a15)
			+ GET_TYPESIZE_VALUE(a16)
			+ GET_TYPESIZE_VALUE(a17)
			+ GET_TYPESIZE_VALUE(a18)
			+ GET_TYPESIZE_VALUE(a19)
			+ GET_TYPESIZE_VALUE(a20);
	}

	A0& a0;
	A1& a1;
	A2& a2;
	A3& a3;
	A4& a4;
	A5& a5;
	A6& a6;
	A7& a7;
	A8& a8;
	A9& a9;
	A10& a10;
	A11& a11;
	A12& a12;
	A13& a13;
	A14& a14;
	A15& a15;
	A16& a16;
	A17& a17;
	A18& a18;
	A19& a19;
	A20& a20;
};

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12, typename A13, typename A14, typename A15, typename A16, typename A17, typename A18, typename A19, typename A20, typename A21>
struct TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21>
{
	TMessageDefine(A0& _a0, A1& _a1, A2& _a2, A3& _a3, A4& _a4, A5& _a5, A6& _a6, A7& _a7, A8& _a8, A9& _a9, A10& _a10, A11& _a11, A12& _a12, A13& _a13, A14& _a14, A15& _a15, A16& _a16, A17& _a17, A18& _a18, A19& _a19, A20& _a20, A21& _a21) :
	a0(_a0), a1(_a1), a2(_a2), a3(_a3), a4(_a4), a5(_a5), a6(_a6), a7(_a7), a8(_a8), a9(_a9), a10(_a10), a11(_a11), a12(_a12), a13(_a13), a14(_a14), a15(_a15), a16(_a16), a17(_a17), a18(_a18), a19(_a19), a20(_a20), a21(_a21) {}
	
	template <typename Buffer>
	void MessagePack(Buffer& pk) const
	{
		pk << a0;
		pk << a1;
		pk << a2;
		pk << a3;
		pk << a4;
		pk << a5;
		pk << a6;
		pk << a7;
		pk << a8;
		pk << a9;
		pk << a10;
		pk << a11;
		pk << a12;
		pk << a13;
		pk << a14;
		pk << a15;
		pk << a16;
		pk << a17;
		pk << a18;
		pk << a19;
		pk << a20;
		pk << a21;
	}

	template <typename Buffer>
	void MessageUnPack(Buffer& pk) const
	{
		pk >> a0;
		pk >> a1;
		pk >> a2;
		pk >> a3;
		pk >> a4;
		pk >> a5;
		pk >> a6;
		pk >> a7;
		pk >> a8;
		pk >> a9;
		pk >> a10;
		pk >> a11;
		pk >> a12;
		pk >> a13;
		pk >> a14;
		pk >> a15;
		pk >> a16;
		pk >> a17;
		pk >> a18;
		pk >> a19;
		pk >> a20;
		pk >> a21;
	}

	int MessageSize() const
	{
		return GET_TYPESIZE_VALUE(a0)
			+ GET_TYPESIZE_VALUE(a1)
			+ GET_TYPESIZE_VALUE(a2)
			+ GET_TYPESIZE_VALUE(a3)
			+ GET_TYPESIZE_VALUE(a4)
			+ GET_TYPESIZE_VALUE(a5)
			+ GET_TYPESIZE_VALUE(a6)
			+ GET_TYPESIZE_VALUE(a7)
			+ GET_TYPESIZE_VALUE(a8)
			+ GET_TYPESIZE_VALUE(a9)
			+ GET_TYPESIZE_VALUE(a10)
			+ GET_TYPESIZE_VALUE(a11)
			+ GET_TYPESIZE_VALUE(a12)
			+ GET_TYPESIZE_VALUE(a13)
			+ GET_TYPESIZE_VALUE(a14)
			+ GET_TYPESIZE_VALUE(a15)
			+ GET_TYPESIZE_VALUE(a16)
			+ GET_TYPESIZE_VALUE(a17)
			+ GET_TYPESIZE_VALUE(a18)
			+ GET_TYPESIZE_VALUE(a19)
			+ GET_TYPESIZE_VALUE(a20)
			+ GET_TYPESIZE_VALUE(a21);
	}

	A0& a0;
	A1& a1;
	A2& a2;
	A3& a3;
	A4& a4;
	A5& a5;
	A6& a6;
	A7& a7;
	A8& a8;
	A9& a9;
	A10& a10;
	A11& a11;
	A12& a12;
	A13& a13;
	A14& a14;
	A15& a15;
	A16& a16;
	A17& a17;
	A18& a18;
	A19& a19;
	A20& a20;
	A21& a21;
};

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12, typename A13, typename A14, typename A15, typename A16, typename A17, typename A18, typename A19, typename A20, typename A21, typename A22>
struct TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22>
{
	TMessageDefine(A0& _a0, A1& _a1, A2& _a2, A3& _a3, A4& _a4, A5& _a5, A6& _a6, A7& _a7, A8& _a8, A9& _a9, A10& _a10, A11& _a11, A12& _a12, A13& _a13, A14& _a14, A15& _a15, A16& _a16, A17& _a17, A18& _a18, A19& _a19, A20& _a20, A21& _a21, A22& _a22) :
	a0(_a0), a1(_a1), a2(_a2), a3(_a3), a4(_a4), a5(_a5), a6(_a6), a7(_a7), a8(_a8), a9(_a9), a10(_a10), a11(_a11), a12(_a12), a13(_a13), a14(_a14), a15(_a15), a16(_a16), a17(_a17), a18(_a18), a19(_a19), a20(_a20), a21(_a21), a22(_a22) {}
	
	template <typename Buffer>
	void MessagePack(Buffer& pk) const
	{
		pk << a0;
		pk << a1;
		pk << a2;
		pk << a3;
		pk << a4;
		pk << a5;
		pk << a6;
		pk << a7;
		pk << a8;
		pk << a9;
		pk << a10;
		pk << a11;
		pk << a12;
		pk << a13;
		pk << a14;
		pk << a15;
		pk << a16;
		pk << a17;
		pk << a18;
		pk << a19;
		pk << a20;
		pk << a21;
		pk << a22;
	}

	template <typename Buffer>
	void MessageUnPack(Buffer& pk) const
	{
		pk >> a0;
		pk >> a1;
		pk >> a2;
		pk >> a3;
		pk >> a4;
		pk >> a5;
		pk >> a6;
		pk >> a7;
		pk >> a8;
		pk >> a9;
		pk >> a10;
		pk >> a11;
		pk >> a12;
		pk >> a13;
		pk >> a14;
		pk >> a15;
		pk >> a16;
		pk >> a17;
		pk >> a18;
		pk >> a19;
		pk >> a20;
		pk >> a21;
		pk >> a22;
	}

	int MessageSize() const
	{
		return GET_TYPESIZE_VALUE(a0)
			+ GET_TYPESIZE_VALUE(a1)
			+ GET_TYPESIZE_VALUE(a2)
			+ GET_TYPESIZE_VALUE(a3)
			+ GET_TYPESIZE_VALUE(a4)
			+ GET_TYPESIZE_VALUE(a5)
			+ GET_TYPESIZE_VALUE(a6)
			+ GET_TYPESIZE_VALUE(a7)
			+ GET_TYPESIZE_VALUE(a8)
			+ GET_TYPESIZE_VALUE(a9)
			+ GET_TYPESIZE_VALUE(a10)
			+ GET_TYPESIZE_VALUE(a11)
			+ GET_TYPESIZE_VALUE(a12)
			+ GET_TYPESIZE_VALUE(a13)
			+ GET_TYPESIZE_VALUE(a14)
			+ GET_TYPESIZE_VALUE(a15)
			+ GET_TYPESIZE_VALUE(a16)
			+ GET_TYPESIZE_VALUE(a17)
			+ GET_TYPESIZE_VALUE(a18)
			+ GET_TYPESIZE_VALUE(a19)
			+ GET_TYPESIZE_VALUE(a20)
			+ GET_TYPESIZE_VALUE(a21)
			+ GET_TYPESIZE_VALUE(a22);
	}

	A0& a0;
	A1& a1;
	A2& a2;
	A3& a3;
	A4& a4;
	A5& a5;
	A6& a6;
	A7& a7;
	A8& a8;
	A9& a9;
	A10& a10;
	A11& a11;
	A12& a12;
	A13& a13;
	A14& a14;
	A15& a15;
	A16& a16;
	A17& a17;
	A18& a18;
	A19& a19;
	A20& a20;
	A21& a21;
	A22& a22;
};

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12, typename A13, typename A14, typename A15, typename A16, typename A17, typename A18, typename A19, typename A20, typename A21, typename A22, typename A23>
struct TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23>
{
	TMessageDefine(A0& _a0, A1& _a1, A2& _a2, A3& _a3, A4& _a4, A5& _a5, A6& _a6, A7& _a7, A8& _a8, A9& _a9, A10& _a10, A11& _a11, A12& _a12, A13& _a13, A14& _a14, A15& _a15, A16& _a16, A17& _a17, A18& _a18, A19& _a19, A20& _a20, A21& _a21, A22& _a22, A23& _a23) :
	a0(_a0), a1(_a1), a2(_a2), a3(_a3), a4(_a4), a5(_a5), a6(_a6), a7(_a7), a8(_a8), a9(_a9), a10(_a10), a11(_a11), a12(_a12), a13(_a13), a14(_a14), a15(_a15), a16(_a16), a17(_a17), a18(_a18), a19(_a19), a20(_a20), a21(_a21), a22(_a22), a23(_a23) {}
	
	template <typename Buffer>
	void MessagePack(Buffer& pk) const
	{
		pk << a0;
		pk << a1;
		pk << a2;
		pk << a3;
		pk << a4;
		pk << a5;
		pk << a6;
		pk << a7;
		pk << a8;
		pk << a9;
		pk << a10;
		pk << a11;
		pk << a12;
		pk << a13;
		pk << a14;
		pk << a15;
		pk << a16;
		pk << a17;
		pk << a18;
		pk << a19;
		pk << a20;
		pk << a21;
		pk << a22;
		pk << a23;
	}

	template <typename Buffer>
	void MessageUnPack(Buffer& pk) const
	{
		pk >> a0;
		pk >> a1;
		pk >> a2;
		pk >> a3;
		pk >> a4;
		pk >> a5;
		pk >> a6;
		pk >> a7;
		pk >> a8;
		pk >> a9;
		pk >> a10;
		pk >> a11;
		pk >> a12;
		pk >> a13;
		pk >> a14;
		pk >> a15;
		pk >> a16;
		pk >> a17;
		pk >> a18;
		pk >> a19;
		pk >> a20;
		pk >> a21;
		pk >> a22;
		pk >> a23;
	}

	int MessageSize() const
	{
		return GET_TYPESIZE_VALUE(a0)
			+ GET_TYPESIZE_VALUE(a1)
			+ GET_TYPESIZE_VALUE(a2)
			+ GET_TYPESIZE_VALUE(a3)
			+ GET_TYPESIZE_VALUE(a4)
			+ GET_TYPESIZE_VALUE(a5)
			+ GET_TYPESIZE_VALUE(a6)
			+ GET_TYPESIZE_VALUE(a7)
			+ GET_TYPESIZE_VALUE(a8)
			+ GET_TYPESIZE_VALUE(a9)
			+ GET_TYPESIZE_VALUE(a10)
			+ GET_TYPESIZE_VALUE(a11)
			+ GET_TYPESIZE_VALUE(a12)
			+ GET_TYPESIZE_VALUE(a13)
			+ GET_TYPESIZE_VALUE(a14)
			+ GET_TYPESIZE_VALUE(a15)
			+ GET_TYPESIZE_VALUE(a16)
			+ GET_TYPESIZE_VALUE(a17)
			+ GET_TYPESIZE_VALUE(a18)
			+ GET_TYPESIZE_VALUE(a19)
			+ GET_TYPESIZE_VALUE(a20)
			+ GET_TYPESIZE_VALUE(a21)
			+ GET_TYPESIZE_VALUE(a22)
			+ GET_TYPESIZE_VALUE(a23);
	}

	A0& a0;
	A1& a1;
	A2& a2;
	A3& a3;
	A4& a4;
	A5& a5;
	A6& a6;
	A7& a7;
	A8& a8;
	A9& a9;
	A10& a10;
	A11& a11;
	A12& a12;
	A13& a13;
	A14& a14;
	A15& a15;
	A16& a16;
	A17& a17;
	A18& a18;
	A19& a19;
	A20& a20;
	A21& a21;
	A22& a22;
	A23& a23;
};

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12, typename A13, typename A14, typename A15, typename A16, typename A17, typename A18, typename A19, typename A20, typename A21, typename A22, typename A23, typename A24>
struct TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24>
{
	TMessageDefine(A0& _a0, A1& _a1, A2& _a2, A3& _a3, A4& _a4, A5& _a5, A6& _a6, A7& _a7, A8& _a8, A9& _a9, A10& _a10, A11& _a11, A12& _a12, A13& _a13, A14& _a14, A15& _a15, A16& _a16, A17& _a17, A18& _a18, A19& _a19, A20& _a20, A21& _a21, A22& _a22, A23& _a23, A24& _a24) :
	a0(_a0), a1(_a1), a2(_a2), a3(_a3), a4(_a4), a5(_a5), a6(_a6), a7(_a7), a8(_a8), a9(_a9), a10(_a10), a11(_a11), a12(_a12), a13(_a13), a14(_a14), a15(_a15), a16(_a16), a17(_a17), a18(_a18), a19(_a19), a20(_a20), a21(_a21), a22(_a22), a23(_a23), a24(_a24) {}
	
	template <typename Buffer>
	void MessagePack(Buffer& pk) const
	{
		pk << a0;
		pk << a1;
		pk << a2;
		pk << a3;
		pk << a4;
		pk << a5;
		pk << a6;
		pk << a7;
		pk << a8;
		pk << a9;
		pk << a10;
		pk << a11;
		pk << a12;
		pk << a13;
		pk << a14;
		pk << a15;
		pk << a16;
		pk << a17;
		pk << a18;
		pk << a19;
		pk << a20;
		pk << a21;
		pk << a22;
		pk << a23;
		pk << a24;
	}

	template <typename Buffer>
	void MessageUnPack(Buffer& pk) const
	{
		pk >> a0;
		pk >> a1;
		pk >> a2;
		pk >> a3;
		pk >> a4;
		pk >> a5;
		pk >> a6;
		pk >> a7;
		pk >> a8;
		pk >> a9;
		pk >> a10;
		pk >> a11;
		pk >> a12;
		pk >> a13;
		pk >> a14;
		pk >> a15;
		pk >> a16;
		pk >> a17;
		pk >> a18;
		pk >> a19;
		pk >> a20;
		pk >> a21;
		pk >> a22;
		pk >> a23;
		pk >> a24;
	}

	int MessageSize() const
	{
		return GET_TYPESIZE_VALUE(a0)
			+ GET_TYPESIZE_VALUE(a1)
			+ GET_TYPESIZE_VALUE(a2)
			+ GET_TYPESIZE_VALUE(a3)
			+ GET_TYPESIZE_VALUE(a4)
			+ GET_TYPESIZE_VALUE(a5)
			+ GET_TYPESIZE_VALUE(a6)
			+ GET_TYPESIZE_VALUE(a7)
			+ GET_TYPESIZE_VALUE(a8)
			+ GET_TYPESIZE_VALUE(a9)
			+ GET_TYPESIZE_VALUE(a10)
			+ GET_TYPESIZE_VALUE(a11)
			+ GET_TYPESIZE_VALUE(a12)
			+ GET_TYPESIZE_VALUE(a13)
			+ GET_TYPESIZE_VALUE(a14)
			+ GET_TYPESIZE_VALUE(a15)
			+ GET_TYPESIZE_VALUE(a16)
			+ GET_TYPESIZE_VALUE(a17)
			+ GET_TYPESIZE_VALUE(a18)
			+ GET_TYPESIZE_VALUE(a19)
			+ GET_TYPESIZE_VALUE(a20)
			+ GET_TYPESIZE_VALUE(a21)
			+ GET_TYPESIZE_VALUE(a22)
			+ GET_TYPESIZE_VALUE(a23)
			+ GET_TYPESIZE_VALUE(a24);
	}

	A0& a0;
	A1& a1;
	A2& a2;
	A3& a3;
	A4& a4;
	A5& a5;
	A6& a6;
	A7& a7;
	A8& a8;
	A9& a9;
	A10& a10;
	A11& a11;
	A12& a12;
	A13& a13;
	A14& a14;
	A15& a15;
	A16& a16;
	A17& a17;
	A18& a18;
	A19& a19;
	A20& a20;
	A21& a21;
	A22& a22;
	A23& a23;
	A24& a24;
};

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12, typename A13, typename A14, typename A15, typename A16, typename A17, typename A18, typename A19, typename A20, typename A21, typename A22, typename A23, typename A24, typename A25>
struct TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25>
{
	TMessageDefine(A0& _a0, A1& _a1, A2& _a2, A3& _a3, A4& _a4, A5& _a5, A6& _a6, A7& _a7, A8& _a8, A9& _a9, A10& _a10, A11& _a11, A12& _a12, A13& _a13, A14& _a14, A15& _a15, A16& _a16, A17& _a17, A18& _a18, A19& _a19, A20& _a20, A21& _a21, A22& _a22, A23& _a23, A24& _a24, A25& _a25) :
	a0(_a0), a1(_a1), a2(_a2), a3(_a3), a4(_a4), a5(_a5), a6(_a6), a7(_a7), a8(_a8), a9(_a9), a10(_a10), a11(_a11), a12(_a12), a13(_a13), a14(_a14), a15(_a15), a16(_a16), a17(_a17), a18(_a18), a19(_a19), a20(_a20), a21(_a21), a22(_a22), a23(_a23), a24(_a24), a25(_a25) {}
	
	template <typename Buffer>
	void MessagePack(Buffer& pk) const
	{
		pk << a0;
		pk << a1;
		pk << a2;
		pk << a3;
		pk << a4;
		pk << a5;
		pk << a6;
		pk << a7;
		pk << a8;
		pk << a9;
		pk << a10;
		pk << a11;
		pk << a12;
		pk << a13;
		pk << a14;
		pk << a15;
		pk << a16;
		pk << a17;
		pk << a18;
		pk << a19;
		pk << a20;
		pk << a21;
		pk << a22;
		pk << a23;
		pk << a24;
		pk << a25;
	}

	template <typename Buffer>
	void MessageUnPack(Buffer& pk) const
	{
		pk >> a0;
		pk >> a1;
		pk >> a2;
		pk >> a3;
		pk >> a4;
		pk >> a5;
		pk >> a6;
		pk >> a7;
		pk >> a8;
		pk >> a9;
		pk >> a10;
		pk >> a11;
		pk >> a12;
		pk >> a13;
		pk >> a14;
		pk >> a15;
		pk >> a16;
		pk >> a17;
		pk >> a18;
		pk >> a19;
		pk >> a20;
		pk >> a21;
		pk >> a22;
		pk >> a23;
		pk >> a24;
		pk >> a25;
	}

	int MessageSize() const
	{
		return GET_TYPESIZE_VALUE(a0)
			+ GET_TYPESIZE_VALUE(a1)
			+ GET_TYPESIZE_VALUE(a2)
			+ GET_TYPESIZE_VALUE(a3)
			+ GET_TYPESIZE_VALUE(a4)
			+ GET_TYPESIZE_VALUE(a5)
			+ GET_TYPESIZE_VALUE(a6)
			+ GET_TYPESIZE_VALUE(a7)
			+ GET_TYPESIZE_VALUE(a8)
			+ GET_TYPESIZE_VALUE(a9)
			+ GET_TYPESIZE_VALUE(a10)
			+ GET_TYPESIZE_VALUE(a11)
			+ GET_TYPESIZE_VALUE(a12)
			+ GET_TYPESIZE_VALUE(a13)
			+ GET_TYPESIZE_VALUE(a14)
			+ GET_TYPESIZE_VALUE(a15)
			+ GET_TYPESIZE_VALUE(a16)
			+ GET_TYPESIZE_VALUE(a17)
			+ GET_TYPESIZE_VALUE(a18)
			+ GET_TYPESIZE_VALUE(a19)
			+ GET_TYPESIZE_VALUE(a20)
			+ GET_TYPESIZE_VALUE(a21)
			+ GET_TYPESIZE_VALUE(a22)
			+ GET_TYPESIZE_VALUE(a23)
			+ GET_TYPESIZE_VALUE(a24)
			+ GET_TYPESIZE_VALUE(a25);
	}

	A0& a0;
	A1& a1;
	A2& a2;
	A3& a3;
	A4& a4;
	A5& a5;
	A6& a6;
	A7& a7;
	A8& a8;
	A9& a9;
	A10& a10;
	A11& a11;
	A12& a12;
	A13& a13;
	A14& a14;
	A15& a15;
	A16& a16;
	A17& a17;
	A18& a18;
	A19& a19;
	A20& a20;
	A21& a21;
	A22& a22;
	A23& a23;
	A24& a24;
	A25& a25;
};

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12, typename A13, typename A14, typename A15, typename A16, typename A17, typename A18, typename A19, typename A20, typename A21, typename A22, typename A23, typename A24, typename A25, typename A26>
struct TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26>
{
	TMessageDefine(A0& _a0, A1& _a1, A2& _a2, A3& _a3, A4& _a4, A5& _a5, A6& _a6, A7& _a7, A8& _a8, A9& _a9, A10& _a10, A11& _a11, A12& _a12, A13& _a13, A14& _a14, A15& _a15, A16& _a16, A17& _a17, A18& _a18, A19& _a19, A20& _a20, A21& _a21, A22& _a22, A23& _a23, A24& _a24, A25& _a25, A26& _a26) :
	a0(_a0), a1(_a1), a2(_a2), a3(_a3), a4(_a4), a5(_a5), a6(_a6), a7(_a7), a8(_a8), a9(_a9), a10(_a10), a11(_a11), a12(_a12), a13(_a13), a14(_a14), a15(_a15), a16(_a16), a17(_a17), a18(_a18), a19(_a19), a20(_a20), a21(_a21), a22(_a22), a23(_a23), a24(_a24), a25(_a25), a26(_a26) {}
	
	template <typename Buffer>
	void MessagePack(Buffer& pk) const
	{
		pk << a0;
		pk << a1;
		pk << a2;
		pk << a3;
		pk << a4;
		pk << a5;
		pk << a6;
		pk << a7;
		pk << a8;
		pk << a9;
		pk << a10;
		pk << a11;
		pk << a12;
		pk << a13;
		pk << a14;
		pk << a15;
		pk << a16;
		pk << a17;
		pk << a18;
		pk << a19;
		pk << a20;
		pk << a21;
		pk << a22;
		pk << a23;
		pk << a24;
		pk << a25;
		pk << a26;
	}

	template <typename Buffer>
	void MessageUnPack(Buffer& pk) const
	{
		pk >> a0;
		pk >> a1;
		pk >> a2;
		pk >> a3;
		pk >> a4;
		pk >> a5;
		pk >> a6;
		pk >> a7;
		pk >> a8;
		pk >> a9;
		pk >> a10;
		pk >> a11;
		pk >> a12;
		pk >> a13;
		pk >> a14;
		pk >> a15;
		pk >> a16;
		pk >> a17;
		pk >> a18;
		pk >> a19;
		pk >> a20;
		pk >> a21;
		pk >> a22;
		pk >> a23;
		pk >> a24;
		pk >> a25;
		pk >> a26;
	}

	int MessageSize() const
	{
		return GET_TYPESIZE_VALUE(a0)
			+ GET_TYPESIZE_VALUE(a1)
			+ GET_TYPESIZE_VALUE(a2)
			+ GET_TYPESIZE_VALUE(a3)
			+ GET_TYPESIZE_VALUE(a4)
			+ GET_TYPESIZE_VALUE(a5)
			+ GET_TYPESIZE_VALUE(a6)
			+ GET_TYPESIZE_VALUE(a7)
			+ GET_TYPESIZE_VALUE(a8)
			+ GET_TYPESIZE_VALUE(a9)
			+ GET_TYPESIZE_VALUE(a10)
			+ GET_TYPESIZE_VALUE(a11)
			+ GET_TYPESIZE_VALUE(a12)
			+ GET_TYPESIZE_VALUE(a13)
			+ GET_TYPESIZE_VALUE(a14)
			+ GET_TYPESIZE_VALUE(a15)
			+ GET_TYPESIZE_VALUE(a16)
			+ GET_TYPESIZE_VALUE(a17)
			+ GET_TYPESIZE_VALUE(a18)
			+ GET_TYPESIZE_VALUE(a19)
			+ GET_TYPESIZE_VALUE(a20)
			+ GET_TYPESIZE_VALUE(a21)
			+ GET_TYPESIZE_VALUE(a22)
			+ GET_TYPESIZE_VALUE(a23)
			+ GET_TYPESIZE_VALUE(a24)
			+ GET_TYPESIZE_VALUE(a25)
			+ GET_TYPESIZE_VALUE(a26);
	}

	A0& a0;
	A1& a1;
	A2& a2;
	A3& a3;
	A4& a4;
	A5& a5;
	A6& a6;
	A7& a7;
	A8& a8;
	A9& a9;
	A10& a10;
	A11& a11;
	A12& a12;
	A13& a13;
	A14& a14;
	A15& a15;
	A16& a16;
	A17& a17;
	A18& a18;
	A19& a19;
	A20& a20;
	A21& a21;
	A22& a22;
	A23& a23;
	A24& a24;
	A25& a25;
	A26& a26;
};

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12, typename A13, typename A14, typename A15, typename A16, typename A17, typename A18, typename A19, typename A20, typename A21, typename A22, typename A23, typename A24, typename A25, typename A26, typename A27>
struct TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27>
{
	TMessageDefine(A0& _a0, A1& _a1, A2& _a2, A3& _a3, A4& _a4, A5& _a5, A6& _a6, A7& _a7, A8& _a8, A9& _a9, A10& _a10, A11& _a11, A12& _a12, A13& _a13, A14& _a14, A15& _a15, A16& _a16, A17& _a17, A18& _a18, A19& _a19, A20& _a20, A21& _a21, A22& _a22, A23& _a23, A24& _a24, A25& _a25, A26& _a26, A27& _a27) :
	a0(_a0), a1(_a1), a2(_a2), a3(_a3), a4(_a4), a5(_a5), a6(_a6), a7(_a7), a8(_a8), a9(_a9), a10(_a10), a11(_a11), a12(_a12), a13(_a13), a14(_a14), a15(_a15), a16(_a16), a17(_a17), a18(_a18), a19(_a19), a20(_a20), a21(_a21), a22(_a22), a23(_a23), a24(_a24), a25(_a25), a26(_a26), a27(_a27) {}
	
	template <typename Buffer>
	void MessagePack(Buffer& pk) const
	{
		pk << a0;
		pk << a1;
		pk << a2;
		pk << a3;
		pk << a4;
		pk << a5;
		pk << a6;
		pk << a7;
		pk << a8;
		pk << a9;
		pk << a10;
		pk << a11;
		pk << a12;
		pk << a13;
		pk << a14;
		pk << a15;
		pk << a16;
		pk << a17;
		pk << a18;
		pk << a19;
		pk << a20;
		pk << a21;
		pk << a22;
		pk << a23;
		pk << a24;
		pk << a25;
		pk << a26;
		pk << a27;
	}

	template <typename Buffer>
	void MessageUnPack(Buffer& pk) const
	{
		pk >> a0;
		pk >> a1;
		pk >> a2;
		pk >> a3;
		pk >> a4;
		pk >> a5;
		pk >> a6;
		pk >> a7;
		pk >> a8;
		pk >> a9;
		pk >> a10;
		pk >> a11;
		pk >> a12;
		pk >> a13;
		pk >> a14;
		pk >> a15;
		pk >> a16;
		pk >> a17;
		pk >> a18;
		pk >> a19;
		pk >> a20;
		pk >> a21;
		pk >> a22;
		pk >> a23;
		pk >> a24;
		pk >> a25;
		pk >> a26;
		pk >> a27;
	}

	int MessageSize() const
	{
		return GET_TYPESIZE_VALUE(a0)
			+ GET_TYPESIZE_VALUE(a1)
			+ GET_TYPESIZE_VALUE(a2)
			+ GET_TYPESIZE_VALUE(a3)
			+ GET_TYPESIZE_VALUE(a4)
			+ GET_TYPESIZE_VALUE(a5)
			+ GET_TYPESIZE_VALUE(a6)
			+ GET_TYPESIZE_VALUE(a7)
			+ GET_TYPESIZE_VALUE(a8)
			+ GET_TYPESIZE_VALUE(a9)
			+ GET_TYPESIZE_VALUE(a10)
			+ GET_TYPESIZE_VALUE(a11)
			+ GET_TYPESIZE_VALUE(a12)
			+ GET_TYPESIZE_VALUE(a13)
			+ GET_TYPESIZE_VALUE(a14)
			+ GET_TYPESIZE_VALUE(a15)
			+ GET_TYPESIZE_VALUE(a16)
			+ GET_TYPESIZE_VALUE(a17)
			+ GET_TYPESIZE_VALUE(a18)
			+ GET_TYPESIZE_VALUE(a19)
			+ GET_TYPESIZE_VALUE(a20)
			+ GET_TYPESIZE_VALUE(a21)
			+ GET_TYPESIZE_VALUE(a22)
			+ GET_TYPESIZE_VALUE(a23)
			+ GET_TYPESIZE_VALUE(a24)
			+ GET_TYPESIZE_VALUE(a25)
			+ GET_TYPESIZE_VALUE(a26)
			+ GET_TYPESIZE_VALUE(a27);
	}

	A0& a0;
	A1& a1;
	A2& a2;
	A3& a3;
	A4& a4;
	A5& a5;
	A6& a6;
	A7& a7;
	A8& a8;
	A9& a9;
	A10& a10;
	A11& a11;
	A12& a12;
	A13& a13;
	A14& a14;
	A15& a15;
	A16& a16;
	A17& a17;
	A18& a18;
	A19& a19;
	A20& a20;
	A21& a21;
	A22& a22;
	A23& a23;
	A24& a24;
	A25& a25;
	A26& a26;
	A27& a27;
};

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12, typename A13, typename A14, typename A15, typename A16, typename A17, typename A18, typename A19, typename A20, typename A21, typename A22, typename A23, typename A24, typename A25, typename A26, typename A27, typename A28>
struct TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27, A28>
{
	TMessageDefine(A0& _a0, A1& _a1, A2& _a2, A3& _a3, A4& _a4, A5& _a5, A6& _a6, A7& _a7, A8& _a8, A9& _a9, A10& _a10, A11& _a11, A12& _a12, A13& _a13, A14& _a14, A15& _a15, A16& _a16, A17& _a17, A18& _a18, A19& _a19, A20& _a20, A21& _a21, A22& _a22, A23& _a23, A24& _a24, A25& _a25, A26& _a26, A27& _a27, A28& _a28) :
	a0(_a0), a1(_a1), a2(_a2), a3(_a3), a4(_a4), a5(_a5), a6(_a6), a7(_a7), a8(_a8), a9(_a9), a10(_a10), a11(_a11), a12(_a12), a13(_a13), a14(_a14), a15(_a15), a16(_a16), a17(_a17), a18(_a18), a19(_a19), a20(_a20), a21(_a21), a22(_a22), a23(_a23), a24(_a24), a25(_a25), a26(_a26), a27(_a27), a28(_a28) {}
	
	template <typename Buffer>
	void MessagePack(Buffer& pk) const
	{
		pk << a0;
		pk << a1;
		pk << a2;
		pk << a3;
		pk << a4;
		pk << a5;
		pk << a6;
		pk << a7;
		pk << a8;
		pk << a9;
		pk << a10;
		pk << a11;
		pk << a12;
		pk << a13;
		pk << a14;
		pk << a15;
		pk << a16;
		pk << a17;
		pk << a18;
		pk << a19;
		pk << a20;
		pk << a21;
		pk << a22;
		pk << a23;
		pk << a24;
		pk << a25;
		pk << a26;
		pk << a27;
		pk << a28;
	}

	template <typename Buffer>
	void MessageUnPack(Buffer& pk) const
	{
		pk >> a0;
		pk >> a1;
		pk >> a2;
		pk >> a3;
		pk >> a4;
		pk >> a5;
		pk >> a6;
		pk >> a7;
		pk >> a8;
		pk >> a9;
		pk >> a10;
		pk >> a11;
		pk >> a12;
		pk >> a13;
		pk >> a14;
		pk >> a15;
		pk >> a16;
		pk >> a17;
		pk >> a18;
		pk >> a19;
		pk >> a20;
		pk >> a21;
		pk >> a22;
		pk >> a23;
		pk >> a24;
		pk >> a25;
		pk >> a26;
		pk >> a27;
		pk >> a28;
	}

	int MessageSize() const
	{
		return GET_TYPESIZE_VALUE(a0)
			+ GET_TYPESIZE_VALUE(a1)
			+ GET_TYPESIZE_VALUE(a2)
			+ GET_TYPESIZE_VALUE(a3)
			+ GET_TYPESIZE_VALUE(a4)
			+ GET_TYPESIZE_VALUE(a5)
			+ GET_TYPESIZE_VALUE(a6)
			+ GET_TYPESIZE_VALUE(a7)
			+ GET_TYPESIZE_VALUE(a8)
			+ GET_TYPESIZE_VALUE(a9)
			+ GET_TYPESIZE_VALUE(a10)
			+ GET_TYPESIZE_VALUE(a11)
			+ GET_TYPESIZE_VALUE(a12)
			+ GET_TYPESIZE_VALUE(a13)
			+ GET_TYPESIZE_VALUE(a14)
			+ GET_TYPESIZE_VALUE(a15)
			+ GET_TYPESIZE_VALUE(a16)
			+ GET_TYPESIZE_VALUE(a17)
			+ GET_TYPESIZE_VALUE(a18)
			+ GET_TYPESIZE_VALUE(a19)
			+ GET_TYPESIZE_VALUE(a20)
			+ GET_TYPESIZE_VALUE(a21)
			+ GET_TYPESIZE_VALUE(a22)
			+ GET_TYPESIZE_VALUE(a23)
			+ GET_TYPESIZE_VALUE(a24)
			+ GET_TYPESIZE_VALUE(a25)
			+ GET_TYPESIZE_VALUE(a26)
			+ GET_TYPESIZE_VALUE(a27)
			+ GET_TYPESIZE_VALUE(a28);
	}

	A0& a0;
	A1& a1;
	A2& a2;
	A3& a3;
	A4& a4;
	A5& a5;
	A6& a6;
	A7& a7;
	A8& a8;
	A9& a9;
	A10& a10;
	A11& a11;
	A12& a12;
	A13& a13;
	A14& a14;
	A15& a15;
	A16& a16;
	A17& a17;
	A18& a18;
	A19& a19;
	A20& a20;
	A21& a21;
	A22& a22;
	A23& a23;
	A24& a24;
	A25& a25;
	A26& a26;
	A27& a27;
	A28& a28;
};

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12, typename A13, typename A14, typename A15, typename A16, typename A17, typename A18, typename A19, typename A20, typename A21, typename A22, typename A23, typename A24, typename A25, typename A26, typename A27, typename A28, typename A29>
struct TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27, A28, A29>
{
	TMessageDefine(A0& _a0, A1& _a1, A2& _a2, A3& _a3, A4& _a4, A5& _a5, A6& _a6, A7& _a7, A8& _a8, A9& _a9, A10& _a10, A11& _a11, A12& _a12, A13& _a13, A14& _a14, A15& _a15, A16& _a16, A17& _a17, A18& _a18, A19& _a19, A20& _a20, A21& _a21, A22& _a22, A23& _a23, A24& _a24, A25& _a25, A26& _a26, A27& _a27, A28& _a28, A29& _a29) :
	a0(_a0), a1(_a1), a2(_a2), a3(_a3), a4(_a4), a5(_a5), a6(_a6), a7(_a7), a8(_a8), a9(_a9), a10(_a10), a11(_a11), a12(_a12), a13(_a13), a14(_a14), a15(_a15), a16(_a16), a17(_a17), a18(_a18), a19(_a19), a20(_a20), a21(_a21), a22(_a22), a23(_a23), a24(_a24), a25(_a25), a26(_a26), a27(_a27), a28(_a28), a29(_a29) {}
	
	template <typename Buffer>
	void MessagePack(Buffer& pk) const
	{
		pk << a0;
		pk << a1;
		pk << a2;
		pk << a3;
		pk << a4;
		pk << a5;
		pk << a6;
		pk << a7;
		pk << a8;
		pk << a9;
		pk << a10;
		pk << a11;
		pk << a12;
		pk << a13;
		pk << a14;
		pk << a15;
		pk << a16;
		pk << a17;
		pk << a18;
		pk << a19;
		pk << a20;
		pk << a21;
		pk << a22;
		pk << a23;
		pk << a24;
		pk << a25;
		pk << a26;
		pk << a27;
		pk << a28;
		pk << a29;
	}

	template <typename Buffer>
	void MessageUnPack(Buffer& pk) const
	{
		pk >> a0;
		pk >> a1;
		pk >> a2;
		pk >> a3;
		pk >> a4;
		pk >> a5;
		pk >> a6;
		pk >> a7;
		pk >> a8;
		pk >> a9;
		pk >> a10;
		pk >> a11;
		pk >> a12;
		pk >> a13;
		pk >> a14;
		pk >> a15;
		pk >> a16;
		pk >> a17;
		pk >> a18;
		pk >> a19;
		pk >> a20;
		pk >> a21;
		pk >> a22;
		pk >> a23;
		pk >> a24;
		pk >> a25;
		pk >> a26;
		pk >> a27;
		pk >> a28;
		pk >> a29;
	}

	int MessageSize() const
	{
		return GET_TYPESIZE_VALUE(a0)
			+ GET_TYPESIZE_VALUE(a1)
			+ GET_TYPESIZE_VALUE(a2)
			+ GET_TYPESIZE_VALUE(a3)
			+ GET_TYPESIZE_VALUE(a4)
			+ GET_TYPESIZE_VALUE(a5)
			+ GET_TYPESIZE_VALUE(a6)
			+ GET_TYPESIZE_VALUE(a7)
			+ GET_TYPESIZE_VALUE(a8)
			+ GET_TYPESIZE_VALUE(a9)
			+ GET_TYPESIZE_VALUE(a10)
			+ GET_TYPESIZE_VALUE(a11)
			+ GET_TYPESIZE_VALUE(a12)
			+ GET_TYPESIZE_VALUE(a13)
			+ GET_TYPESIZE_VALUE(a14)
			+ GET_TYPESIZE_VALUE(a15)
			+ GET_TYPESIZE_VALUE(a16)
			+ GET_TYPESIZE_VALUE(a17)
			+ GET_TYPESIZE_VALUE(a18)
			+ GET_TYPESIZE_VALUE(a19)
			+ GET_TYPESIZE_VALUE(a20)
			+ GET_TYPESIZE_VALUE(a21)
			+ GET_TYPESIZE_VALUE(a22)
			+ GET_TYPESIZE_VALUE(a23)
			+ GET_TYPESIZE_VALUE(a24)
			+ GET_TYPESIZE_VALUE(a25)
			+ GET_TYPESIZE_VALUE(a26)
			+ GET_TYPESIZE_VALUE(a27)
			+ GET_TYPESIZE_VALUE(a28)
			+ GET_TYPESIZE_VALUE(a29);
	}

	A0& a0;
	A1& a1;
	A2& a2;
	A3& a3;
	A4& a4;
	A5& a5;
	A6& a6;
	A7& a7;
	A8& a8;
	A9& a9;
	A10& a10;
	A11& a11;
	A12& a12;
	A13& a13;
	A14& a14;
	A15& a15;
	A16& a16;
	A17& a17;
	A18& a18;
	A19& a19;
	A20& a20;
	A21& a21;
	A22& a22;
	A23& a23;
	A24& a24;
	A25& a25;
	A26& a26;
	A27& a27;
	A28& a28;
	A29& a29;
};

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12, typename A13, typename A14, typename A15, typename A16, typename A17, typename A18, typename A19, typename A20, typename A21, typename A22, typename A23, typename A24, typename A25, typename A26, typename A27, typename A28, typename A29, typename A30>
struct TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27, A28, A29, A30>
{
	TMessageDefine(A0& _a0, A1& _a1, A2& _a2, A3& _a3, A4& _a4, A5& _a5, A6& _a6, A7& _a7, A8& _a8, A9& _a9, A10& _a10, A11& _a11, A12& _a12, A13& _a13, A14& _a14, A15& _a15, A16& _a16, A17& _a17, A18& _a18, A19& _a19, A20& _a20, A21& _a21, A22& _a22, A23& _a23, A24& _a24, A25& _a25, A26& _a26, A27& _a27, A28& _a28, A29& _a29, A30& _a30) :
	a0(_a0), a1(_a1), a2(_a2), a3(_a3), a4(_a4), a5(_a5), a6(_a6), a7(_a7), a8(_a8), a9(_a9), a10(_a10), a11(_a11), a12(_a12), a13(_a13), a14(_a14), a15(_a15), a16(_a16), a17(_a17), a18(_a18), a19(_a19), a20(_a20), a21(_a21), a22(_a22), a23(_a23), a24(_a24), a25(_a25), a26(_a26), a27(_a27), a28(_a28), a29(_a29), a30(_a30) {}
	
	template <typename Buffer>
	void MessagePack(Buffer& pk) const
	{
		pk << a0;
		pk << a1;
		pk << a2;
		pk << a3;
		pk << a4;
		pk << a5;
		pk << a6;
		pk << a7;
		pk << a8;
		pk << a9;
		pk << a10;
		pk << a11;
		pk << a12;
		pk << a13;
		pk << a14;
		pk << a15;
		pk << a16;
		pk << a17;
		pk << a18;
		pk << a19;
		pk << a20;
		pk << a21;
		pk << a22;
		pk << a23;
		pk << a24;
		pk << a25;
		pk << a26;
		pk << a27;
		pk << a28;
		pk << a29;
		pk << a30;
	}

	template <typename Buffer>
	void MessageUnPack(Buffer& pk) const
	{
		pk >> a0;
		pk >> a1;
		pk >> a2;
		pk >> a3;
		pk >> a4;
		pk >> a5;
		pk >> a6;
		pk >> a7;
		pk >> a8;
		pk >> a9;
		pk >> a10;
		pk >> a11;
		pk >> a12;
		pk >> a13;
		pk >> a14;
		pk >> a15;
		pk >> a16;
		pk >> a17;
		pk >> a18;
		pk >> a19;
		pk >> a20;
		pk >> a21;
		pk >> a22;
		pk >> a23;
		pk >> a24;
		pk >> a25;
		pk >> a26;
		pk >> a27;
		pk >> a28;
		pk >> a29;
		pk >> a30;
	}

	int MessageSize() const
	{
		return GET_TYPESIZE_VALUE(a0)
			+ GET_TYPESIZE_VALUE(a1)
			+ GET_TYPESIZE_VALUE(a2)
			+ GET_TYPESIZE_VALUE(a3)
			+ GET_TYPESIZE_VALUE(a4)
			+ GET_TYPESIZE_VALUE(a5)
			+ GET_TYPESIZE_VALUE(a6)
			+ GET_TYPESIZE_VALUE(a7)
			+ GET_TYPESIZE_VALUE(a8)
			+ GET_TYPESIZE_VALUE(a9)
			+ GET_TYPESIZE_VALUE(a10)
			+ GET_TYPESIZE_VALUE(a11)
			+ GET_TYPESIZE_VALUE(a12)
			+ GET_TYPESIZE_VALUE(a13)
			+ GET_TYPESIZE_VALUE(a14)
			+ GET_TYPESIZE_VALUE(a15)
			+ GET_TYPESIZE_VALUE(a16)
			+ GET_TYPESIZE_VALUE(a17)
			+ GET_TYPESIZE_VALUE(a18)
			+ GET_TYPESIZE_VALUE(a19)
			+ GET_TYPESIZE_VALUE(a20)
			+ GET_TYPESIZE_VALUE(a21)
			+ GET_TYPESIZE_VALUE(a22)
			+ GET_TYPESIZE_VALUE(a23)
			+ GET_TYPESIZE_VALUE(a24)
			+ GET_TYPESIZE_VALUE(a25)
			+ GET_TYPESIZE_VALUE(a26)
			+ GET_TYPESIZE_VALUE(a27)
			+ GET_TYPESIZE_VALUE(a28)
			+ GET_TYPESIZE_VALUE(a29)
			+ GET_TYPESIZE_VALUE(a30);
	}

	A0& a0;
	A1& a1;
	A2& a2;
	A3& a3;
	A4& a4;
	A5& a5;
	A6& a6;
	A7& a7;
	A8& a8;
	A9& a9;
	A10& a10;
	A11& a11;
	A12& a12;
	A13& a13;
	A14& a14;
	A15& a15;
	A16& a16;
	A17& a17;
	A18& a18;
	A19& a19;
	A20& a20;
	A21& a21;
	A22& a22;
	A23& a23;
	A24& a24;
	A25& a25;
	A26& a26;
	A27& a27;
	A28& a28;
	A29& a29;
	A30& a30;
};

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12, typename A13, typename A14, typename A15, typename A16, typename A17, typename A18, typename A19, typename A20, typename A21, typename A22, typename A23, typename A24, typename A25, typename A26, typename A27, typename A28, typename A29, typename A30, typename A31>
struct TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27, A28, A29, A30, A31>
{
	TMessageDefine(A0& _a0, A1& _a1, A2& _a2, A3& _a3, A4& _a4, A5& _a5, A6& _a6, A7& _a7, A8& _a8, A9& _a9, A10& _a10, A11& _a11, A12& _a12, A13& _a13, A14& _a14, A15& _a15, A16& _a16, A17& _a17, A18& _a18, A19& _a19, A20& _a20, A21& _a21, A22& _a22, A23& _a23, A24& _a24, A25& _a25, A26& _a26, A27& _a27, A28& _a28, A29& _a29, A30& _a30, A31& _a31) :
	a0(_a0), a1(_a1), a2(_a2), a3(_a3), a4(_a4), a5(_a5), a6(_a6), a7(_a7), a8(_a8), a9(_a9), a10(_a10), a11(_a11), a12(_a12), a13(_a13), a14(_a14), a15(_a15), a16(_a16), a17(_a17), a18(_a18), a19(_a19), a20(_a20), a21(_a21), a22(_a22), a23(_a23), a24(_a24), a25(_a25), a26(_a26), a27(_a27), a28(_a28), a29(_a29), a30(_a30), a31(_a31) {}
	
	template <typename Buffer>
	void MessagePack(Buffer& pk) const
	{
		pk << a0;
		pk << a1;
		pk << a2;
		pk << a3;
		pk << a4;
		pk << a5;
		pk << a6;
		pk << a7;
		pk << a8;
		pk << a9;
		pk << a10;
		pk << a11;
		pk << a12;
		pk << a13;
		pk << a14;
		pk << a15;
		pk << a16;
		pk << a17;
		pk << a18;
		pk << a19;
		pk << a20;
		pk << a21;
		pk << a22;
		pk << a23;
		pk << a24;
		pk << a25;
		pk << a26;
		pk << a27;
		pk << a28;
		pk << a29;
		pk << a30;
		pk << a31;
	}

	template <typename Buffer>
	void MessageUnPack(Buffer& pk) const
	{
		pk >> a0;
		pk >> a1;
		pk >> a2;
		pk >> a3;
		pk >> a4;
		pk >> a5;
		pk >> a6;
		pk >> a7;
		pk >> a8;
		pk >> a9;
		pk >> a10;
		pk >> a11;
		pk >> a12;
		pk >> a13;
		pk >> a14;
		pk >> a15;
		pk >> a16;
		pk >> a17;
		pk >> a18;
		pk >> a19;
		pk >> a20;
		pk >> a21;
		pk >> a22;
		pk >> a23;
		pk >> a24;
		pk >> a25;
		pk >> a26;
		pk >> a27;
		pk >> a28;
		pk >> a29;
		pk >> a30;
		pk >> a31;
	}

	int MessageSize() const
	{
		return GET_TYPESIZE_VALUE(a0)
			+ GET_TYPESIZE_VALUE(a1)
			+ GET_TYPESIZE_VALUE(a2)
			+ GET_TYPESIZE_VALUE(a3)
			+ GET_TYPESIZE_VALUE(a4)
			+ GET_TYPESIZE_VALUE(a5)
			+ GET_TYPESIZE_VALUE(a6)
			+ GET_TYPESIZE_VALUE(a7)
			+ GET_TYPESIZE_VALUE(a8)
			+ GET_TYPESIZE_VALUE(a9)
			+ GET_TYPESIZE_VALUE(a10)
			+ GET_TYPESIZE_VALUE(a11)
			+ GET_TYPESIZE_VALUE(a12)
			+ GET_TYPESIZE_VALUE(a13)
			+ GET_TYPESIZE_VALUE(a14)
			+ GET_TYPESIZE_VALUE(a15)
			+ GET_TYPESIZE_VALUE(a16)
			+ GET_TYPESIZE_VALUE(a17)
			+ GET_TYPESIZE_VALUE(a18)
			+ GET_TYPESIZE_VALUE(a19)
			+ GET_TYPESIZE_VALUE(a20)
			+ GET_TYPESIZE_VALUE(a21)
			+ GET_TYPESIZE_VALUE(a22)
			+ GET_TYPESIZE_VALUE(a23)
			+ GET_TYPESIZE_VALUE(a24)
			+ GET_TYPESIZE_VALUE(a25)
			+ GET_TYPESIZE_VALUE(a26)
			+ GET_TYPESIZE_VALUE(a27)
			+ GET_TYPESIZE_VALUE(a28)
			+ GET_TYPESIZE_VALUE(a29)
			+ GET_TYPESIZE_VALUE(a30)
			+ GET_TYPESIZE_VALUE(a31);
	}

	A0& a0;
	A1& a1;
	A2& a2;
	A3& a3;
	A4& a4;
	A5& a5;
	A6& a6;
	A7& a7;
	A8& a8;
	A9& a9;
	A10& a10;
	A11& a11;
	A12& a12;
	A13& a13;
	A14& a14;
	A15& a15;
	A16& a16;
	A17& a17;
	A18& a18;
	A19& a19;
	A20& a20;
	A21& a21;
	A22& a22;
	A23& a23;
	A24& a24;
	A25& a25;
	A26& a26;
	A27& a27;
	A28& a28;
	A29& a29;
	A30& a30;
	A31& a31;
};


inline TMessageDefine<> TMakeMessageDefine()
{
	return TMessageDefine<>();
}

template <typename A0>
TMessageDefine<A0> TMakeMessageDefine(A0& a0)
{
	return TMessageDefine<A0>(a0);
}

template <typename A0, typename A1>
TMessageDefine<A0, A1> TMakeMessageDefine(A0& a0, A1& a1)
{
	return TMessageDefine<A0, A1>(a0, a1);
}

template <typename A0, typename A1, typename A2>
TMessageDefine<A0, A1, A2> TMakeMessageDefine(A0& a0, A1& a1, A2& a2)
{
	return TMessageDefine<A0, A1, A2>(a0, a1, a2);
}

template <typename A0, typename A1, typename A2, typename A3>
TMessageDefine<A0, A1, A2, A3> TMakeMessageDefine(A0& a0, A1& a1, A2& a2, A3& a3)
{
	return TMessageDefine<A0, A1, A2, A3>(a0, a1, a2, a3);
}

template <typename A0, typename A1, typename A2, typename A3, typename A4>
TMessageDefine<A0, A1, A2, A3, A4> TMakeMessageDefine(A0& a0, A1& a1, A2& a2, A3& a3, A4& a4)
{
	return TMessageDefine<A0, A1, A2, A3, A4>(a0, a1, a2, a3, a4);
}

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5>
TMessageDefine<A0, A1, A2, A3, A4, A5> TMakeMessageDefine(A0& a0, A1& a1, A2& a2, A3& a3, A4& a4, A5& a5)
{
	return TMessageDefine<A0, A1, A2, A3, A4, A5>(a0, a1, a2, a3, a4, a5);
}

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6>
TMessageDefine<A0, A1, A2, A3, A4, A5, A6> TMakeMessageDefine(A0& a0, A1& a1, A2& a2, A3& a3, A4& a4, A5& a5, A6& a6)
{
	return TMessageDefine<A0, A1, A2, A3, A4, A5, A6>(a0, a1, a2, a3, a4, a5, a6);
}

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7>
TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7> TMakeMessageDefine(A0& a0, A1& a1, A2& a2, A3& a3, A4& a4, A5& a5, A6& a6, A7& a7)
{
	return TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7>(a0, a1, a2, a3, a4, a5, a6, a7);
}

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8>
TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8> TMakeMessageDefine(A0& a0, A1& a1, A2& a2, A3& a3, A4& a4, A5& a5, A6& a6, A7& a7, A8& a8)
{
	return TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8>(a0, a1, a2, a3, a4, a5, a6, a7, a8);
}

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9>
TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9> TMakeMessageDefine(A0& a0, A1& a1, A2& a2, A3& a3, A4& a4, A5& a5, A6& a6, A7& a7, A8& a8, A9& a9)
{
	return TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9>(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9);
}

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10>
TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10> TMakeMessageDefine(A0& a0, A1& a1, A2& a2, A3& a3, A4& a4, A5& a5, A6& a6, A7& a7, A8& a8, A9& a9, A10& a10)
{
	return TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10>(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10);
}

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11>
TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11> TMakeMessageDefine(A0& a0, A1& a1, A2& a2, A3& a3, A4& a4, A5& a5, A6& a6, A7& a7, A8& a8, A9& a9, A10& a10, A11& a11)
{
	return TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11>(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11);
}

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12>
TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12> TMakeMessageDefine(A0& a0, A1& a1, A2& a2, A3& a3, A4& a4, A5& a5, A6& a6, A7& a7, A8& a8, A9& a9, A10& a10, A11& a11, A12& a12)
{
	return TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12>(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12);
}

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12, typename A13>
TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13> TMakeMessageDefine(A0& a0, A1& a1, A2& a2, A3& a3, A4& a4, A5& a5, A6& a6, A7& a7, A8& a8, A9& a9, A10& a10, A11& a11, A12& a12, A13& a13)
{
	return TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13>(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13);
}

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12, typename A13, typename A14>
TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14> TMakeMessageDefine(A0& a0, A1& a1, A2& a2, A3& a3, A4& a4, A5& a5, A6& a6, A7& a7, A8& a8, A9& a9, A10& a10, A11& a11, A12& a12, A13& a13, A14& a14)
{
	return TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14>(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14);
}

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12, typename A13, typename A14, typename A15>
TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15> TMakeMessageDefine(A0& a0, A1& a1, A2& a2, A3& a3, A4& a4, A5& a5, A6& a6, A7& a7, A8& a8, A9& a9, A10& a10, A11& a11, A12& a12, A13& a13, A14& a14, A15& a15)
{
	return TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15>(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15);
}

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12, typename A13, typename A14, typename A15, typename A16>
TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16> TMakeMessageDefine(A0& a0, A1& a1, A2& a2, A3& a3, A4& a4, A5& a5, A6& a6, A7& a7, A8& a8, A9& a9, A10& a10, A11& a11, A12& a12, A13& a13, A14& a14, A15& a15, A16& a16)
{
	return TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16>(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16);
}

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12, typename A13, typename A14, typename A15, typename A16, typename A17>
TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17> TMakeMessageDefine(A0& a0, A1& a1, A2& a2, A3& a3, A4& a4, A5& a5, A6& a6, A7& a7, A8& a8, A9& a9, A10& a10, A11& a11, A12& a12, A13& a13, A14& a14, A15& a15, A16& a16, A17& a17)
{
	return TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17>(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17);
}

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12, typename A13, typename A14, typename A15, typename A16, typename A17, typename A18>
TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18> TMakeMessageDefine(A0& a0, A1& a1, A2& a2, A3& a3, A4& a4, A5& a5, A6& a6, A7& a7, A8& a8, A9& a9, A10& a10, A11& a11, A12& a12, A13& a13, A14& a14, A15& a15, A16& a16, A17& a17, A18& a18)
{
	return TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18>(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18);
}

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12, typename A13, typename A14, typename A15, typename A16, typename A17, typename A18, typename A19>
TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19> TMakeMessageDefine(A0& a0, A1& a1, A2& a2, A3& a3, A4& a4, A5& a5, A6& a6, A7& a7, A8& a8, A9& a9, A10& a10, A11& a11, A12& a12, A13& a13, A14& a14, A15& a15, A16& a16, A17& a17, A18& a18, A19& a19)
{
	return TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19>(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19);
}

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12, typename A13, typename A14, typename A15, typename A16, typename A17, typename A18, typename A19, typename A20>
TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20> TMakeMessageDefine(A0& a0, A1& a1, A2& a2, A3& a3, A4& a4, A5& a5, A6& a6, A7& a7, A8& a8, A9& a9, A10& a10, A11& a11, A12& a12, A13& a13, A14& a14, A15& a15, A16& a16, A17& a17, A18& a18, A19& a19, A20& a20)
{
	return TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20>(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20);
}

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12, typename A13, typename A14, typename A15, typename A16, typename A17, typename A18, typename A19, typename A20, typename A21>
TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21> TMakeMessageDefine(A0& a0, A1& a1, A2& a2, A3& a3, A4& a4, A5& a5, A6& a6, A7& a7, A8& a8, A9& a9, A10& a10, A11& a11, A12& a12, A13& a13, A14& a14, A15& a15, A16& a16, A17& a17, A18& a18, A19& a19, A20& a20, A21& a21)
{
	return TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21>(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21);
}

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12, typename A13, typename A14, typename A15, typename A16, typename A17, typename A18, typename A19, typename A20, typename A21, typename A22>
TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22> TMakeMessageDefine(A0& a0, A1& a1, A2& a2, A3& a3, A4& a4, A5& a5, A6& a6, A7& a7, A8& a8, A9& a9, A10& a10, A11& a11, A12& a12, A13& a13, A14& a14, A15& a15, A16& a16, A17& a17, A18& a18, A19& a19, A20& a20, A21& a21, A22& a22)
{
	return TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22>(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21, a22);
}

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12, typename A13, typename A14, typename A15, typename A16, typename A17, typename A18, typename A19, typename A20, typename A21, typename A22, typename A23>
TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23> TMakeMessageDefine(A0& a0, A1& a1, A2& a2, A3& a3, A4& a4, A5& a5, A6& a6, A7& a7, A8& a8, A9& a9, A10& a10, A11& a11, A12& a12, A13& a13, A14& a14, A15& a15, A16& a16, A17& a17, A18& a18, A19& a19, A20& a20, A21& a21, A22& a22, A23& a23)
{
	return TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23>(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21, a22, a23);
}

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12, typename A13, typename A14, typename A15, typename A16, typename A17, typename A18, typename A19, typename A20, typename A21, typename A22, typename A23, typename A24>
TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24> TMakeMessageDefine(A0& a0, A1& a1, A2& a2, A3& a3, A4& a4, A5& a5, A6& a6, A7& a7, A8& a8, A9& a9, A10& a10, A11& a11, A12& a12, A13& a13, A14& a14, A15& a15, A16& a16, A17& a17, A18& a18, A19& a19, A20& a20, A21& a21, A22& a22, A23& a23, A24& a24)
{
	return TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24>(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21, a22, a23, a24);
}

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12, typename A13, typename A14, typename A15, typename A16, typename A17, typename A18, typename A19, typename A20, typename A21, typename A22, typename A23, typename A24, typename A25>
TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25> TMakeMessageDefine(A0& a0, A1& a1, A2& a2, A3& a3, A4& a4, A5& a5, A6& a6, A7& a7, A8& a8, A9& a9, A10& a10, A11& a11, A12& a12, A13& a13, A14& a14, A15& a15, A16& a16, A17& a17, A18& a18, A19& a19, A20& a20, A21& a21, A22& a22, A23& a23, A24& a24, A25& a25)
{
	return TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25>(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21, a22, a23, a24, a25);
}

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12, typename A13, typename A14, typename A15, typename A16, typename A17, typename A18, typename A19, typename A20, typename A21, typename A22, typename A23, typename A24, typename A25, typename A26>
TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26> TMakeMessageDefine(A0& a0, A1& a1, A2& a2, A3& a3, A4& a4, A5& a5, A6& a6, A7& a7, A8& a8, A9& a9, A10& a10, A11& a11, A12& a12, A13& a13, A14& a14, A15& a15, A16& a16, A17& a17, A18& a18, A19& a19, A20& a20, A21& a21, A22& a22, A23& a23, A24& a24, A25& a25, A26& a26)
{
	return TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26>(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21, a22, a23, a24, a25, a26);
}

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12, typename A13, typename A14, typename A15, typename A16, typename A17, typename A18, typename A19, typename A20, typename A21, typename A22, typename A23, typename A24, typename A25, typename A26, typename A27>
TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27> TMakeMessageDefine(A0& a0, A1& a1, A2& a2, A3& a3, A4& a4, A5& a5, A6& a6, A7& a7, A8& a8, A9& a9, A10& a10, A11& a11, A12& a12, A13& a13, A14& a14, A15& a15, A16& a16, A17& a17, A18& a18, A19& a19, A20& a20, A21& a21, A22& a22, A23& a23, A24& a24, A25& a25, A26& a26, A27& a27)
{
	return TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27>(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21, a22, a23, a24, a25, a26, a27);
}

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12, typename A13, typename A14, typename A15, typename A16, typename A17, typename A18, typename A19, typename A20, typename A21, typename A22, typename A23, typename A24, typename A25, typename A26, typename A27, typename A28>
TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27, A28> TMakeMessageDefine(A0& a0, A1& a1, A2& a2, A3& a3, A4& a4, A5& a5, A6& a6, A7& a7, A8& a8, A9& a9, A10& a10, A11& a11, A12& a12, A13& a13, A14& a14, A15& a15, A16& a16, A17& a17, A18& a18, A19& a19, A20& a20, A21& a21, A22& a22, A23& a23, A24& a24, A25& a25, A26& a26, A27& a27, A28& a28)
{
	return TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27, A28>(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21, a22, a23, a24, a25, a26, a27, a28);
}

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12, typename A13, typename A14, typename A15, typename A16, typename A17, typename A18, typename A19, typename A20, typename A21, typename A22, typename A23, typename A24, typename A25, typename A26, typename A27, typename A28, typename A29>
TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27, A28, A29> TMakeMessageDefine(A0& a0, A1& a1, A2& a2, A3& a3, A4& a4, A5& a5, A6& a6, A7& a7, A8& a8, A9& a9, A10& a10, A11& a11, A12& a12, A13& a13, A14& a14, A15& a15, A16& a16, A17& a17, A18& a18, A19& a19, A20& a20, A21& a21, A22& a22, A23& a23, A24& a24, A25& a25, A26& a26, A27& a27, A28& a28, A29& a29)
{
	return TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27, A28, A29>(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21, a22, a23, a24, a25, a26, a27, a28, a29);
}

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12, typename A13, typename A14, typename A15, typename A16, typename A17, typename A18, typename A19, typename A20, typename A21, typename A22, typename A23, typename A24, typename A25, typename A26, typename A27, typename A28, typename A29, typename A30>
TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27, A28, A29, A30> TMakeMessageDefine(A0& a0, A1& a1, A2& a2, A3& a3, A4& a4, A5& a5, A6& a6, A7& a7, A8& a8, A9& a9, A10& a10, A11& a11, A12& a12, A13& a13, A14& a14, A15& a15, A16& a16, A17& a17, A18& a18, A19& a19, A20& a20, A21& a21, A22& a22, A23& a23, A24& a24, A25& a25, A26& a26, A27& a27, A28& a28, A29& a29, A30& a30)
{
	return TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27, A28, A29, A30>(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21, a22, a23, a24, a25, a26, a27, a28, a29, a30);
}

template <typename A0, typename A1, typename A2, typename A3, typename A4, typename A5, typename A6, typename A7, typename A8, typename A9, typename A10, typename A11, typename A12, typename A13, typename A14, typename A15, typename A16, typename A17, typename A18, typename A19, typename A20, typename A21, typename A22, typename A23, typename A24, typename A25, typename A26, typename A27, typename A28, typename A29, typename A30, typename A31>
TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27, A28, A29, A30, A31> TMakeMessageDefine(A0& a0, A1& a1, A2& a2, A3& a3, A4& a4, A5& a5, A6& a6, A7& a7, A8& a8, A9& a9, A10& a10, A11& a11, A12& a12, A13& a13, A14& a14, A15& a15, A16& a16, A17& a17, A18& a18, A19& a19, A20& a20, A21& a21, A22& a22, A23& a23, A24& a24, A25& a25, A26& a26, A27& a27, A28& a28, A29& a29, A30& a30, A31& a31)
{
	return TMessageDefine<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25, A26, A27, A28, A29, A30, A31>(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21, a22, a23, a24, a25, a26, a27, a28, a29, a30, a31);
}
