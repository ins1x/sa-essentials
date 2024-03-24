--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.require 'matrix'
shared.require 'CEntity'
shared.require 'CPlaceable'
shared.require 'CCam'
shared.require 'CCamPathSplines'
shared.require 'CQueuedMode'
shared.require 'vector3d'

shared.ffi.cdef[[
	typedef struct CCamera : CPlaceable
	{
		bool             bAboveGroundTrainNodesLoaded;
    bool             bBelowGroundTrainNodesLoaded;
    bool             bCamDirectlyBehind;
    bool             bCamDirectlyInFront;
    bool             bCameraJustRestored;
    bool             bcutsceneFinished;
    bool             bCullZoneChecksOn;
    bool             bFirstPersonBeingUsed;
    bool             bJustJumpedOutOf1stPersonBecauseOfTarget;
    bool             bIdleOn;
    bool             bInATunnelAndABigVehicle;
    bool             bInitialNodeFound;
    bool             bInitialNoNodeStaticsSet;
    bool             bIgnoreFadingStuffForMusic;
    bool             bPlayerIsInGarage;
    bool             bPlayerWasOnBike;
    bool             bJustCameOutOfGarage;
    bool             bJustInitalised;
    bool             bJust_Switched;
    bool             bLookingAtPlayer;
    bool             bLookingAtVector;
    bool             bMoveCamToAvoidGeom;
    bool             bObbeCinematicPedCamOn;
    bool             bObbeCinematicCarCamOn;
    bool             bRestoreByJumpCut;
    bool             bUseNearClipScript;
    bool             bStartInterScript;
    bool             bStartingSpline;
    bool             bTargetJustBeenOnTrain;
    bool             bTargetJustCameOffTrain;
    bool             bUseSpecialFovTrain;
    bool             bUseTransitionBeta;
    bool             bUseScriptZoomValuePed;
    bool             bUseScriptZoomValueCar;
    bool             bWaitForInterpolToFinish;
    bool             bItsOkToLookJustAtThePlayer;
    bool             bWantsToSwitchWidescreenOff;
    bool             bWideScreenOn;
    bool             b1rstPersonRunCloseToAWall;
    bool             bHeadBob;
    bool             bVehicleSuspenHigh;
    bool             bEnable1rstPersonCamCntrlsScript;
    bool             bAllow1rstPersonWeaponsCamera;
    bool             bCooperativeCamMode;
    bool             bAllowShootingWith2PlayersInCar;
    bool             bDisableFirstPersonInCar;
    unsigned short   nModeForTwoPlayersSeparateCars;
    unsigned short   nModeForTwoPlayersSameCarShootingAllowed;
    unsigned short   nModeForTwoPlayersSameCarShootingNotAllowed;
    unsigned short   nModeForTwoPlayersNotBothInCar;
    bool             bGarageFixedCamPositionSet;
    bool             bDoingSpecialInterPolation;
    bool             bScriptParametersSetForInterPol;
    bool             bFading;
    bool             bMusicFading;
    bool             bMusicFadedOut;
    bool             bFailedCullZoneTestPreviously;
    bool             bFadeTargetIsSplashScreen;
    bool             bWorldViewerBeingUsed;
    bool             bTransitionJUSTStarted;
    bool             bTransitionState;
    bool             nActiveCam;

    char pad0[2];

    unsigned int     nCamShakeStart;
    unsigned int     nFirstPersonCamLastInputTime;
    unsigned int     nLongestTimeInMill;
    unsigned int     nNumberOfTrainCamNodes;
    unsigned int     nTimeLastChange;
    unsigned int     nTimeWeLeftIdle_StillNoInput;
    unsigned int     nTimeWeEnteredIdle;
    unsigned int     nTimeTransitionStart;
    unsigned int     nTransitionDuration;
    unsigned int     nTransitionDurationTargetCoors;
    unsigned int     nBlurBlue;
    unsigned int     nBlurGreen;
    unsigned int     nBlurRed;
    unsigned int     nBlurType;
    unsigned int     nWorkOutSpeedThisNumFrames;
    unsigned int     nNumFramesSoFar;
    unsigned int     nCurrentTrainCamNode;
    unsigned int     nMotionBlur;
    unsigned int     nMotionBlurAddAlpha;
    unsigned int     nCheckCullZoneThisNumFrames;
    unsigned int     nZoneCullFrameNumWereAt;
    unsigned int     nWhoIsInControlOfTheCamera;
    unsigned int     nCarZoom;
    float            fCarZoomBase;
    float            fCarZoomTotal;
    float            fCarZoomSmoothed;
    float            fCarZoomValueScript;
    float            fPedZoom;
    float            fPedZoomBase;
    float            fPedZoomTotal;
    float            fPedZoomSmoothed;
    float            fPedZoomValueScript;
    float            fCamFrontXNorm;
    float            fCamFrontYNorm;
    float            fDistanceToWater;
    float            fHeightOfNearestWater;
    float            fFOVDuringInter;
    float            fLODDistMultiplier;
    float            fGenerationDistMultiplier;
    float            fAlphaSpeedAtStartInter;
    float            fAlphaWhenInterPol;
    float            fAlphaDuringInterPol;
    float            fBetaDuringInterPol;
    float            fBetaSpeedAtStartInter;
    float            fBetaWhenInterPol;
    float            fFOVWhenInterPol;
    float            fFOVSpeedAtStartInter;
    float            fStartingBetaForInterPol;
    float            fStartingAlphaForInterPol;
    float            fPedOrientForBehindOrInFront;
    float            fCameraAverageSpeed;
    float            fCameraSpeedSoFar;
    float            fCamShakeForce;
    float            fFovForTrain;
    float            fFOV_Wide_Screen;
    float            fNearClipScript;
    float            fOldBetaDiff;
    float            fPositionAlongSpline;
    float            fScreenReductionPercentage;
    float            fScreenReductionSpeed;
    float            fAlphaForPlayerAnim1rstPerson;
    float            fOrientation;
    float            fPlayerExhaustion;
    float            fSoundDistUp;
    float            fSoundDistUpAsRead;
    float            fSoundDistUpAsReadOld;
    float            fAvoidTheGeometryProbsTimer;
    unsigned short   nAvoidTheGeometryProbsDirn;

    char pad1[2];

    float            fWideScreenReductionAmount;
    float            fStartingFOVForInterPol;
    CCam             aCams[3];
    void					   *pToGarageWeAreIn;
    void					   *pToGarageWeAreInForHackAvoidFirstPerson;
    CQueuedMode      PlayerMode;
    CQueuedMode      PlayerWeaponMode;
    vector3d          vecPreviousCameraPosition;
    vector3d          vecRealPreviousCameraPosition;
    vector3d          vecAimingTargetCoors;
    vector3d          vecFixedModeVector;
    vector3d          vecFixedModeSource;
    vector3d          vecFixedModeUpOffSet;
    vector3d          vecCutSceneOffset;
    vector3d          vecStartingSourceForInterPol;
    vector3d          vecStartingTargetForInterPol;
    vector3d          vecStartingUpForInterPol;
    vector3d          vecSourceSpeedAtStartInter;
    vector3d          vecTargetSpeedAtStartInter;
    vector3d          vecUpSpeedAtStartInter;
    vector3d          vecSourceWhenInterPol;
    vector3d          vecTargetWhenInterPol;
    vector3d          vecUpWhenInterPol;
    vector3d          vecClearGeometryVec;
    vector3d          vecGameCamPos;
    vector3d          vecSourceDuringInter;
    vector3d          vecTargetDuringInter;
    vector3d          vecUpDuringInter;
    vector3d          vecAttachedCamOffset;
    vector3d          vecAttachedCamLookAt;
    float            fAttachedCamAngle;
    RwCamera        *pRwCamera;
    CEntity   			*pTargetEntity;
    CEntity   			*pAttachedEntity;
    CCamPathSplines  aPathArray[4];
    bool             bMirrorActive;
    bool             bResetOldMatrix;

    char pad2[2];

    matrix          	mCameraMatrix;
    matrix          	mCameraMatrixOld;
    matrix          	mViewMatrix;
    matrix          	mMatInverse;
    matrix          	mMatMirrorInverse;
    matrix          	mMatMirror;
    vector3d          avecFrustumNormals[4];
    vector3d field_B54[4];
    vector3d field_B84[4];
    float field_BB4[4];
    float field_BC4[4];
    vector3d field_BD4;
    int field_BE0;
    int field_BE4;
    int field_BE8;
    int field_BEC;
    int field_BF0;
    int field_BF4;
    int field_BF8;
    float            fFadeAlpha;
    int field_C00;
    float            fFadeDuration;
    int field_C08;
    int field_C0C;
    int field_C10;
    int field_C14;
    int field_C18;
    int field_C1C;
    int field_C20;
    int field_C24;
    int field_C28;
    int field_C2C;
    unsigned short   nFadeInOutFlag;
    short field_C32;
    int field_C34;
    short field_C38;
    short field_C3A;
    short field_C3C;
    short field_C3E;
    unsigned int     nFadeStartTime;
    int field_C44;
    int field_C48;
    int field_C4C;
    int field_C50;
    int field_C54;
    int field_C58;
    unsigned int     nTransverseStartTime;
    unsigned int     nTransverseEndTime;
    vector3d          vecTransverseEndPoint;
    vector3d          vecTransverseStartPoint;
    unsigned char    nTransverseMode;
    char field_C7D;
    char field_C7E;
    char field_C7F;
    vector3d field_C80;
    char field_C8C;
    char field_C8D;
    char field_C8E;
    char field_C8F;
    int field_C90;
    unsigned int     nStartJiggleTime;
    unsigned int     nEndJiggleTime;
    int field_C9C;
    int field_CA0;
    unsigned int     nStartZoomTime;
    unsigned int     nEndZoomTime;
    float            fZoomInFactor;
    float            fZoomOutFactor;
    unsigned char    nZoomMode;
    char field_CB5;
    char field_CB6;
    char field_CB7;
    int field_CB8;
    int field_CBC;
    int field_CC0;
    vector3d field_CC4;
    vector3d field_CD0;
    char field_CDC;
    char field_CDD;
    char field_CDE;
    char field_CDF;
    vector3d field_CE0;
    char field_CEC;
    bool bBlockZoom;
    char field_CEE;
    char field_CEF;
    char field_CF0;
    char field_CF1;
    char field_CF2;
    char field_CF3;
    char field_CF4[80];
    int field_D44;
    int field_D48;
    int field_D4C;
    int field_D50;
    int field_D54;
    int field_D58;
    int field_D5C;
    int field_D60;
    int field_D64;
    int field_D68;
    int field_D6C;
    int field_D70;
    int field_D74;
	} CCamera;
]]

shared.validate_size('CCamera', 0xD78)
