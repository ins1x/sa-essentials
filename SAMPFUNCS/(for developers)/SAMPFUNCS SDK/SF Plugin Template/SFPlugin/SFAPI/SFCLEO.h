#ifndef SFCLEO_H__
#define SFCLEO_H__

#define CLEO_VERSION		0x0401011E
#define CLEO_VERSIONTEXT	"4.1.1.30"

//result of CLEO_GetGameVersion()
#define GV_US10				0		//1.0 us
#define GV_US11				1		//1.01 us - not supported
#define GV_EU10				2		//1.0 eu
#define GV_EU11				3		//1.01 eu
#define GV_UNK				- 1		//any other
#define SCRIPT_MAX_STRING	256
#define SCRIPT_MAX_VARS		32

// opcode result codes
#define OR_CONTINUE		0
#define OR_INTERRUPT	1
#define OR_RETURN		2
#define OR_RETURN_FALSE 3
#define OR_RETURN_TRUE	4

typedef unsigned short opcode_t, scriptvar_t;
typedef unsigned long scriptvalue_t;
typedef struct CScriptThread CScriptThread;
typedef int OpcodeResult;
typedef OpcodeResult (__stdcall *_pOpcodeHandler) (CScriptThread *);

typedef union
{
	DWORD	dwParam;
	int		nParam;
	float	fParam;
	void	*pParam;
	char	*szParam;
} SCRIPT_VAR;

#pragma pack(push, 1)
struct SAMPFUNCS_API CScriptThread
{
	CScriptThread	*next;			//next script in queue
	CScriptThread	*prev;			//previous script in queue
	char			threadName[8];	//name of thread, given by 03A4 opcode
	BYTE			*baseIp;		//pointer to begin of script in memory
	BYTE			*ip;			//current index pointer
	BYTE			*stack[8];		//return stack for 0050, 0051
	WORD			sp;		//current item in stack
	WORD			_f3A;	//padding
	SCRIPT_VAR		tls[SCRIPT_MAX_VARS];	//thread's local variables
	DWORD			timer[2];
	BYTE			isActive;			//is current thread active
	char			condResult;			//condition result (true or false)
	char			missionCleanupFlag; //clean mission
	char			external;			//is thread external (from script.img)
	BYTE			_fC8;			//unknown
	BYTE			_fC9;			//unknown
	BYTE			_fCA;			//unknown
	BYTE			_fCB;			//unknown
	DWORD			wakeTime;		//time, when script starts again after 0001 opcode
	WORD			logicalOp;		//00D6 parameter
	BYTE			notFlag;		//opcode & 0x8000 != 0
	BYTE			wbCheckEnabled; //wasted_or_busted check flag
	BYTE			wastedOrBusted; //is player wasted or busted
	BYTE			_fD5;			//unknown
	WORD			_fD6;			//unknown
	DWORD			sceneSkip;		//scene skip label ptr
	BYTE			missionFlag;	//is mission thread
	BYTE			_fDD[3];		//padding

	unsigned int	GetInt( void );
	float			GetFloat( void );
	void			SetInt( unsigned int value );
	void			SetFloat( float value );
	char			*ReadString( char *buf = nullptr, size_t size = 0 );
	void			WriteString( char *str );
	int				FormatString( char *str, size_t len, const char *format );
	void			SetCondResult( bool result );
	void			SkipParams( size_t count );
	void			JumpAtLabel( unsigned int offset );
	int				GetOperandType( void );
	bool			IsParamConstInt( void );
	void			GetParams( size_t count );
	void			SetParams( size_t count );
	void			SkipUnusedParams( void );
	std::string		GetThreadName( void );
	std::vector<SCRIPT_VAR> RetreiveUnreadParams(void);
	void			Reset(void);
};
#pragma pack(pop)

class SAMPFUNCS_API SFCLEO
{
	SFPluginInfo* m_PluginInfo;
	
public:		
	SFCLEO( SFPluginInfo* pluginInfo );
	SFPluginInfo* getPluginInfo( void );

	void registerNewOpcode( WORD wOpcodeID, _pOpcodeHandler opcodeCallback );
	bool callOpcode( const char *fmt, ... );
	bool callOpcode( CScriptThread *thread, const char *fmt, ... );

	void SetLocalVar( scriptvar_t idx, scriptvalue_t value );
	void SetLocalVar( scriptvar_t idx, float value );
	scriptvalue_t GetLocalVar( scriptvar_t idx );
	bool GetCondResult( void );
	void SetGlobalVar( scriptvar_t idx, scriptvalue_t value );
	scriptvalue_t GetGlobalVar( scriptvar_t idx );

	OpcodeResult executeThreadTillReturn(CScriptThread* thread);
	OpcodeResult executeThreadOnce(CScriptThread* thread);
};

#endif // SFCLEO_H__
