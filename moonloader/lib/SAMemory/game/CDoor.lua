--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.ffi.cdef[[
	typedef struct CDoor
	{
		float         fOpenAngle;
		float         fClosedAngle;
		short         nDirn;
		unsigned char nAxis;
		unsigned char nDoorState;
		float         fAngle;
		float         fPrevAngle;
		float         fAngVel;
	} CDoor;

]]

shared.validate_size('CDoor', 0x18)
