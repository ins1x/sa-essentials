--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'CPed'
shared.require 'CTaskManager'
shared.require 'CEventHandler'
shared.require 'CEventGroup'
shared.require 'CEventScanner'
shared.require 'CEntityScanner'
shared.require 'CEntity'

shared.ffi.cdef[[
	typedef struct CPedIntelligence
	{
		CPed    			 *pPed;
    CTaskManager   TaskMgr;
    CEventHandler  eventHandler;
    CEventGroup    eventGroup;
    unsigned int   dwDecisionMakerType;
    unsigned int   dwDecisionMakerTypeInGroup;
    float          fHearingRange;
    float          fSeeingRange;
    unsigned int   dwDmNumPedsToScan;
    float          fDmRadius;
    int field_CC;
    char field_D0;
    unsigned char  nEventId;
    unsigned char  nEventPriority;
    char field_D3;
    CEntityScanner vehicleScanner;
    CEntityScanner pedScanner;
    char field_174;
    char gap_175[3];
    CTaskTimer field_178;
    int field_184;
    char field_188;
    char gap_189[3];
    CEventScanner  eventScanner;
    char field_260;
    char gap_261[3];
    char field_264[16];
    int field_274;
    int field_278;
    char gap_27C[12];
    CEntity *apInterestingEntities[3];
	} CPedIntelligence;
]]

shared.validate_size('CPedIntelligence', 0x294)
