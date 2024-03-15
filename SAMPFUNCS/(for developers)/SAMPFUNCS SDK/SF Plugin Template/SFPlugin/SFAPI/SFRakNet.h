#ifndef SFRAKNET_H__
#define SFRAKNET_H__

#include <assert.h>

/// Given a number of bits, return how many bytes are needed to represent that.
#define BITS_TO_BYTES(x) (((x)+7)>>3)
#define BYTES_TO_BITS(x) ((x)<<3)
#define BITSTREAM_STACK_ALLOCATION_SIZE 256

#ifdef _MSC_VER
#pragma warning( disable : 4800 ) // warning C4100: <variable name> : unreferenced formal parameter
#endif

typedef unsigned int RakNetTime;
typedef long long RakNetTimeNS;
typedef unsigned char RPCIndex;
const int UNDEFINED_RPC_INDEX = ( ( RPCIndex ) -1 );

enum RPCEnumeration
{
	RPC_ClickPlayer = 23,
	RPC_ClientJoin = 25,
	RPC_EnterVehicle = 26,
	RPC_EnterEditObject = 27,
	RPC_ScriptCash = 31,
	RPC_ServerCommand = 50,
	RPC_Spawn = 52,
	RPC_Death = 53,
	RPC_NPCJoin = 54,
	RPC_DialogResponse = 62,
	RPC_ClickTextDraw = 83,
	RPC_ScmEvent = 96,
	RPC_WeaponPickupDestroy = 97,
	RPC_Chat = 101,
	RPC_SrvNetStats = 102,
	RPC_ClientCheck = 103,
	RPC_DamageVehicle = 106,
	RPC_GiveTakeDamage = 115,
	RPC_EditAttachedObject = 116,
	RPC_EditObject = 117,
	RPC_SetInteriorId = 118,
	RPC_MapMarker = 119,
	RPC_RequestClass = 128,
	RPC_RequestSpawn = 129,
	RPC_PickedUpPickup = 131,
	RPC_MenuSelect = 132,
	RPC_VehicleDestroyed = 136,
	RPC_MenuQuit = 140,
	RPC_ExitVehicle = 154,
	RPC_UpdateScoresPingsIPs = 155
};

enum ScriptRPCEnumeration
{
	RPC_ScrSetPlayerName = 11,
	RPC_ScrSetPlayerPos = 12,
	RPC_ScrSetPlayerPosFindZ = 13,
	RPC_ScrSetPlayerHealth = 14,
	RPC_ScrTogglePlayerControllable = 15,
	RPC_ScrPlaySound = 16,
	RPC_ScrSetPlayerWorldBounds = 17,
	RPC_ScrGivePlayerMoney = 18,
	RPC_ScrSetPlayerFacingAngle = 19,
	RPC_ScrResetPlayerMoney = 20,
	RPC_ScrResetPlayerWeapons = 21,
	RPC_ScrGivePlayerWeapon = 22,
	RPC_ScrSetVehicleParamsEx = 24,
	RPC_ScrCancelEdit = 28,
	RPC_ScrSetPlayerTime = 29,
	RPC_ScrToggleClock = 30,
	RPC_ScrWorldPlayerAdd = 32,
	RPC_ScrSetPlayerShopName = 33,
	RPC_ScrSetPlayerSkillLevel = 34,
	RPC_ScrSetPlayerDrunkLevel = 35,
	RPC_ScrCreate3DTextLabel = 36,
	RPC_ScrDisableCheckpoint = 37,
	RPC_ScrSetRaceCheckpoint = 38,
	RPC_ScrDisableRaceCheckpoint = 39,
	RPC_ScrGameModeRestart = 40,
	RPC_ScrPlayAudioStream = 41,
	RPC_ScrStopAudioStream = 42,
	RPC_ScrRemoveBuildingForPlayer = 43,
	RPC_ScrCreateObject = 44,
	RPC_ScrSetObjectPos = 45,
	RPC_ScrSetObjectRot = 46,
	RPC_ScrDestroyObject = 47,
	RPC_ScrDeathMessage = 55,
	RPC_ScrSetPlayerMapIcon = 56,
	RPC_ScrRemoveVehicleComponent = 57,
	RPC_ScrUpdate3DTextLabel = 58,
	RPC_ScrChatBubble = 59,
	RPC_ScrSomeupdate = 60,
	RPC_ScrShowDialog = 61,
	RPC_ScrDestroyPickup = 63,
	RPC_ScrLinkVehicleToInterior = 65,
	RPC_ScrSetPlayerArmour = 66,
	RPC_ScrSetPlayerArmedWeapon = 67,
	RPC_ScrSetSpawnInfo = 68,
	RPC_ScrSetPlayerTeam = 69,
	RPC_ScrPutPlayerInVehicle = 70,
	RPC_ScrRemovePlayerFromVehicle = 71,
	RPC_ScrSetPlayerColor = 72,
	RPC_ScrDisplayGameText = 73,
	RPC_ScrForceClassSelection = 74,
	RPC_ScrAttachObjectToPlayer = 75,
	RPC_ScrInitMenu = 76,
	RPC_ScrShowMenu = 77,
	RPC_ScrHideMenu = 78,
	RPC_ScrCreateExplosion = 79,
	RPC_ScrShowPlayerNameTagForPlayer = 80,
	RPC_ScrAttachCameraToObject = 81,
	RPC_ScrInterpolateCamera = 82,
	RPC_ScrSetObjectMaterial = 84,
	RPC_ScrGangZoneStopFlash = 85,
	RPC_ScrApplyAnimation = 86,
	RPC_ScrClearAnimations = 87,
	RPC_ScrSetPlayerSpecialAction = 88,
	RPC_ScrSetPlayerFightingStyle = 89,
	RPC_ScrSetPlayerVelocity = 90,
	RPC_ScrSetVehicleVelocity = 91,
	RPC_ScrClientMessage = 93,
	RPC_ScrSetWorldTime = 94,
	RPC_ScrCreatePickup = 95,
	RPC_ScrMoveObject = 99,
	RPC_ScrEnableStuntBonusForPlayer = 104,
	RPC_ScrTextDrawSetString = 105,
	RPC_ScrSetCheckpoint = 107,
	RPC_ScrGangZoneCreate = 108,
	RPC_ScrPlayCrimeReport = 112,
	RPC_ScrSetPlayerAttachedObject = 113,
	RPC_ScrGangZoneDestroy = 120,
	RPC_ScrGangZoneFlash = 121,
	RPC_ScrStopObject = 122,
	RPC_ScrSetNumberPlate = 123,
	RPC_ScrTogglePlayerSpectating = 124,
	RPC_ScrPlayerSpectatePlayer = 126,
	RPC_ScrPlayerSpectateVehicle = 127,
	RPC_ScrSetPlayerWantedLevel = 133,
	RPC_ScrShowTextDraw = 134,
	RPC_ScrTextDrawHideForPlayer = 135,
	RPC_ScrServerJoin = 137,
	RPC_ScrServerQuit = 138,
	RPC_ScrInitGame = 139,
	RPC_ScrRemovePlayerMapIcon = 144,
	RPC_ScrSetPlayerAmmo = 145,
	RPC_ScrSetGravity = 146,
	RPC_ScrSetVehicleHealth = 147,
	RPC_ScrAttachTrailerToVehicle = 148,
	RPC_ScrDetachTrailerFromVehicle = 149,
	RPC_ScrSetWeather = 152,
	RPC_ScrSetPlayerSkin = 153,
	RPC_ScrSetPlayerInterior = 156,
	RPC_ScrSetPlayerCameraPos = 157,
	RPC_ScrSetPlayerCameraLookAt = 158,
	RPC_ScrSetVehiclePos = 159,
	RPC_ScrSetVehicleZAngle = 160,
	RPC_ScrSetVehicleParamsForPlayer = 161,
	RPC_ScrSetCameraBehindPlayer = 162,
	RPC_ScrWorldPlayerRemove = 163,
	RPC_ScrWorldVehicleAdd = 164,
	RPC_ScrWorldVehicleRemove = 165,
	RPC_ScrWorldPlayerDeath = 166
};

enum PacketEnumeration
{
	ID_INTERNAL_PING = 6,
	ID_PING,
	ID_PING_OPEN_CONNECTIONS,
	ID_CONNECTED_PONG,
	ID_REQUEST_STATIC_DATA,
	ID_CONNECTION_REQUEST,
	ID_AUTH_KEY,
	ID_BROADCAST_PINGS = 14,
	ID_SECURED_CONNECTION_RESPONSE,
	ID_SECURED_CONNECTION_CONFIRMATION,
	ID_RPC_MAPPING,
	ID_SET_RANDOM_NUMBER_SEED = 19,
	ID_RPC,
	ID_RPC_REPLY,
	ID_DETECT_LOST_CONNECTIONS = 23,
	ID_OPEN_CONNECTION_REQUEST,
	ID_OPEN_CONNECTION_REPLY,
	ID_CONNECTION_COOKIE,
	ID_RSA_PUBLIC_KEY_MISMATCH = 28,
	ID_CONNECTION_ATTEMPT_FAILED,
	ID_NEW_INCOMING_CONNECTION,
	ID_NO_FREE_INCOMING_CONNECTIONS,
	ID_DISCONNECTION_NOTIFICATION,
	ID_CONNECTION_LOST,
	ID_CONNECTION_REQUEST_ACCEPTED,
	ID_INITIALIZE_ENCRYPTION,
	ID_CONNECTION_BANNED,
	ID_INVALID_PASSWORD,
	ID_MODIFIED_PACKET,
	ID_PONG,
	ID_TIMESTAMP,
	ID_RECEIVED_STATIC_DATA,
	ID_REMOTE_DISCONNECTION_NOTIFICATION,
	ID_REMOTE_CONNECTION_LOST,
	ID_REMOTE_NEW_INCOMING_CONNECTION,
	ID_REMOTE_EXISTING_CONNECTION,
	ID_REMOTE_STATIC_DATA,
	ID_ADVERTISE_SYSTEM = 56,

	ID_VEHICLE_SYNC = 200,
	ID_RCON_COMMAND,
	ID_RCON_RESPONCE,
	ID_AIM_SYNC,
	ID_WEAPONS_UPDATE,
	ID_STATS_UPDATE,
	ID_BULLET_SYNC,
	ID_PLAYER_SYNC,
	ID_MARKERS_SYNC,
	ID_UNOCCUPIED_SYNC,
	ID_TRAILER_SYNC,
	ID_PASSENGER_SYNC,
	ID_SPECTATOR_SYNC,
};

/// These enumerations are used to describe when packets are delivered.
enum PacketPriority
{
	SYSTEM_PRIORITY,   /// \internal Used by RakNet to send above-high priority messages.
	HIGH_PRIORITY,   /// High priority messages are send before medium priority messages.
	MEDIUM_PRIORITY,   /// Medium priority messages are send before low priority messages.
	LOW_PRIORITY,   /// Low priority messages are only sent when no other messages are waiting.
	NUMBER_OF_PRIORITIES
};

/// These enumerations are used to describe how packets are delivered.
/// \note  Note to self: I write this with 3 bits in the stream.  If I add more remember to change that
enum PacketReliability
{
	UNRELIABLE = 6,   /// Same as regular UDP, except that it will also discard duplicate datagrams.  RakNet adds (6 to 17) + 21 bits of overhead, 16 of which is used to detect duplicate packets and 6 to 17 of which is used for message length.
	UNRELIABLE_SEQUENCED,  /// Regular UDP with a sequence counter.  Out of order messages will be discarded.  This adds an additional 13 bits on top what is used for UNRELIABLE.
	RELIABLE,   /// The message is sent reliably, but not necessarily in any order.  Same overhead as UNRELIABLE.
	RELIABLE_ORDERED,   /// This message is reliable and will arrive in the order you sent it.  Messages will be delayed while waiting for out of order messages.  Same overhead as UNRELIABLE_SEQUENCED.
	RELIABLE_SEQUENCED /// This message is reliable and will arrive in the sequence you sent it.  Out or order messages will be dropped.  Same overhead as UNRELIABLE_SEQUENCED.
};

/// This class allows you to write and read native types as a string of bits.  BitStream is used extensively throughout RakNet and is designed to be used by users as well.	
/// \sa BitStreamSample.txt
class SAMPFUNCS_API BitStream
{

public:	 
	BitStream();

	BitStream( int initialBytesToAllocate );

	BitStream( unsigned char* _data, unsigned int lengthInBytes, bool _copyData );

	~BitStream();

	void Reset( void );

	template <class templateType>
	bool Serialize(bool writeToBitstream, templateType &var);
	template <class templateType>
	bool SerializeDelta(bool writeToBitstream, templateType &currentValue, templateType lastValue);
	template <class templateType>
	bool SerializeDelta(bool writeToBitstream, templateType &currentValue);
	template <class templateType>
	bool SerializeCompressed(bool writeToBitstream, templateType &var);
	template <class templateType>
	bool SerializeCompressedDelta(bool writeToBitstream, templateType &currentValue, templateType lastValue);
	template <class templateType>
	bool SerializeCompressedDelta(bool writeToBitstream, templateType &currentValue);
	bool Serialize(bool writeToBitstream,  char* input, const int numberOfBytes );
	template <class templateType> // templateType for this function must be a float or double
	bool SerializeNormVector(bool writeToBitstream,  templateType &x, templateType &y, templateType &z );
	template <class templateType> // templateType for this function must be a float or double
	bool SerializeVector(bool writeToBitstream,  templateType &x, templateType &y, templateType &z );
	template <class templateType> // templateType for this function must be a float or double
	bool SerializeNormQuat(bool writeToBitstream,  templateType &w, templateType &x, templateType &y, templateType &z);
	template <class templateType> // templateType for this function must be a float or double
	bool SerializeOrthMatrix(
		bool writeToBitstream,  
		templateType &m00, templateType &m01, templateType &m02,
		templateType &m10, templateType &m11, templateType &m12,
		templateType &m20, templateType &m21, templateType &m22 );
	bool SerializeBits(bool writeToBitstream, unsigned char* input, int numberOfBitsToSerialize, const bool rightAlignedBits = true );
	
	template <class templateType>
	void Write(templateType var)
	{
#ifdef _MSC_VER
#pragma warning(disable:4127)   // conditional expression is constant
#endif
		if (sizeof(var)==1)
			WriteBits( ( unsigned char* ) & var, sizeof( templateType ) * 8, true );
		else
		{
			WriteBits( ( unsigned char* ) & var, sizeof(templateType) * 8, true );
		}
	};

	void Write(bool var);

	template <class templateType>
	void WriteDelta(templateType currentValue, templateType lastValue);
	template <class templateType>
	void WriteDelta(templateType currentValue);
	template <class templateType>
	void WriteCompressed(templateType var);
	template <class templateType>
	void WriteCompressedDelta(templateType currentValue, templateType lastValue);
	template <class templateType>
	void WriteCompressedDelta(templateType currentValue);
	template <class templateType>
	bool Read(templateType &var)
	{
#ifdef _MSC_VER
#pragma warning(disable:4127)   // conditional expression is constant
#endif
		if (sizeof(var)==1)
			return ReadBits( ( unsigned char* ) &var, sizeof(templateType) * 8, true );
		else
		{
			return ReadBits( ( unsigned char* ) & var, sizeof(templateType) * 8, true );
		}
	}
	bool Read(bool &var);
	template <class templateType>
	bool ReadDelta(templateType &var);
	template <class templateType>
	bool ReadCompressed(templateType &var);
	template <class templateType>
	bool ReadCompressedDelta(templateType &var);
	void Write( const char* input, const int numberOfBytes );
	void Write( BitStream *bitStream, int numberOfBits );
	void Write( BitStream *bitStream );
	template <class templateType> // templateType for this function must be a float or double
	void WriteNormVector( templateType x, templateType y, templateType z );
	template <class templateType> // templateType for this function must be a float or double
	void WriteVector( templateType x, templateType y, templateType z );
	template <class templateType> // templateType for this function must be a float or double
	void WriteNormQuat( templateType w, templateType x, templateType y, templateType z);
	template <class templateType> // templateType for this function must be a float or double
	void WriteOrthMatrix( 
		templateType m00, templateType m01, templateType m02,
		templateType m10, templateType m11, templateType m12,
		templateType m20, templateType m21, templateType m22 );
	bool Read( char* output, const int numberOfBytes );
	void ResetReadPointer( void );
	void ResetWritePointer( void );
	void AssertStreamEmpty( void );
	void IgnoreBits( const int numberOfBits );
	void SetWriteOffset( const int offset );
	inline int GetNumberOfBitsUsed( void ) const {return GetWriteOffset();}
	inline int GetWriteOffset( void ) const {return numberOfBitsUsed;}
	inline int GetNumberOfBytesUsed( void ) const {return BITS_TO_BYTES( numberOfBitsUsed );}
	inline int GetReadOffset( void ) const {return readOffset;}
	inline void SetReadOffset( int newReadOffset ) {readOffset=newReadOffset;}
	inline int GetNumberOfUnreadBits( void ) const {return numberOfBitsUsed - readOffset;}
	int CopyData( unsigned char** _data ) const;
	void SetData( unsigned char *input );
	inline unsigned char* GetData( void ) const {return data;}
	void WriteBits( const unsigned char* input,	int numberOfBitsToWrite, const bool rightAlignedBits = true );
	void WriteAlignedBytes( const unsigned char *input,	const int numberOfBytesToWrite );
	bool ReadAlignedBytes( unsigned char *output,	const int numberOfBytesToRead );
	void AlignWriteToByteBoundary( void );
	void AlignReadToByteBoundary( void );
	bool ReadBits( unsigned char *output, int numberOfBitsToRead,	const bool alignBitsToRight = true );
	void Write0( void );
	void Write1( void );
	bool ReadBit( void );
	void AssertCopyData( void );
	void SetNumberOfBitsAllocated( const unsigned int lengthInBits );
	void AddBitsAndReallocate( const int numberOfBitsToWrite );

private:

	void WriteCompressed( const unsigned char* input, const int size, const bool unsignedData );
	bool ReadCompressed( unsigned char* output,	const int size, const bool unsignedData );
	void ReverseBytes(unsigned char *input, unsigned char *output, int length);
	int numberOfBitsUsed;
	int numberOfBitsAllocated;
	int readOffset;
	unsigned char *data;
	bool copyData;
	unsigned char stackData[BITSTREAM_STACK_ALLOCATION_SIZE];
};

typedef unsigned short PlayerIndex;

#pragma pack( push, 1 )

struct PlayerID
{
	///The peer address from inet_addr.
	unsigned int binaryAddress;
	///The port number
	unsigned short port;

	PlayerID& operator = ( const PlayerID& input )
	{
		binaryAddress = input.binaryAddress;
		port = input.port;
		return *this;
	}

	bool operator==( const PlayerID& right ) const;
	bool operator!=( const PlayerID& right ) const;
	bool operator > ( const PlayerID& right ) const;
	bool operator < ( const PlayerID& right ) const;
};

struct NetworkID
{
	bool peerToPeer;
	PlayerID playerId;
	unsigned short localSystemId;
};

/// This represents a user message from another system.
struct Packet
{
	/// Server only - this is the index into the player array that this playerId maps to
	PlayerIndex playerIndex;

	/// The system that send this packet.
	PlayerID playerId;

	/// The length of the data in bytes
	/// \deprecated You should use bitSize.
	unsigned int length;

	/// The length of the data in bits
	unsigned int bitSize;

	/// The data from the sender
	unsigned char* data;

	/// @internal
	/// Indicates whether to delete the data, or to simply delete the packet.
	bool deleteData;
};

/// All RPC functions have the same parameter list - this structure.
struct RPCParameters
{
	/// The data from the remote system
	unsigned char *input;

	/// How many bits long \a input is
	unsigned int numberOfBitsOfData;

	/// Which system called this RPC
	PlayerID sender;

	/// Which instance of RakPeer (or a derived RakServer or RakClient) got this call
	void *recipient;

	/// You can return values from RPC calls by writing them to this BitStream.
	/// This is only sent back if the RPC call originally passed a BitStream to receive the reply.
	/// If you do so and your send is reliable, it will block until you get a reply or you get disconnected from the system you are sending to, whichever is first.
	/// If your send is not reliable, it will block for triple the ping time, or until you are disconnected, or you get a reply, whichever is first.
	BitStream *replyToSender;
};

struct RPCNode
{
	uint8_t uniqueIdentifier;
	void ( *staticFunctionPointer ) ( RPCParameters *rpcParms );
};

/// Store Statistics information related to network usage 
struct RakNetStatisticsStruct
{
	///  Number of Messages in the send Buffer (high, medium, low priority)
	unsigned messageSendBuffer[ NUMBER_OF_PRIORITIES ];
	///  Number of messages sent (high, medium, low priority)
	unsigned messagesSent[ NUMBER_OF_PRIORITIES ];
	///  Number of data bits used for user messages
	unsigned messageDataBitsSent[ NUMBER_OF_PRIORITIES ];
	///  Number of total bits used for user messages, including headers
	unsigned messageTotalBitsSent[ NUMBER_OF_PRIORITIES ];

	///  Number of packets sent containing only acknowledgements
	unsigned packetsContainingOnlyAcknowlegements;
	///  Number of acknowledgements sent
	unsigned acknowlegementsSent;
	///  Number of acknowledgements waiting to be sent
	unsigned acknowlegementsPending;
	///  Number of acknowledgements bits sent
	unsigned acknowlegementBitsSent;

	///  Number of packets containing only acknowledgements and resends
	unsigned packetsContainingOnlyAcknowlegementsAndResends;

	///  Number of messages resent
	unsigned messageResends;
	///  Number of bits resent of actual data
	unsigned messageDataBitsResent;
	///  Total number of bits resent, including headers
	unsigned messagesTotalBitsResent;
	///  Number of messages waiting for ack (// TODO - rename this)
	unsigned messagesOnResendQueue;

	///  Number of messages not split for sending
	unsigned numberOfUnsplitMessages;
	///  Number of messages split for sending
	unsigned numberOfSplitMessages;
	///  Total number of splits done for sending
	unsigned totalSplits;

	///  Total packets sent
	unsigned packetsSent;

	///  Number of bits added by encryption
	unsigned encryptionBitsSent;
	///  total bits sent
	unsigned totalBitsSent;

	///  Number of sequenced messages arrived out of order
	unsigned sequencedMessagesOutOfOrder;
	///  Number of sequenced messages arrived in order
	unsigned sequencedMessagesInOrder;

	///  Number of ordered messages arrived out of order
	unsigned orderedMessagesOutOfOrder;
	///  Number of ordered messages arrived in order
	unsigned orderedMessagesInOrder;

	///  Packets with a good CRC received
	unsigned packetsReceived;
	///  Packets with a bad CRC received
	unsigned packetsWithBadCRCReceived;
	///  Bits with a good CRC received
	unsigned bitsReceived;
	///  Bits with a bad CRC received
	unsigned bitsWithBadCRCReceived;
	///  Number of acknowledgement messages received for packets we are resending
	unsigned acknowlegementsReceived;
	///  Number of acknowledgement messages received for packets we are not resending
	unsigned duplicateAcknowlegementsReceived;
	///  Number of data messages (anything other than an ack) received that are valid and not duplicate
	unsigned messagesReceived;
	///  Number of data messages (anything other than an ack) received that are invalid
	unsigned invalidMessagesReceived;
	///  Number of data messages (anything other than an ack) received that are duplicate
	unsigned duplicateMessagesReceived;
	///  Number of messages waiting for reassembly
	unsigned messagesWaitingForReassembly;
	///  Number of messages in reliability output queue
	unsigned internalOutputQueueSize;
	///  Current bits per second
	double bitsPerSecond;
	///  connection start time
	RakNetTime connectionStartTime;
};

#pragma pack( pop )

class RakClientInterface
{
public:
	virtual ~RakClientInterface() { };
	virtual bool Connect( const char* host, unsigned short serverPort, unsigned short clientPort, unsigned int depreciated, int threadSleepTimer );
	virtual void Disconnect( unsigned int blockDuration, unsigned char orderingChannel=0 );
	virtual void InitializeSecurity( const char *privKeyP, const char *privKeyQ );
	virtual void SetPassword( const char *_password );
	virtual bool HasPassword( void ) const;
	virtual bool Send( const char *data, const int length, PacketPriority priority, PacketReliability reliability, char orderingChannel );
	virtual bool Send( BitStream * bitStream, PacketPriority priority, PacketReliability reliability, char orderingChannel );
	virtual Packet* Receive( void );
	virtual void DeallocatePacket( Packet *packet );
	virtual void PingServer( void );
	virtual void PingServer( const char* host, unsigned short serverPort, unsigned short clientPort, bool onlyReplyOnAcceptingConnections );
	virtual int GetAveragePing( void );
	virtual int GetLastPing( void ) const;
	virtual int GetLowestPing( void ) const;
	virtual int GetPlayerPing( const PlayerID playerId );
	virtual void StartOccasionalPing( void );
	virtual void StopOccasionalPing( void );
	virtual bool IsConnected( void ) const;
	virtual unsigned int GetSynchronizedRandomInteger( void ) const;
	virtual bool GenerateCompressionLayer( unsigned int inputFrequencyTable[ 256 ], bool inputLayer );
	virtual bool DeleteCompressionLayer( bool inputLayer );
	virtual void RegisterAsRemoteProcedureCall( int* uniqueID, void ( *functionPointer ) ( RPCParameters *rpcParms ) );
	virtual void RegisterClassMemberRPC( int* uniqueID, void *functionPointer );
	virtual void UnregisterAsRemoteProcedureCall( int* uniqueID );
	virtual bool RPC( int* uniqueID, const char *data, unsigned int bitLength, PacketPriority priority, PacketReliability reliability, char orderingChannel, bool shiftTimestamp );
	virtual bool RPC( int* uniqueID, BitStream *bitStream, PacketPriority priority, PacketReliability reliability, char orderingChannel, bool shiftTimestamp );
	virtual bool RPC_( int* uniqueID, BitStream *bitStream, PacketPriority priority, PacketReliability reliability, char orderingChannel, bool shiftTimestamp, NetworkID networkID );
	virtual void SetTrackFrequencyTable( bool b );
	virtual bool GetSendFrequencyTable( unsigned int outputFrequencyTable[ 256 ] );
	virtual float GetCompressionRatio( void ) const;
	virtual float GetDecompressionRatio( void ) const;
	virtual void AttachPlugin( void *messageHandler );
	virtual void DetachPlugin( void *messageHandler );
	virtual BitStream * GetStaticServerData( void );
	virtual void SetStaticServerData( const char *data, const int length );
	virtual BitStream * GetStaticClientData( const PlayerID playerId );
	virtual void SetStaticClientData( const PlayerID playerId, const char *data, const int length );
	virtual void SendStaticClientDataToServer( void );
	virtual PlayerID GetServerID( void ) const;
	virtual PlayerID GetPlayerID( void ) const;
	virtual PlayerID GetInternalID( void ) const;
	virtual const char* PlayerIDToDottedIP( const PlayerID playerId ) const;
	virtual void PushBackPacket( Packet *packet, bool pushAtHead );
	virtual void SetRouterInterface( void *routerInterface );
	virtual void RemoveRouterInterface( void *routerInterface );
	virtual void SetTimeoutTime( RakNetTime timeMS );
	virtual bool SetMTUSize( int size );
	virtual int GetMTUSize( void ) const;	
	virtual void AllowConnectionResponseIPMigration( bool allow );
	virtual void AdvertiseSystem( const char *host, unsigned short remotePort, const char *data, int dataLength );
	virtual RakNetStatisticsStruct * const GetStatistics( void );
	virtual void ApplyNetworkSimulator( double maxSendBPS, unsigned short minExtraPing, unsigned short extraPingVariance);
	virtual bool IsNetworkSimulatorActive( void );
	virtual PlayerIndex GetPlayerIndex( void );
	bool RPC( int uniqueID, BitStream *bitStream, PacketPriority priority, PacketReliability reliability, char orderingChannel, bool shiftTimestamp )
	{
		return this->RPC( &uniqueID, bitStream, priority, reliability, orderingChannel, shiftTimestamp );
	};
};

enum RakClientInterfaceFunctionsEnum
{
	RCI_CONNECT = 0,
	RCI_DISCONNECT,
	RCI_INITIALIZESECURITY,
	RCI_SETPASSWORD,
	RCI_HASPASSWORD,
	RCI_SEND,
	RCI_SENDBITSTREAM,
	RCI_RECEIVE,
	RCI_DEALLOCATEPACKET,
	RCI_PINGSERVER,
	RCI_PINGSERVEREX,
	RCI_GETAVERAGEPING,
	RCI_GETLASTPING,
	RCI_GETLOWESTPING,
	RCI_GETPLAYERPING,
	RCI_STARTOCCASIONALPING,
	RCI_STOPOCCASIONALPING,
	RCI_ISCONNECTED,
	RCI_GETSYNCHRONIZEDRANDOMINTEGER,
	RCI_GENERATECOMPRESSIONLAYER,
	RCI_DELETECOMPRESSIONLAYER,
	RCI_REGISTERASREMOTEPROCEDURECALL,
	RCI_REGISTERCLASSMEMBERRPC,
	RCI_UNREGISTERASREMOTEPROCEDURECALL,
	RCI_RPC,
	RCI_RPCBITSTREAM,
	RCI_RPCEX,
	RCI_SETTRACKFREQUENCYTABLE,
	RCI_GETSENDFREQUENCYTABLE,
	RCI_GETCOMPRESSIONRATIO,
	RCI_GETDECOMPRESSIONRATIO,
	RCI_ATTACHPLUGIN,
	RCI_DETACHPLUGIN,
	RCI_GETSTATICSERVERDATA,
	RCI_SETSTATICSERVERDATA,
	RCI_GETSTATICCLIENTDATA,
	RCI_SETSTATICCLIENTDATA,
	RCI_SENDSTATICCLIENTDATATOSERVER,
	RCI_GETSERVERID,
	RCI_GETPLAYERID,
	RCI_GETINTERNALID,
	RCI_PLAYERIDTODOTTEDIP,
	RCI_PUSHBACKPACKET,
	RCI_SETROUTERINTERFACE,
	RCI_REMOVEROUTERINTERFACE,
	RCI_SETTIMEOUTTIME,
	RCI_SETMTUSIZE,
	RCI_GETMTUSIZE,
	RCI_ALLOWCONNECTIONRESPONSEIPMIGRATION,
	RCI_ADVERTISESYSTEM,
	RCI_GETSTATISTICS,
	RCI_APPLYNETWORKSIMULATOR,
	RCI_ISNETWORKSIMULATORACTIVE,
	RCI_GETPLAYERINDEX,
};

enum RakNetScriptHookType
{
	RAKHOOK_TYPE_OUTCOMING_RPC,
	RAKHOOK_TYPE_OUTCOMING_PACKET,
	RAKHOOK_TYPE_INCOMING_RPC,
	RAKHOOK_TYPE_INCOMING_PACKET,
	RAKHOOK_TOTAL_COUNT,
};

struct stRakNetHookParams
{
	BitStream *bitStream;
	int packetId;
	PacketPriority priority;
	PacketReliability reliability;
	char orderingChannel;
	bool shiftTimestamp;	
};


template <class templateType>
inline bool BitStream::Serialize(bool writeToBitstream, templateType &var)
{
	if (writeToBitstream)
		Write(var);
	else
		return Read(var);
	return true;
}

template <class templateType>
inline bool BitStream::SerializeDelta(bool writeToBitstream, templateType &currentValue, templateType lastValue)
{
	if (writeToBitstream)
		WriteDelta(currentValue, lastValue);
	else
		return ReadDelta(currentValue);
	return true;
}

template <class templateType>
inline bool BitStream::SerializeDelta(bool writeToBitstream, templateType &currentValue)
{
	if (writeToBitstream)
		WriteDelta(currentValue);
	else
		return ReadDelta(currentValue);
	return true;
}

template <class templateType>
inline bool BitStream::SerializeCompressed(bool writeToBitstream, templateType &var)
{
	if (writeToBitstream)
		WriteCompressed(var);
	else
		return ReadCompressed(var);
	return true;
}

template <class templateType>
inline bool BitStream::SerializeCompressedDelta(bool writeToBitstream, templateType &currentValue, templateType lastValue)
{
	if (writeToBitstream)
		WriteCompressedDelta(currentValue,lastValue);
	else
		return ReadCompressedDelta(currentValue);
	return true;
}

template <class templateType>
inline bool BitStream::SerializeCompressedDelta(bool writeToBitstream, templateType &currentValue)
{
	if (writeToBitstream)
		WriteCompressedDelta(currentValue);
	else
		return ReadCompressedDelta(currentValue);
	return true;
}

inline bool BitStream::Serialize(bool writeToBitstream, char* input, const int numberOfBytes )
{
	if (writeToBitstream)
		Write(input, numberOfBytes);
	else
		return Read(input, numberOfBytes);
	return true;
}

template <class templateType>
inline bool BitStream::SerializeNormVector(bool writeToBitstream, templateType &x, templateType &y, templateType &z )
{
	if (writeToBitstream)
		WriteNormVector(x,y,z);
	else
		return ReadNormVector(x,y,z);
	return true;
}

template <class templateType>
inline bool BitStream::SerializeVector(bool writeToBitstream,  templateType &x, templateType &y, templateType &z )
{
	if (writeToBitstream)
		WriteVector(x,y,z);
	else
		return ReadVector(x,y,z);
	return true;
}

template <class templateType>
inline bool BitStream::SerializeNormQuat(bool writeToBitstream,  templateType &w, templateType &x, templateType &y, templateType &z)
{
	if (writeToBitstream)
		WriteNormQuat(w,x,y,z);
	else
		return ReadNormQuat(w,x,y,z);
	return true;
}

template <class templateType>
inline bool BitStream::SerializeOrthMatrix(
	bool writeToBitstream,  
	templateType &m00, templateType &m01, templateType &m02,
	templateType &m10, templateType &m11, templateType &m12,
	templateType &m20, templateType &m21, templateType &m22 )
{
	if (writeToBitstream)
		WriteOrthMatrix(m00,m01,m02,m10,m11,m12,m20,m21,m22);
	else
		return ReadOrthMatrix(m00,m01,m02,m10,m11,m12,m20,m21,m22);
	return true;
}

inline bool BitStream::SerializeBits(bool writeToBitstream, unsigned char* input, int numberOfBitsToSerialize, const bool rightAlignedBits )
{
	if (writeToBitstream)
		WriteBits(input,numberOfBitsToSerialize,rightAlignedBits);
	else
		return ReadBits(input,numberOfBitsToSerialize,rightAlignedBits);
	return true;
}

/// Write any integral type to a bitstream.  Undefine __BITSTREAM_NATIVE_END if you need endian swapping.
/// For floating point, this is lossy, using 2 bytes for a float and 4 for a double.  The range must be between -1 and +1.
/// For non-floating point, this is lossless, but only has benefit if you use less than half the range of the type
/// If you are not using __BITSTREAM_NATIVE_END the opposite is true for types larger than 1 byte
/// \param[in] var The value to write
template <class templateType>
inline void BitStream::WriteCompressed(templateType var)
{
#ifdef _MSC_VER
#pragma warning(disable:4127)   // conditional expression is constant
#endif
	if (sizeof(var)==1)
		WriteCompressed( ( unsigned char* ) & var, sizeof( templateType ) * 8, true );
	else
	{
		WriteCompressed( ( unsigned char* ) & var, sizeof(templateType) * 8, true );
	}
}

template <>
inline void BitStream::WriteCompressed(bool var)
{
	Write(var);
}

/// For values between -1 and 1
template <>
inline void BitStream::WriteCompressed(float var)
{
	assert(var > -1.01f && var < 1.01f);
	if (var < -1.0f)
		var=-1.0f;
	if (var > 1.0f)
		var=1.0f;
	Write((unsigned short)((var+1.0f)*32767.5f));
}

/// For values between -1 and 1
template <>
inline void BitStream::WriteCompressed(double var)
{
	assert(var > -1.01 && var < 1.01);
	if (var < -1.0f)
		var=-1.0f;
	if (var > 1.0f)
		var=1.0f;
#ifdef _DEBUG
	assert(sizeof(unsigned long)==4);
#endif
	Write((unsigned long)((var+1.0)*2147483648.0));
}

/// Write any integral type to a bitstream.  If the current value is different from the last value
/// the current value will be written.  Otherwise, a single bit will be written
/// For floating point, this is lossy, using 2 bytes for a float and 4 for a double.  The range must be between -1 and +1.
/// For non-floating point, this is lossless, but only has benefit if you use less than half the range of the type
/// If you are not using __BITSTREAM_NATIVE_END the opposite is true for types larger than 1 byte
/// \param[in] currentValue The current value to write
/// \param[in] lastValue The last value to compare against
template <class templateType>
inline void BitStream::WriteCompressedDelta(templateType currentValue, templateType lastValue)
{
	if (currentValue==lastValue)
	{
		Write(false);
	}
	else
	{
		Write(true);
		WriteCompressed(currentValue);
	}
}

/// Write a bool delta.  Same thing as just calling Write
/// \param[in] currentValue The current value to write
/// \param[in] lastValue The last value to compare against
template <>
inline void BitStream::WriteCompressedDelta(bool currentValue, bool lastValue)
{
#ifdef _MSC_VER
#pragma warning(disable:4100)   // warning C4100: 'lastValue' : unreferenced formal parameter
#endif
	Write(currentValue);
}

/// Save as WriteCompressedDelta(templateType currentValue, templateType lastValue) when we have an unknown second parameter
template <class templateType>
inline void BitStream::WriteCompressedDelta(templateType currentValue)
{
	Write(true);
	WriteCompressed(currentValue);
}

/// Save as WriteCompressedDelta(bool currentValue, templateType lastValue) when we have an unknown second bool
template <>
inline void BitStream::WriteCompressedDelta(bool currentValue)
{
	Write(currentValue);
}

/// Read any integral type from a bitstream.  If the written value differed from the value compared against in the write function,
/// var will be updated.  Otherwise it will retain the current value.
/// ReadDelta is only valid from a previous call to WriteDelta
/// \param[in] var The value to read
template <class templateType>
inline bool BitStream::ReadDelta(templateType &var)
{
	bool dataWritten;
	bool success;
	success=Read(dataWritten);
	if (dataWritten)
		success=Read(var);
	return success;
}

/// Read a bool from a bitstream
/// \param[in] var The value to read
template <>
inline bool BitStream::ReadDelta(bool &var)
{
	return Read(var);
}

/// Read any integral type from a bitstream.  Undefine __BITSTREAM_NATIVE_END if you need endian swapping.
/// For floating point, this is lossy, using 2 bytes for a float and 4 for a double.  The range must be between -1 and +1.
/// For non-floating point, this is lossless, but only has benefit if you use less than half the range of the type
/// If you are not using __BITSTREAM_NATIVE_END the opposite is true for types larger than 1 byte
/// \param[in] var The value to read
template <class templateType>
inline bool BitStream::ReadCompressed(templateType &var)
{
#ifdef _MSC_VER
#pragma warning(disable:4127)   // conditional expression is constant
#endif
	if (sizeof(var)==1)
		return ReadCompressed( ( unsigned char* ) &var, sizeof(templateType) * 8, true );
	else
	{
		return ReadCompressed( ( unsigned char* ) & var, sizeof(templateType) * 8, true );
	}
}

template <>
inline bool BitStream::ReadCompressed(bool &var)
{
	return Read(var);
}

/// For values between -1 and 1
template <>
inline bool BitStream::ReadCompressed(float &var)
{
	unsigned short compressedFloat;
	if (Read(compressedFloat))
	{
		var = ((float)compressedFloat / 32767.5f - 1.0f);
		return true;
	}
	return false;
}

/// For values between -1 and 1
template <>
inline bool BitStream::ReadCompressed(double &var)
{
	unsigned long compressedFloat;
	if (Read(compressedFloat))
	{
		var = ((double)compressedFloat / 2147483648.0 - 1.0);
		return true;
	}
	return false;
}


/// Read any integral type from a bitstream.  If the written value differed from the value compared against in the write function,
/// var will be updated.  Otherwise it will retain the current value.
/// the current value will be updated.
/// For floating point, this is lossy, using 2 bytes for a float and 4 for a double.  The range must be between -1 and +1.
/// For non-floating point, this is lossless, but only has benefit if you use less than half the range of the type
/// If you are not using __BITSTREAM_NATIVE_END the opposite is true for types larger than 1 byte
/// ReadCompressedDelta is only valid from a previous call to WriteDelta
/// \param[in] var The value to read
template <class templateType>
inline bool BitStream::ReadCompressedDelta(templateType &var)
{
	bool dataWritten;
	bool success;
	success=Read(dataWritten);
	if (dataWritten)
		success=ReadCompressed(var);
	return success;
}

/// Read a bool from a bitstream
/// \param[in] var The value to read
template <>
inline bool BitStream::ReadCompressedDelta(bool &var)
{
	return Read(var);
}

class SAMPFUNCS_API SFRakNet
{	
	SFPluginInfo* m_PluginInfo;

public:		
	SFRakNet( SFPluginInfo* pluginInfo );
	SFPluginInfo* getPluginInfo( void );

	const char *getRPCName( int iRPCID );
	const char *getPacketName( int iPacketID );
	RakClientInterface *getRakClient( void );

	void DecodeString( char *output, int maxCharsToWrite, BitStream *input );
	void EncodeString( const char *input, int maxCharsToWrite, BitStream *output );

	void registerRCICallback( RakClientInterfaceFunctionsEnum eMethod, void* pFunc );	
	void registerRakNetCallback( RakNetScriptHookType eCallbackType, bool ( __stdcall *pFunc )( stRakNetHookParams* ) );	

	bool SendRPC( int iRPCID, BitStream *pBitStream, PacketPriority ePriority = HIGH_PRIORITY, PacketReliability eReliability = RELIABLE_ORDERED, char orderingChannel = 0, bool bShiftTimestamp = false );
	bool SendPacket( BitStream *pBitStream, PacketPriority ePriority = HIGH_PRIORITY, PacketReliability eReliability = UNRELIABLE_SEQUENCED, char orderingChannel = 0 );

	void emulateRecvRPC( int iRPCID, BitStream *pBitStream );
	void emulateRecvPacket( int iPacketID, BitStream *pBitStream );
};

#endif // SFRAKNET_H__
