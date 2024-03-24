--[[
    Project: SF.lua <https://github.com/imring/SF.lua>
    License: GNU General Public License v3.0
    Authors: look in file <AUTHORS>.

    mod_sa is available from https://github.com/BlastHackNet/mod_s0beit_sa/
]]

local ffi = require("ffi")

ffi.cdef[[
    /*typedef struct SFL_SAMPPools SFL_SAMPPools;
    typedef struct SFL_SAMP SFL_SAMP;
    typedef struct SFL_ServerInfo SFL_ServerInfo;
    typedef struct SFL_ServerPresets SFL_ServerPresets;
    typedef struct SFL_DialogInfo SFL_DialogInfo;
    typedef struct SFL_TextDrawTransmit SFL_TextDrawTransmit;
    typedef struct SFL_Textdraw SFL_Textdraw;
    typedef struct SFL_TextdrawPool SFL_TextdrawPool;
    typedef struct SFL_Pickup SFL_Pickup;
    typedef struct SFL_PickupPool SFL_PickupPool;
    typedef struct SFL_PlayerPool SFL_PlayerPool;
    typedef struct SFL_SAMPKeys SFL_SAMPKeys;
    typedef struct SFL_OnFootData SFL_OnFootData;
    typedef struct SFL_InCarData SFL_InCarData;
    typedef struct SFL_AimData SFL_AimData;
    typedef struct SFL_TrailerData SFL_TrailerData;
    typedef struct SFL_PassengerData SFL_PassengerData;
    typedef struct SFL_DamageData SFL_DamageData;
    typedef struct SFL_SurfData SFL_SurfData;
    typedef struct SFL_UnoccupiedData SFL_UnoccupiedData;
    typedef struct SFL_BulletData SFL_BulletData;
    typedef struct SFL_SpectatorData SFL_SpectatorData;
    typedef struct SFL_StatsData SFL_StatsData;
    typedef struct SFL_HeadSync SFL_HeadSync;
    typedef struct SFL_LocalPlayer SFL_LocalPlayer;*/
    typedef struct SFL_RemotePlayerData SFL_RemotePlayerData;
    /*typedef struct SFL_RemotePlayer SFL_RemotePlayer;*/
    typedef struct SFL_SAMPEntity SFL_SAMPEntity;
    typedef struct SFL_SAMPPed SFL_SAMPPed;
    /*typedef struct SFL_VehiclePool SFL_VehiclePool;
    typedef struct SFL_SAMPVehicle SFL_SAMPVehicle;
    typedef struct SFL_Object SFL_Object;
    typedef struct SFL_ObjectPool SFL_ObjectPool;
    typedef struct SFL_Gangzone SFL_Gangzone;
    typedef struct SFL_GangzonePool SFL_GangzonePool;
    typedef struct SFL_TextLabel SFL_TextLabel;
    typedef struct SFL_TextLabelPool SFL_TextLabelPool;
    typedef struct SFL_ChatEntry SFL_ChatEntry;*/
    typedef struct SFL_FontRenderer SFL_FontRenderer;
    /*typedef struct SFL_ChatInfo SFL_ChatInfo;*/
    typedef struct SFL_InputBox SFL_InputBox;
    /*typedef struct SFL_InputInfo SFL_InputInfo;
    typedef struct SFL_KillEntry SFL_KillEntry;
    typedef struct SFL_KillInfo SFL_KillInfo;
    typedef struct SFL_ChatPlayer SFL_ChatPlayer;*/
    typedef struct SFL_Audio SFL_Audio;
    /*typedef struct SFL_GameInfo SFL_GameInfo;
    typedef struct SFL_ScoreboardInfo SFL_ScoreboardInfo;
    typedef struct SFL_ActorPool SFL_ActorPool;
    typedef struct SFL_ChatBubbleInfo SFL_ChatBubbleInfo;
    typedef struct SFL_StreamedOutPlayerInfo SFL_StreamedOutPlayerInfo;*/
    typedef struct SFL_Camera SFL_Camera;
    
    enum Limits
    {
        SAMP_MAX_ACTORS = 1000,
        SAMP_MAX_PLAYERS = 1004,
        SAMP_MAX_VEHICLES = 2000,
        SAMP_MAX_PICKUPS = 4096,
        SAMP_MAX_OBJECTS = 1000,
        SAMP_MAX_GANGZONES = 1024,
        SAMP_MAX_3DTEXTS = 2048,
        SAMP_MAX_TEXTDRAWS = 2048,
        SAMP_MAX_PLAYERTEXTDRAWS = 256,
        SAMP_MAX_CLIENTCMDS = 144,
        SAMP_MAX_MENUS = 128,
        SAMP_MAX_PLAYER_NAME = 24,
        SAMP_ALLOWED_PLAYER_NAME_LENGTH = 20,
    };
    
    #pragma pack(push, 1)
    
    struct SFL_SAMPPools
    {
        struct SFL_ActorPool		*pActor;
        struct SFL_ObjectPool		*pObject;
        struct SFL_GangzonePool	*pGangzone;
        struct SFL_TextLabelPool	*pText3D;
        struct SFL_TextdrawPool	*pTextdraw;
        void					*pPlayerLabels;
        struct SFL_PlayerPool		*pPlayer;
        struct SFL_VehiclePool	*pVehicle;
        struct SFL_PickupPool		*pPickup;
    };
    
    struct SFL_SAMP
    {
        void					*pUnk0;
        struct SFL_ServerInfo		*pServerInfo;
        BYTE					byteSpace[24];
        char					szIP[257];
        char					szHostname[259];
        bool					bNametagStatus; // changes by /nametagstatus
        DWORD					ulPort;
        DWORD					ulMapIcons[100];
        int						iLanMode;
        int						iGameState;
        DWORD					ulConnectTick;
        struct SFL_ServerPresets	*pSettings;
        void	*pRakClientInterface;
        struct SFL_SAMPPools		*pPools;
    };
    
    struct SFL_ServerInfo
    {
        DWORD 					uiIP;
        WORD 					usPort;
    };
    
    struct SFL_ServerPresets
    {
        BYTE					byteCJWalk;
        int						m_iDeathDropMoney;
        float					fWorldBoundaries[4];
        bool					m_bAllowWeapons;
        float					fGravity;
        BYTE					byteDisableInteriorEnterExits;
        DWORD					ulVehicleFriendlyFire;
        bool					m_byteHoldTime;
        bool					m_bInstagib;
        bool					m_bZoneNames;
        bool					m_byteFriendlyFire;
        int						iClassesAvailable;
        float					fNameTagsDistance;
        bool					m_bManualVehicleEngineAndLight;
        BYTE					byteWorldTime_Hour;
        BYTE					byteWorldTime_Minute;
        BYTE					byteWeather;
        BYTE					byteNoNametagsBehindWalls;
        int						iPlayerMarkersMode;
        float					fGlobalChatRadiusLimit;
        BYTE					byteShowNameTags;
        bool					m_bLimitGlobalChatRadius;
    };
    
    struct SFL_DialogInfo
    {
        void					*m_pD3DDevice;
        int						iTextPoxX;
        int						iTextPoxY;
        DWORD					uiDialogSizeX;
        DWORD					uiDialogSizeY;
        int						iBtnOffsetX;
        int						iBtnOffsetY;
        void					*pDialog;
        void					*pList;
        void					*pEditBox;
        int						iIsActive;
        int						iType;
        DWORD					DialogID;
        PCHAR					pText;
        DWORD					uiTextWidth;
        DWORD					uiTextHeight;
        char					szCaption[65];
        int						bServerside;
    };
    
    struct SFL_TextDrawTransmit
    {
        union
        {
            BYTE byteFlags;
            struct
            {
                BYTE byteBox : 1;
                BYTE byteLeft : 1;
                BYTE byteRight : 1;
                BYTE byteCenter : 1;
                BYTE byteProportional : 1;
                BYTE bytePadding : 3;
            };
        };
        float					fLetterWidth;
        float					fLetterHeight;
        DWORD					dwLetterColor;
        float					fBoxWidth;
        float					fBoxHeight;
        DWORD					dwBoxColor;
        BYTE					byteShadow;
        BYTE					byteOutline;
        DWORD					dwBackgroundColor;
        BYTE					byteStyle;
        BYTE					byteUNK;
        float					fX;
        float					fY;
        WORD					sModel;
        float					fRot[3];
        float					fZoom;
        WORD					sColor[2];
    };
    
    struct SFL_Textdraw
    {
        char					szText[800 + 1];
        char					szString[1600 + 2];
        float					fLetterWidth;
        float					fLetterHeight;
        DWORD					dwLetterColor;
        BYTE					byte_unk;	// always = 01 (?)
        BYTE					byteCenter;
        BYTE					byteBox;
        float					fBoxSizeX;
        float					fBoxSizeY;
        DWORD					dwBoxColor;
        BYTE					byteProportional;
        DWORD					dwShadowColor;
        BYTE					byteShadowSize;
        BYTE					byteOutline;
        BYTE					byteLeft;
        BYTE					byteRight;
        int						iStyle;		// font style/texture/model
        float					fX;
        float					fY;
        BYTE					unk[8];
        DWORD					dword99B;	// -1 by default
        DWORD					dword99F;	// -1 by default
        DWORD					index;		// -1 if bad
        BYTE					byte9A7;	// = 1; 0 by default
        WORD					sModel;
        float					fRot[3];
        float					fZoom;
        WORD					sColor[2];
        BYTE					f9BE;
        BYTE					byte9BF;
        BYTE					byte9C0;
        DWORD					dword9C1;
        DWORD					dword9C5;
        DWORD					dword9C9;
        DWORD					dword9CD;
        BYTE					byte9D1;
        DWORD					dword9D2;
    };
    
    struct SFL_TextdrawPool
    {
        int						iIsListed[SAMP_MAX_TEXTDRAWS];
        int						iPlayerTextDraw[SAMP_MAX_PLAYERTEXTDRAWS];
        struct SFL_Textdraw		*textdraw[SAMP_MAX_TEXTDRAWS];
        struct SFL_Textdraw		*playerTextdraw[SAMP_MAX_PLAYERTEXTDRAWS];
    };
    
    struct SFL_Pickup
    {
        int						iModelID;
        int						iType;
        float					fPosition[3];
    };
    
    struct SFL_PickupPool
    {
        int						iPickupsCount;
        DWORD					ul_GTA_PickupID[SAMP_MAX_PICKUPS];
        int						iPickupID[SAMP_MAX_PICKUPS];
        int						iTimePickup[SAMP_MAX_PICKUPS];
        BYTE					unk[SAMP_MAX_PICKUPS * 3];
        struct SFL_Pickup			pickup[SAMP_MAX_PICKUPS];
    };
    
    struct SFL_PlayerPool
    {
        DWORD					ulMaxPlayerID;
        WORD					sLocalPlayerID;
        void					*pVTBL_txtHandler;
        stdstring				strLocalPlayerName;
        struct SFL_LocalPlayer	*pLocalPlayer;
        int						iLocalPlayerPing;
        int						iLocalPlayerScore;
        struct SFL_RemotePlayer	*pRemotePlayer[SAMP_MAX_PLAYERS];
        int						iIsListed[SAMP_MAX_PLAYERS];
        DWORD					dwPlayerIP[SAMP_MAX_PLAYERS]; // always 0
    };
    
    struct SFL_SAMPKeys
    {
        BYTE keys_primaryFire : 1;
        BYTE keys_horn__crouch : 1;
        BYTE keys_secondaryFire__shoot : 1;
        BYTE keys_accel__zoomOut : 1;
        BYTE keys_enterExitCar : 1;
        BYTE keys_decel__jump : 1;			// on foot: jump or zoom in
        BYTE keys_circleRight : 1;
        BYTE keys_aim : 1;					// hydra auto aim or on foot aim
        BYTE keys_circleLeft : 1;
        BYTE keys_landingGear__lookback : 1;
        BYTE keys_unknown__walkSlow : 1;
        BYTE keys_specialCtrlUp : 1;
        BYTE keys_specialCtrlDown : 1;
        BYTE keys_specialCtrlLeft : 1;
        BYTE keys_specialCtrlRight : 1;
        BYTE keys__unused : 1;
    };
    
    struct SFL_OnFootData
    {
        WORD					sLeftRightKeys;
        WORD					sUpDownKeys;
        union
        {
            WORD				sKeys;
            struct SFL_SAMPKeys	stSampKeys;
        };
        float					fPosition[3];
        float					fQuaternion[4];
        BYTE					byteHealth;
        BYTE					byteArmor;
        BYTE					byteCurrentWeapon;
        BYTE					byteSpecialAction;
        float					fMoveSpeed[3];
        float					fSurfingOffsets[3];
        WORD					sSurfingVehicleID;
        short					sCurrentAnimationID;
        short					sAnimFlags;
    };
    
    struct SFL_InCarData
    {
        WORD					sVehicleID;
        WORD					sLeftRightKeys;
        WORD					sUpDownKeys;
        union
        {
            WORD				sKeys;
            struct SFL_SAMPKeys	stSampKeys;
        };
        float					fQuaternion[4];
        float					fPosition[3];
        float					fMoveSpeed[3];
        float					fVehicleHealth;
        BYTE					bytePlayerHealth;
        BYTE					byteArmor;
        BYTE					byteCurrentWeapon;
        BYTE					byteSiren;
        BYTE					byteLandingGearState;
        WORD					sTrailerID;
        union
        {
            WORD				HydraThrustAngle[2];	//nearly same value
            float				fTrainSpeed;
        };
    };
    
    struct SFL_AimData
    {
        BYTE					byteCamMode;
        float					vecAimf1[3];
        float					vecAimPos[3];
        float					fAimZ;
        BYTE					byteCamExtZoom : 6;		// 0-63 normalized
        BYTE					byteWeaponState : 2;	// see eWeaponState
        BYTE					bUnk;
    };
    
    struct SFL_TrailerData
    {
        WORD					sTrailerID;
        float					fPosition[3];
        float					fQuaternion[4];
        float					fSpeed[3];
        float					fSpin[3];
    };
    
    struct SFL_PassengerData
    {
        WORD					sVehicleID;
        BYTE					byteSeatID;
        BYTE					byteCurrentWeapon;
        BYTE					byteHealth;
        BYTE					byteArmor;
        WORD					sLeftRightKeys;
        WORD					sUpDownKeys;
        union
        {
            WORD				sKeys;
            struct SFL_SAMPKeys	stSampKeys;
        };
        float					fPosition[3];
    };
    
    struct SFL_DamageData
    {
        WORD					sVehicleID_lastDamageProcessed;
        int						iBumperDamage;
        int						iDoorDamage;
        BYTE					byteLightDamage;
        BYTE					byteWheelDamage;
    };
    
    struct SFL_SurfData
    {
        int						iIsSurfing;
        float					fSurfPosition[3];
        int						iUnk0;
        WORD					sSurfingVehicleID;
        DWORD					ulSurfTick;
        struct SFL_SAMPVehicle	*pSurfingVehicle;
        int						iUnk1;
        int						iSurfMode;	//0 = not surfing, 1 = moving (unstable surf), 2 = fixed on vehicle
    };
    
    struct SFL_UnoccupiedData
    {
        int16_t					sVehicleID;
        BYTE					byteSeatID;
        float					fRoll[3];
        float					fDirection[3];
        float					fPosition[3];
        float					fMoveSpeed[3];
        float					fTurnSpeed[3];
        float					fHealth;
    };
    
    struct SFL_BulletData
    {
        BYTE					byteType;
        WORD					sTargetID;
        float					fOrigin[3];
        float					fTarget[3];
        float					fCenter[3];
        BYTE					byteWeaponID;
    };
    
    struct SFL_SpectatorData
    {
        WORD					sLeftRightKeys;
        WORD					sUpDownKeys;
        union
        {
            WORD				sKeys;
            struct SFL_SAMPKeys	stSampKeys;
        };
        float					fPosition[3];
    };
    
    struct SFL_StatsData
    {
        int						iMoney;
        int						iAmmo;
    };
    
    struct SFL_HeadSync
    {
        float					fHeadSync[3];
        int						iHeadSyncUpdateTick;
        int						iHeadSyncLookTick;
    };
    
    struct SFL_LocalPlayer
    {
        struct SFL_SAMPPed		*pSAMP_Actor;
        WORD					sCurrentAnimID;
        WORD					sAnimFlags;
        DWORD					ulUnk0;
        int						iIsActive;
        int						iIsWasted;
        WORD					sCurrentVehicleID;
        WORD					sLastVehicleID;
        struct SFL_OnFootData		onFootData;
        struct SFL_PassengerData	passengerData;
        struct SFL_TrailerData	trailerData;
        struct SFL_InCarData		inCarData;
        struct SFL_AimData		aimData;
        BYTE					byteTeamID;
        int						iSpawnSkin;
        BYTE					byteUnk1;
        float					fSpawnPos[3];
        float					fSpawnRot;
        int						iSpawnWeapon[3];
        int						iSpawnAmmo[3];
        int						iIsActorAlive;
        int						iSpawnClassLoaded;
        DWORD					ulSpawnSelectionTick;
        DWORD					ulSpawnSelectionStart;
        int						iIsSpectating;
        BYTE					byteTeamID2;
        WORD					usUnk2;
        DWORD					ulSendTick;
        DWORD					ulSpectateTick;
        DWORD					ulAimTick;
        DWORD					ulStatsUpdateTick;
        DWORD					ulWeapUpdateTick;
        WORD					sAimingAtPid;
        WORD					usUnk3;
        BYTE					byteCurrentWeapon;
        BYTE					byteWeaponInventory[13];
        int						iWeaponAmmo[13];
        int						iPassengerDriveBy;
        BYTE					byteCurrentInterior;
        int						iIsInRCVehicle;
        WORD					sTargetObjectID;
        WORD					sTargetVehicleID;
        WORD					sTargetPlayerID;
        struct SFL_HeadSync		headSyncData;
        DWORD					ulHeadSyncTick;
        BYTE					byteSpace3[260];
        struct SFL_SurfData		surfData;
        int						iClassSelectionOnDeath;
        int						iSpawnClassID;
        int						iRequestToSpawn;
        int						iIsInSpawnScreen;
        DWORD					ulUnk4;
        BYTE					byteSpectateMode;		// 3 = vehicle, 4 = player, side = 14, fixed = 15
        BYTE					byteSpectateType;		// 0 = none, 1 = player, 2 = vehicle
        int						iSpectateID;
        int						iInitiatedSpectating;
        struct SFL_DamageData		vehicleDamageData;
    };
    
    struct SFL_RemotePlayerData
    {
        struct SFL_SAMPPed		*pSAMP_Actor;
        struct SFL_SAMPVehicle	*pSAMP_Vehicle;
        BYTE					byteTeamID;
        BYTE					bytePlayerState;
        BYTE					byteSeatID;
        DWORD					ulUnk3;
        int						iPassengerDriveBy;
        void					*pUnk0;
        BYTE					byteUnk1[60];
        float					fSomething[3];
        float					fVehicleRoll[4];
        DWORD					ulUnk2[3];
        float					fOnFootPos[3];
        float					fOnFootMoveSpeed[3];
        float					fVehiclePosition[3];
        float					fVehicleMoveSpeed[3];
        WORD					sPlayerID;
        WORD					sVehicleID;
        DWORD					ulUnk5;
        int						iShowNameTag;
        int						iHasJetPack;
        BYTE					byteSpecialAction;
        DWORD					ulUnk4[3];
        struct SFL_OnFootData	onFootData;
        struct SFL_InCarData	inCarData;
        struct SFL_TrailerData	trailerData;
        struct SFL_PassengerData	passengerData;
        struct SFL_AimData		aimData;
        float					fActorArmor;
        float					fActorHealth;
        DWORD					ulUnk10;
        BYTE					byteUnk9;
        DWORD					dwTick;
        DWORD					dwLastStreamedInTick;	// is 0 when currently streamed in
        DWORD					ulUnk7;
        int						iAFKState;
        struct SFL_HeadSync		headSyncData;
        int						iGlobalMarkerLoaded;
        int						iGlobalMarkerLocation[3];
        DWORD					ulGlobalMarker_GTAID;
    };
    
    struct SFL_RemotePlayer
    {
        SFL_RemotePlayerData		*pPlayerData;
        int						iIsNPC;
        void					*pVTBL_txtHandler;
        stdstring				strPlayerName;
        int						iScore;
        int						iPing;
    };
    
    struct SFL_SAMPEntity
    {
        void					*pVTBL;
        BYTE					byteUnk0[60]; // game CEntity object maybe. always empty.
        void					*pGTAEntity;
        DWORD					ulGTAEntityHandle;
    };
    
    struct SFL_SAMPPed
    {
        SFL_SAMPEntity			actor_info;
        int						usingCellPhone;
        BYTE					byteUnk0[600];
        struct actor_info		*pGTA_Ped;
        BYTE					byteUnk1[22];
        BYTE					byteKeysId;
        WORD					ulGTA_UrinateParticle_ID;
        int						DrinkingOrSmoking;
        int						object_in_hand;
        int						drunkLevel;
        BYTE					byteUnk2[5];
        int						isDancing;
        int						danceStyle;
        int						danceMove;
        BYTE					byteUnk3[20];
        int						isUrinating;
    };
    
    struct SFL_VehiclePool
    {
        int						iVehicleCount;
        void					*pUnk0;
        BYTE					byteSpace1[0x112C];
        struct SFL_SAMPVehicle	*pSAMP_Vehicle[SAMP_MAX_VEHICLES];
        int						iIsListed[SAMP_MAX_VEHICLES];
        struct SFL_SAMPVehicle	*pGTA_Vehicle[SAMP_MAX_VEHICLES];
        BYTE					byteSpace2[SAMP_MAX_VEHICLES * 6];
        DWORD					ulShit[SAMP_MAX_VEHICLES];
        int						iIsListed2[SAMP_MAX_VEHICLES];
        DWORD					byteSpace3[SAMP_MAX_VEHICLES * 2];
        float					fSpawnPos[SAMP_MAX_VEHICLES][3];
        int						iInitiated;
    };
    
    struct SFL_SAMPVehicle
    {
        SFL_SAMPEntity			vehicle_info;
        DWORD					bUnk0;
        struct vehicle_info		*pGTA_Vehicle;
        BYTE					byteUnk1[8];
        int						bIsMotorOn;
        int						iIsLightsOn;
        int						iIsLocked;
        BYTE					byteIsObjective;
        int						iObjectiveBlipCreated;
        BYTE					byteUnk2[16];
        BYTE					byteColor[2];
        int						iColorSync;
        int						iColor_something;
    };
    
    struct SFL_Object
    {
        SFL_SAMPEntity			object_info;
        BYTE					byteUnk0[2];
        DWORD					ulUnk1;
        int						iModel;
        WORD					byteUnk2;
        float					fDrawDistance;
        float					fUnk;
        float					fPos[3];
        BYTE					byteUnk3[68];
        BYTE					byteUnk4;
        float					fRot[3];
    };
    
    struct SFL_ObjectPool
    {
        int						iObjectCount;
        int						iIsListed[SAMP_MAX_OBJECTS];
        struct SFL_Object			*object[SAMP_MAX_OBJECTS];
    };
    
    struct SFL_Gangzone
    {
        float					fPosition[4];
        DWORD					dwColor;
        DWORD					dwAltColor;
    };
    
    struct SFL_GangzonePool
    {
        struct SFL_Gangzone		*pGangzone[SAMP_MAX_GANGZONES];
        int						iIsListed[SAMP_MAX_GANGZONES];
    };
    
    struct SFL_TextLabel
    {
        PCHAR					pText;
        DWORD					color;
        float					fPosition[3];
        float					fMaxViewDistance;
        BYTE					byteShowBehindWalls;
        WORD					sAttachedToPlayerID;
        WORD					sAttachedToVehicleID;
    };
    
    struct SFL_TextLabelPool
    {
        struct SFL_TextLabel		textLabel[SAMP_MAX_3DTEXTS];
        int						iIsListed[SAMP_MAX_3DTEXTS];
    };
    
    struct SFL_ChatEntry
    {
        DWORD					SystemTime;
        char					szPrefix[28];
        char					szText[144];
        BYTE					unknown[64];
        int						iType;			// 2 - text + prefix, 4 - text (server msg), 8 - text (debug)
        DWORD					clTextColor;
        DWORD					clPrefixColor;	// or textOnly colour
    };
    
    struct SFL_FontRenderer
    {
        ID3DXFont				*m_pChatFont;
        ID3DXFont				*m_pLittleFont;
        ID3DXFont				*m_pChatShadowFont;
        ID3DXFont				*m_pLittleShadowFont;
        ID3DXFont				*m_pCarNumberFont;
        void 					*m_pTempSprite;
        void					*m_pD3DDevice;
        PCHAR					m_pszTextBuffer;
    };
    
    struct SFL_ChatInfo
    {
        int						pagesize;
        PCHAR					pLastMsgText;
        int						iChatWindowMode;
        BYTE					bTimestamps;
        DWORD					m_iLogFileExist;
        char					logFilePathChatLog[260 + 1];
        void					*pGameUI; // CDXUTDialog
        void					*pEditBackground; // CDXUTEditBox
        void					*pDXUTScrollBar;
        D3DCOLOR				clTextColor;
        D3DCOLOR				clInfoColor;
        D3DCOLOR				clDebugColor;
        DWORD					m_lChatWindowBottom;
        struct SFL_ChatEntry	chatEntry[100];
        SFL_FontRenderer		*m_pFontRenderer;
        void					*m_pChatTextSprite;
        void					*m_pSprite;
        void					*m_pD3DDevice;
        int						m_iRenderMode; // 0 - Direct Mode (slow), 1 - Normal mode
        void					*pID3DXRenderToSurface;
        void					*m_pTexture;
        void					*pSurface;
        void					*pD3DDisplayMode;
        int						iUnk1[3];
        int						iUnk2; // smth related to drawing in direct mode
        int						m_iRedraw;
        int						m_nPrevScrollBarPosition;
        int						m_iFontSizeY;
        int						m_iTimestampWidth;
    };
    
    struct SFL_InputBox
    {
        void					*pUnknown;
        BYTE					bIsChatboxOpen;
        BYTE					bIsMouseInChatbox;
        BYTE					bMouseClick_related;
        BYTE					unk;
        DWORD					dwPosChatInput[2];
        BYTE					unk2[263];
        int						iCursorPosition;
        BYTE					unk3;
        int						iMarkedText_startPos; // Highlighted text between this and iCursorPosition
        BYTE					unk4[20];
        int						iMouseLeftButton;
    };
    
    struct SFL_InputInfo
    {
        void					*pD3DDevice;
        void					*pDXUTDialog;
        SFL_InputBox				*pDXUTEditBox;
        CMDPROC					pCMDs[SAMP_MAX_CLIENTCMDS];
        char					szCMDNames[SAMP_MAX_CLIENTCMDS][33];
        int						iCMDCount;
        int						iInputEnabled;
        char					szInputBuffer[129];
        char					szRecallBufffer[10][129];
        char					szCurrentBuffer[129];
        int						iCurrentRecall;
        int						iTotalRecalls;
        CMDPROC					pszDefaultCMD;
    };
    
    struct SFL_KillEntry
    {
        char					szKiller[25];
        char					szVictim[25];
        D3DCOLOR				clKillerColor;
        D3DCOLOR				clVictimColor;
        BYTE					byteType;
    };
    
    struct SFL_KillInfo
    {
        int						iEnabled;
        struct SFL_KillEntry	killEntry[5];
        int 					iLongestNickLength;
          int 					iOffsetX;
          int 					iOffsetY;
        ID3DXFont				*pD3DFont;
        ID3DXFont				*pWeaponFont1;
        ID3DXFont				*pWeaponFont2;
        void					*pSprite;
        void					*pD3DDevice;
        int 					iAuxFontInited;
          ID3DXFont 				*pAuxFont1;
          ID3DXFont 				*pAuxFont2;
    };
    
    struct SFL_ChatPlayer
    {
        int						iCreated;
        char					probablyTheText[256];
        DWORD					dwTickCreated;
        DWORD					dwLiveLength;
        DWORD					dwColor;
        float					fDrawDistance;
        DWORD					dwUnknown;
    };
    
    struct SFL_Audio
    {
        int						iSoundState; // 0 - Finished, 1 - Loaded, 2 - Playing
    };
    
    struct SFL_Camera
    {
        void*				pEntity; // attached entity
        void*				matrix;
    };
    
    struct SFL_GameInfo
    {
        SFL_Audio*				pAudio;
        SFL_Camera*				pCamera;
        SFL_SAMPPed*			pLocalPlayerPed;
        float					fCheckpointPos[3];
        float					fCheckpointExtent[3];
        int						bCheckpointsEnabled;
    
        // not tested
        DWORD					dwCheckpointMarker;
        float					fRaceCheckpointPos[3];
        float					fRaceCheckpointNext[3];
        float					m_fRaceCheckpointSize;
        BYTE					byteRaceType;
    
        int						bRaceCheckpointsEnabled;
    
        DWORD					dwRaceCheckpointMarker;
        DWORD					dwRaceCheckpointHandle;
    
        int						iCursorMode;
        DWORD					ulUnk1;
        int						bClockEnabled;
        DWORD					ulUnk2;
        int						bHeadMove;
        DWORD					ulFpsLimit;
        BYTE					byteUnk3;
        BYTE					byteVehicleModels[212];
    };
    
    struct SFL_ScoreboardInfo
    {
        int						iIsEnabled;
        int						iPlayersCount;
        float					fTextOffset[2];
        float					fScalar;
        float					fSize[2];
        float					fUnk0[5];
        void					*pDirectDevice;
        void					*pDialog;
        void 					*pList;
        int						iOffset;		// ?
        int						iIsSorted;		// ?
    };
    
    struct SFL_ActorPool
    {
        int						iLastActorID;
        SFL_SAMPEntity			*pActor[SAMP_MAX_ACTORS]; // ?
        int						iIsListed[SAMP_MAX_ACTORS];
        struct SFL_SAMPPed		*pGTAPed[SAMP_MAX_ACTORS];
        DWORD					ulUnk0[SAMP_MAX_ACTORS];
        DWORD					ulUnk1[SAMP_MAX_ACTORS];
    };
    
    struct SFL_ChatBubbleInfo
    {
        struct SFL_ChatPlayer	chatBubble[SAMP_MAX_PLAYERS];
    };
    
    struct SFL_StreamedOutPlayerInfo
    {
        bool					iIsListed[SAMP_MAX_PLAYERS];
        float					fPlayerPos[SAMP_MAX_PLAYERS][3];
    };
]]