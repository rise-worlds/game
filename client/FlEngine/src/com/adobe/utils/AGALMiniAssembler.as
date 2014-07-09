// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.adobe.utils.AGALMiniAssembler

package com.adobe.utils
{
    import flash.utils.Dictionary;
    import flash.utils.ByteArray;
    import flash.display3D.Program3D;
    import flash.display3D.Context3D;
    import flash.utils.getTimer;
    import flash.utils.*;
    import flash.display3D.*;

    public class AGALMiniAssembler 
    {

        protected static const REGEXP_OUTER_SPACES:RegExp = /^\s+|\s+$/g;
        private static const OPMAP:Dictionary = new Dictionary();
        private static const REGMAP:Dictionary = new Dictionary();
        private static const SAMPLEMAP:Dictionary = new Dictionary();
        private static const MAX_OPCODES:int = 0x0800;
        private static const FRAGMENT:String = "fragment";
        private static const VERTEX:String = "vertex";
        private static const SAMPLER_TYPE_SHIFT:uint = 8;
        private static const SAMPLER_DIM_SHIFT:uint = 12;
        private static const SAMPLER_SPECIAL_SHIFT:uint = 16;
        private static const SAMPLER_REPEAT_SHIFT:uint = 20;
        private static const SAMPLER_MIPMAP_SHIFT:uint = 24;
        private static const SAMPLER_FILTER_SHIFT:uint = 28;
        private static const REG_WRITE:uint = 1;
        private static const REG_READ:uint = 2;
        private static const REG_FRAG:uint = 32;
        private static const REG_VERT:uint = 64;
        private static const OP_SCALAR:uint = 1;
        private static const OP_SPECIAL_TEX:uint = 8;
        private static const OP_SPECIAL_MATRIX:uint = 16;
        private static const OP_FRAG_ONLY:uint = 32;
        private static const OP_VERT_ONLY:uint = 64;
        private static const OP_NO_DEST:uint = 128;
        private static const OP_VERSION2:uint = 0x0100;
        private static const OP_INCNEST:uint = 0x0200;
        private static const OP_DECNEST:uint = 0x0400;
        private static const MOV:String = "mov";
        private static const ADD:String = "add";
        private static const SUB:String = "sub";
        private static const MUL:String = "mul";
        private static const DIV:String = "div";
        private static const RCP:String = "rcp";
        private static const MIN:String = "min";
        private static const MAX:String = "max";
        private static const FRC:String = "frc";
        private static const SQT:String = "sqt";
        private static const RSQ:String = "rsq";
        private static const POW:String = "pow";
        private static const LOG:String = "log";
        private static const EXP:String = "exp";
        private static const NRM:String = "nrm";
        private static const SIN:String = "sin";
        private static const COS:String = "cos";
        private static const CRS:String = "crs";
        private static const DP3:String = "dp3";
        private static const DP4:String = "dp4";
        private static const ABS:String = "abs";
        private static const NEG:String = "neg";
        private static const SAT:String = "sat";
        private static const M33:String = "m33";
        private static const M44:String = "m44";
        private static const M34:String = "m34";
        private static const DDX:String = "ddx";
        private static const DDY:String = "ddy";
        private static const IFE:String = "ife";
        private static const INE:String = "ine";
        private static const IFG:String = "ifg";
        private static const IFL:String = "ifl";
        private static const ELS:String = "els";
        private static const EIF:String = "eif";
        private static const TED:String = "ted";
        private static const KIL:String = "kil";
        private static const TEX:String = "tex";
        private static const SGE:String = "sge";
        private static const SLT:String = "slt";
        private static const SGN:String = "sgn";
        private static const SEQ:String = "seq";
        private static const SNE:String = "sne";
        private static const VA:String = "va";
        private static const VC:String = "vc";
        private static const VT:String = "vt";
        private static const VO:String = "vo";
        private static const VI:String = "vi";
        private static const FC:String = "fc";
        private static const FT:String = "ft";
        private static const FS:String = "fs";
        private static const FO:String = "fo";
        private static const FD:String = "fd";
        private static const D2:String = "2d";
        private static const D3:String = "3d";
        private static const CUBE:String = "cube";
        private static const MIPNEAREST:String = "mipnearest";
        private static const MIPLINEAR:String = "miplinear";
        private static const MIPNONE:String = "mipnone";
        private static const NOMIP:String = "nomip";
        private static const NEAREST:String = "nearest";
        private static const LINEAR:String = "linear";
        private static const CENTROID:String = "centroid";
        private static const SINGLE:String = "single";
        private static const IGNORESAMPLER:String = "ignoresampler";
        private static const REPEAT:String = "repeat";
        private static const WRAP:String = "wrap";
        private static const CLAMP:String = "clamp";
        private static const RGBA:String = "rgba";
        private static const DXT1:String = "dxt1";
        private static const DXT5:String = "dxt5";
        private static const VIDEO:String = "video";

        private static var initialized:Boolean = false;

        private var _agalcode:ByteArray = null;
        private var _error:String = "";
        private var debugEnabled:Boolean = false;
        public var verbose:Boolean = false;

        public function AGALMiniAssembler(debugging:Boolean=false):void
        {
            debugEnabled = debugging;
            if (!initialized)
            {
                init();
            };
        }

        private static function init():void
        {
            initialized = true;
            OPMAP["mov"] = new OpCode("mov", 2, 0, 0);
            OPMAP["add"] = new OpCode("add", 3, 1, 0);
            OPMAP["sub"] = new OpCode("sub", 3, 2, 0);
            OPMAP["mul"] = new OpCode("mul", 3, 3, 0);
            OPMAP["div"] = new OpCode("div", 3, 4, 0);
            OPMAP["rcp"] = new OpCode("rcp", 2, 5, 0);
            OPMAP["min"] = new OpCode("min", 3, 6, 0);
            OPMAP["max"] = new OpCode("max", 3, 7, 0);
            OPMAP["frc"] = new OpCode("frc", 2, 8, 0);
            OPMAP["sqt"] = new OpCode("sqt", 2, 9, 0);
            OPMAP["rsq"] = new OpCode("rsq", 2, 10, 0);
            OPMAP["pow"] = new OpCode("pow", 3, 11, 0);
            OPMAP["log"] = new OpCode("log", 2, 12, 0);
            OPMAP["exp"] = new OpCode("exp", 2, 13, 0);
            OPMAP["nrm"] = new OpCode("nrm", 2, 14, 0);
            OPMAP["sin"] = new OpCode("sin", 2, 15, 0);
            OPMAP["cos"] = new OpCode("cos", 2, 16, 0);
            OPMAP["crs"] = new OpCode("crs", 3, 17, 0);
            OPMAP["dp3"] = new OpCode("dp3", 3, 18, 0);
            OPMAP["dp4"] = new OpCode("dp4", 3, 19, 0);
            OPMAP["abs"] = new OpCode("abs", 2, 20, 0);
            OPMAP["neg"] = new OpCode("neg", 2, 21, 0);
            OPMAP["sat"] = new OpCode("sat", 2, 22, 0);
            OPMAP["m33"] = new OpCode("m33", 3, 23, 16);
            OPMAP["m44"] = new OpCode("m44", 3, 24, 16);
            OPMAP["m34"] = new OpCode("m34", 3, 25, 16);
            OPMAP["ddx"] = new OpCode("ddx", 2, 26, (0x0100 | 32));
            OPMAP["ddy"] = new OpCode("ddy", 2, 27, (0x0100 | 32));
            OPMAP["ife"] = new OpCode("ife", 2, 28, (((128 | 0x0100) | 0x0200) | 1));
            OPMAP["ine"] = new OpCode("ine", 2, 29, (((128 | 0x0100) | 0x0200) | 1));
            OPMAP["ifg"] = new OpCode("ifg", 2, 30, (((128 | 0x0100) | 0x0200) | 1));
            OPMAP["ifl"] = new OpCode("ifl", 2, 31, (((128 | 0x0100) | 0x0200) | 1));
            OPMAP["els"] = new OpCode("els", 0, 32, ((((128 | 0x0100) | 0x0200) | 0x0400) | 1));
            OPMAP["eif"] = new OpCode("eif", 0, 33, (((128 | 0x0100) | 0x0400) | 1));
            OPMAP["ted"] = new OpCode("ted", 3, 38, ((32 | 8) | 0x0100));
            OPMAP["kil"] = new OpCode("kil", 1, 39, (128 | 32));
            OPMAP["tex"] = new OpCode("tex", 3, 40, (32 | 8));
            OPMAP["sge"] = new OpCode("sge", 3, 41, 0);
            OPMAP["slt"] = new OpCode("slt", 3, 42, 0);
            OPMAP["sgn"] = new OpCode("sgn", 2, 43, 0);
            OPMAP["seq"] = new OpCode("seq", 3, 44, 0);
            OPMAP["sne"] = new OpCode("sne", 3, 45, 0);
            SAMPLEMAP["rgba"] = new Sampler("rgba", 8, 0);
            SAMPLEMAP["dxt1"] = new Sampler("dxt1", 8, 1);
            SAMPLEMAP["dxt5"] = new Sampler("dxt5", 8, 2);
            SAMPLEMAP["video"] = new Sampler("video", 8, 3);
            SAMPLEMAP["2d"] = new Sampler("2d", 12, 0);
            SAMPLEMAP["3d"] = new Sampler("3d", 12, 2);
            SAMPLEMAP["cube"] = new Sampler("cube", 12, 1);
            SAMPLEMAP["mipnearest"] = new Sampler("mipnearest", 24, 1);
            SAMPLEMAP["miplinear"] = new Sampler("miplinear", 24, 2);
            SAMPLEMAP["mipnone"] = new Sampler("mipnone", 24, 0);
            SAMPLEMAP["nomip"] = new Sampler("nomip", 24, 0);
            SAMPLEMAP["nearest"] = new Sampler("nearest", 28, 0);
            SAMPLEMAP["linear"] = new Sampler("linear", 28, 1);
            SAMPLEMAP["centroid"] = new Sampler("centroid", 16, 1);
            SAMPLEMAP["single"] = new Sampler("single", 16, 2);
            SAMPLEMAP["ignoresampler"] = new Sampler("ignoresampler", 16, 4);
            SAMPLEMAP["repeat"] = new Sampler("repeat", 20, 1);
            SAMPLEMAP["wrap"] = new Sampler("wrap", 20, 1);
            SAMPLEMAP["clamp"] = new Sampler("clamp", 20, 0);
        }


        public function get error():String
        {
            return (_error);
        }

        public function get agalcode():ByteArray
        {
            return (_agalcode);
        }

        public function assemble2(ctx3d:Context3D, version:uint, vertexsrc:String, fragmentsrc:String):Program3D
        {
            var _local6:ByteArray = assemble("vertex", vertexsrc, version);
            var _local7:ByteArray = assemble("fragment", fragmentsrc, version);
            var _local5:Program3D = ctx3d.createProgram();
            _local5.upload(_local6, _local7);
            return (_local5);
        }

        public function assemble(mode:String, source:String, version:uint=1, ignorelimits:Boolean=false):ByteArray
        {
            var _local42:int;
            var _local30 = null;
            var _local22:int;
            var _local28:int;
            var _local5 = null;
            var _local34 = null;
            var _local10 = null;
            var _local17 = null;
            var _local43:Boolean;
            var _local39:int;
            var _local29:int;
            var _local40:int;
            var _local35:Boolean;
            var _local16 = null;
            var _local27 = null;
            var _local9 = null;
            var _local15 = null;
            var _local19:int;
            var _local48:int;
            var _local49 = null;
            var _local33:Boolean;
            var _local7:Boolean;
            var _local24:int;
            var _local20:int;
            var _local8:int;
            var _local18:int;
            var _local31:int;
            var _local41:int;
            var _local11 = null;
            var _local26 = null;
            var _local6 = null;
            var _local38 = null;
            var _local45:int;
            var _local13:int;
            var _local12:Number;
            var _local44 = null;
            var _local36 = null;
            var _local37:int;
            var _local14:int;
            var _local47 = null;
            var _local23:uint = getTimer();
            _agalcode = new ByteArray();
            _error = "";
            var _local46:Boolean;
            if (mode == "fragment")
            {
                _local46 = true;
            }
            else
            {
                if (mode != "vertex")
                {
                    _error = (('ERROR: mode needs to be "fragment" or "vertex" but is "' + mode) + '".');
                };
            };
            agalcode.endian = "littleEndian";
            agalcode.writeByte(160);
            agalcode.writeUnsignedInt(version);
            agalcode.writeByte(161);
            agalcode.writeByte(((_local46) ? 1 : 0));
            initregmap(version, ignorelimits);
            var _local25:Array = source.replace(/[\f\n\r\v]+/g, "\n").split("\n");
            var _local21:int;
            var _local32:int = _local25.length;
            _local42 = 0;
            while ((((_local42 < _local32)) && ((_error == ""))))
            {
                _local30 = new String(_local25[_local42]);
                _local30 = _local30.replace(REGEXP_OUTER_SPACES, "");
                _local22 = _local30.search("//");
                if (_local22 != -1)
                {
                    _local30 = _local30.slice(0, _local22);
                };
                _local28 = _local30.search(/<.*>/g);
                if (_local28 != -1)
                {
                    _local5 = _local30.slice(_local28).match(/([\w\.\-\+]+)/gi);
                    _local30 = _local30.slice(0, _local28);
                };
                _local34 = _local30.match(/^\w{3}/gi);
                if (!_local34)
                {
                    if (_local30.length >= 3)
                    {
                        (trace(((("warning: bad line " + _local42) + ": ") + _local25[_local42])));
                    };
                }
                else
                {
                    _local10 = OPMAP[_local34[0]];
                    if (debugEnabled)
                    {
                        (trace(_local10));
                    };
                    if (_local10 == null)
                    {
                        if (_local30.length >= 3)
                        {
                            (trace(((("warning: bad line " + _local42) + ": ") + _local25[_local42])));
                        };
                    }
                    else
                    {
                        _local30 = _local30.slice((_local30.search(_local10.name) + _local10.name.length));
                        if ((((_local10.flags & 0x0100)) && ((version < 2))))
                        {
                            _error = "error: opcode requires version 2.";
                            break;
                        };
                        if ((((_local10.flags & 64)) && (_local46)))
                        {
                            _error = "error: opcode is only allowed in vertex programs.";
                            break;
                        };
                        if ((((_local10.flags & 32)) && (!(_local46))))
                        {
                            _error = "error: opcode is only allowed in fragment programs.";
                            break;
                        };
                        if (verbose)
                        {
                            (trace(("emit opcode=" + _local10)));
                        };
                        agalcode.writeUnsignedInt(_local10.emitCode);
                        if (++_local21 > 0x0800)
                        {
                            _error = "error: too many opcodes. maximum is 2048.";
                            break;
                        };
                        _local17 = _local30.match(/vc\[([vof][acostdip]?)(\d*)?(\.[xyzw](\+\d{1,3})?)?\](\.[xyzw]{1,4})?|([vof][acostdip]?)(\d*)?(\.[xyzw]{1,4})?/gi);
                        if (((!(_local17)) || (!((_local17.length == _local10.numRegister)))))
                        {
                            _error = (((("error: wrong number of operands. found " + _local17.length) + " but expected ") + _local10.numRegister) + ".");
                            break;
                        };
                        _local43 = false;
                        _local39 = 160;
                        _local29 = _local17.length;
                        _local40 = 0;
                        while (_local40 < _local29)
                        {
                            _local35 = false;
                            _local16 = _local17[_local40].match(/\[.*\]/gi);
                            if (((_local16) && ((_local16.length > 0))))
                            {
                                _local17[_local40] = _local17[_local40].replace(_local16[0], "0");
                                if (verbose)
                                {
                                    (trace("IS REL"));
                                };
                                _local35 = true;
                            };
                            _local27 = _local17[_local40].match(/^\b[A-Za-z]{1,2}/gi);
                            if (!_local27)
                            {
                                _error = (((("error: could not parse operand " + _local40) + " (") + _local17[_local40]) + ").");
                                _local43 = true;
                                break;
                            };
                            _local9 = REGMAP[_local27[0]];
                            if (debugEnabled)
                            {
                                (trace(_local9));
                            };
                            if (_local9 == null)
                            {
                                _error = (((("error: could not find register name for operand " + _local40) + " (") + _local17[_local40]) + ").");
                                _local43 = true;
                                break;
                            };
                            if (_local46)
                            {
                                if (!(_local9.flags & 32))
                                {
                                    _error = (((("error: register operand " + _local40) + " (") + _local17[_local40]) + ") only allowed in vertex programs.");
                                    _local43 = true;
                                    break;
                                };
                                if (_local35)
                                {
                                    _error = (((("error: register operand " + _local40) + " (") + _local17[_local40]) + ") relative adressing not allowed in fragment programs.");
                                    _local43 = true;
                                    break;
                                };
                            }
                            else
                            {
                                if (!(_local9.flags & 64))
                                {
                                    _error = (((("error: register operand " + _local40) + " (") + _local17[_local40]) + ") only allowed in fragment programs.");
                                    _local43 = true;
                                    break;
                                };
                            };
                            _local17[_local40] = _local17[_local40].slice((_local17[_local40].search(_local9.name) + _local9.name.length));
                            _local15 = ((_local35) ? _local16[0].match(/\d+/) : _local17[_local40].match(/\d+/));
                            _local19 = 0;
                            if (_local15)
                            {
                                _local19 = _local15[0];
                            };
                            if (_local9.range < _local19)
                            {
                                _error = (((((("error: register operand " + _local40) + " (") + _local17[_local40]) + ") index exceeds limit of ") + (_local9.range + 1)) + ".");
                                _local43 = true;
                                break;
                            };
                            _local48 = 0;
                            _local49 = _local17[_local40].match(/(\.[xyzw]{1,4})/);
                            _local33 = (((_local40 == 0)) && (!((_local10.flags & 128))));
                            _local7 = (((_local40 == 2)) && ((_local10.flags & 8)));
                            _local24 = 0;
                            _local20 = 0;
                            _local8 = 0;
                            if (((_local33) && (_local35)))
                            {
                                _error = "error: relative can not be destination";
                                _local43 = true;
                                break;
                            };
                            if (_local49)
                            {
                                _local48 = 0;
                                _local31 = _local49[0].length;
                                _local41 = 1;
                                while (_local41 < _local31)
                                {
                                    _local18 = (_local49[0].charCodeAt(_local41) - "x".charCodeAt(0));
                                    if (_local18 > 2)
                                    {
                                        _local18 = 3;
                                    };
                                    if (_local33)
                                    {
                                        _local48 = (_local48 | (1 << _local18));
                                    }
                                    else
                                    {
                                        _local48 = (_local48 | (_local18 << ((_local41 - 1) << 1)));
                                    };
                                    _local41++;
                                };
                                if (!_local33)
                                {
                                    while (_local41 <= 4)
                                    {
                                        _local48 = (_local48 | (_local18 << ((_local41 - 1) << 1)));
                                        _local41++;
                                    };
                                };
                            }
                            else
                            {
                                _local48 = ((_local33) ? 15 : 228);
                            };
                            if (_local35)
                            {
                                _local11 = _local16[0].match(/[A-Za-z]{1,2}/gi);
                                _local26 = REGMAP[_local11[0]];
                                if (_local26 == null)
                                {
                                    _error = "error: bad index register";
                                    _local43 = true;
                                    break;
                                };
                                _local24 = _local26.emitCode;
                                _local6 = _local16[0].match(/(\.[xyzw]{1,1})/);
                                if (_local6.length == 0)
                                {
                                    _error = "error: bad index register select";
                                    _local43 = true;
                                    break;
                                };
                                _local20 = (_local6[0].charCodeAt(1) - "x".charCodeAt(0));
                                if (_local20 > 2)
                                {
                                    _local20 = 3;
                                };
                                _local38 = _local16[0].match(/\+\d{1,3}/gi);
                                if (_local38.length > 0)
                                {
                                    _local8 = _local38[0];
                                };
                                if ((((_local8 < 0)) || ((_local8 > 0xFF))))
                                {
                                    _error = (("error: index offset " + _local8) + " out of bounds. [0..255]");
                                    _local43 = true;
                                    break;
                                };
                                if (verbose)
                                {
                                    (trace(((((((((((("RELATIVE: type=" + _local24) + "==") + _local11[0]) + " sel=") + _local20) + "==") + _local6[0]) + " idx=") + _local19) + " offset=") + _local8)));
                                };
                            };
                            if (verbose)
                            {
                                (trace((((((("  emit argcode=" + _local9) + "[") + _local19) + "][") + _local48) + "]")));
                            };
                            if (_local33)
                            {
                                agalcode.writeShort(_local19);
                                agalcode.writeByte(_local48);
                                agalcode.writeByte(_local9.emitCode);
                                _local39 = (_local39 - 32);
                            }
                            else
                            {
                                if (_local7)
                                {
                                    if (verbose)
                                    {
                                        (trace("  emit sampler"));
                                    };
                                    _local45 = 5;
                                    _local13 = (((_local5)==null) ? 0 : _local5.length);
                                    _local12 = 0;
                                    _local41 = 0;
                                    while (_local41 < _local13)
                                    {
                                        if (verbose)
                                        {
                                            (trace(("    opt: " + _local5[_local41])));
                                        };
                                        _local44 = SAMPLEMAP[_local5[_local41]];
                                        if (_local44 == null)
                                        {
                                            _local12 = _local5[_local41];
                                            if (verbose)
                                            {
                                                (trace(("    bias: " + _local12)));
                                            };
                                        }
                                        else
                                        {
                                            if (_local44.flag != 16)
                                            {
                                                _local45 = (_local45 & ~((15 << _local44.flag)));
                                            };
                                            _local45 = (_local45 | (_local44.mask << _local44.flag));
                                        };
                                        _local41++;
                                    };
                                    agalcode.writeShort(_local19);
                                    agalcode.writeByte((_local12 * 8));
                                    agalcode.writeByte(0);
                                    agalcode.writeUnsignedInt(_local45);
                                    if (verbose)
                                    {
                                        (trace(("    bits: " + (_local45 - 5))));
                                    };
                                    _local39 = (_local39 - 64);
                                }
                                else
                                {
                                    if (_local40 == 0)
                                    {
                                        agalcode.writeUnsignedInt(0);
                                        _local39 = (_local39 - 32);
                                    };
                                    agalcode.writeShort(_local19);
                                    agalcode.writeByte(_local8);
                                    agalcode.writeByte(_local48);
                                    agalcode.writeByte(_local9.emitCode);
                                    agalcode.writeByte(_local24);
                                    agalcode.writeShort(((_local35) ? (_local20 | 0x8000) : 0));
                                    _local39 = (_local39 - 64);
                                };
                            };
                            _local40++;
                        };
                        _local40 = 0;
                        while (_local40 < _local39)
                        {
                            agalcode.writeByte(0);
                            _local40 = (_local40 + 8);
                        };
                        if (_local43) break;
                    };
                };
                _local42++;
            };
            if (_error != "")
            {
                _error = (_error + ((("\n  at line " + _local42) + " ") + _local25[_local42]));
                agalcode.length = 0;
                (trace(_error));
            };
            if (debugEnabled)
            {
                _local36 = "generated bytecode:";
                _local37 = agalcode.length;
                _local14 = 0;
                while (_local14 < _local37)
                {
                    if (!(_local14 % 16))
                    {
                        _local36 = (_local36 + "\n");
                    };
                    if (!(_local14 % 4))
                    {
                        _local36 = (_local36 + " ");
                    };
                    _local47 = agalcode[_local14].toString(16);
                    if (_local47.length < 2)
                    {
                        _local47 = ("0" + _local47);
                    };
                    _local36 = (_local36 + _local47);
                    _local14++;
                };
                (trace(_local36));
            };
            if (verbose)
            {
                (trace((("AGALMiniAssembler.assemble time: " + ((getTimer() - _local23) / 1000)) + "s")));
            };
            return (agalcode);
        }

        private function initregmap(version:uint, ignorelimits:Boolean):void
        {
            REGMAP["va"] = new Register("va", "vertex attribute", 0, ((ignorelimits) ? 0x0400 : 7), (64 | 2));
            REGMAP["vc"] = new Register("vc", "vertex constant", 1, ((ignorelimits) ? 0x0400 : (((version)==1) ? 127 : 250)), (64 | 2));
            REGMAP["vt"] = new Register("vt", "vertex temporary", 2, ((ignorelimits) ? 0x0400 : (((version)==1) ? 7 : 27)), ((64 | 1) | 2));
            REGMAP["vo"] = new Register("vo", "vertex output", 3, ((ignorelimits) ? 0x0400 : 0), (64 | 1));
            REGMAP["vi"] = new Register("vi", "varying", 4, ((ignorelimits) ? 0x0400 : (((version)==1) ? 7 : 11)), (((64 | 32) | 2) | 1));
            REGMAP["fc"] = new Register("fc", "fragment constant", 1, ((ignorelimits) ? 0x0400 : (((version)==1) ? 27 : 63)), (32 | 2));
            REGMAP["ft"] = new Register("ft", "fragment temporary", 2, ((ignorelimits) ? 0x0400 : (((version)==1) ? 7 : 27)), ((32 | 1) | 2));
            REGMAP["fs"] = new Register("fs", "texture sampler", 5, ((ignorelimits) ? 0x0400 : 7), (32 | 2));
            REGMAP["fo"] = new Register("fo", "fragment output", 3, ((ignorelimits) ? 0x0400 : (((version)==1) ? 0 : 3)), (32 | 1));
            REGMAP["fd"] = new Register("fd", "fragment depth output", 6, ((ignorelimits) ? 0x0400 : (((version)==1) ? -1 : 0)), (32 | 1));
            REGMAP["op"] = REGMAP["vo"];
            REGMAP["i"] = REGMAP["vi"];
            REGMAP["v"] = REGMAP["vi"];
            REGMAP["oc"] = REGMAP["fo"];
            REGMAP["od"] = REGMAP["fd"];
            REGMAP["fi"] = REGMAP["vi"];
        }


    }
}//package com.adobe.utils

class OpCode 
{

    /*private*/ var _emitCode:uint;
    /*private*/ var _flags:uint;
    /*private*/ var _name:String;
    /*private*/ var _numRegister:uint;

    public function OpCode(name:String, numRegister:uint, emitCode:uint, flags:uint)
    {
        _name = name;
        _numRegister = numRegister;
        _emitCode = emitCode;
        _flags = flags;
    }

    public function get emitCode():uint
    {
        return (_emitCode);
    }

    public function get flags():uint
    {
        return (_flags);
    }

    public function get name():String
    {
        return (_name);
    }

    public function get numRegister():uint
    {
        return (_numRegister);
    }

    public function toString():String
    {
        return ((((((((('[OpCode name="' + _name) + '", numRegister=') + _numRegister) + ", emitCode=") + _emitCode) + ", flags=") + _flags) + "]"));
    }


}
class Register 
{

    /*private*/ var _emitCode:uint;
    /*private*/ var _name:String;
    /*private*/ var _longName:String;
    /*private*/ var _flags:uint;
    /*private*/ var _range:uint;

    public function Register(name:String, longName:String, emitCode:uint, range:uint, flags:uint)
    {
        _name = name;
        _longName = longName;
        _emitCode = emitCode;
        _range = range;
        _flags = flags;
    }

    public function get emitCode():uint
    {
        return (_emitCode);
    }

    public function get longName():String
    {
        return (_longName);
    }

    public function get name():String
    {
        return (_name);
    }

    public function get flags():uint
    {
        return (_flags);
    }

    public function get range():uint
    {
        return (_range);
    }

    public function toString():String
    {
        return ((((((((((('[Register name="' + _name) + '", longName="') + _longName) + '", emitCode=') + _emitCode) + ", range=") + _range) + ", flags=") + _flags) + "]"));
    }


}
class Sampler 
{

    /*private*/ var _flag:uint;
    /*private*/ var _mask:uint;
    /*private*/ var _name:String;

    public function Sampler(name:String, flag:uint, mask:uint)
    {
        _name = name;
        _flag = flag;
        _mask = mask;
    }

    public function get flag():uint
    {
        return (_flag);
    }

    public function get mask():uint
    {
        return (_mask);
    }

    public function get name():String
    {
        return (_name);
    }

    public function toString():String
    {
        return ((((((('[Sampler name="' + _name) + '", flag="') + _flag) + '", mask=') + mask) + "]"));
    }


}

