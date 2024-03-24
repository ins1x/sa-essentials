--[[
	Project: SA Memory (Available from https://blast.hk/)
	Developers: LUCHARE, FYP

	Special thanks:
		plugin-sdk (https://github.com/DK22Pac/plugin-sdk) for the structures and addresses.

	Copyright (c) 2018 BlastHack.
]]

local shared = require 'SAMemory.shared'

shared.ffi.cdef[[
	typedef struct RpGeometry RpGeometry;
	typedef struct RpClump RpClump;
	typedef struct RwRaster RwRaster;
	typedef struct RpAtomic RpAtomic;
	typedef struct RwCamera RwCamera;
	typedef struct RwListEntry RwListEntry;

	typedef RwCamera *(*RwCameraPreCallback)(RwCamera *camera);
	typedef RwCamera *(*RwCameraPostCallback)(RwCamera *camera);
	typedef RpAtomic *(*RpAtomicCallback)(RpAtomic *atomic);
	typedef RpClump  *(*RpClumpCallback)(RpClump *clump, void *data);
	typedef void * 	 RpWorld;

	typedef struct RwV2D
	{
	  float x, y;
	} RwV2D;

	typedef struct RwV3D
	{
		float x, y, z;
	} RwV3D;

	typedef struct RwPlane
	{
	  RwV3D normal;
	  float length;
	} RwPlane;

	typedef struct RwBBox
	{
	  RwV3D max;
	  RwV3D min;
	} RwBBox;

	typedef struct RwSphere
	{
	  RwV3D position;
	  float radius;
	} RwSphere;

	typedef struct RwMatrix
	{
		RwV3D          right;
		unsigned int   flags;
		RwV3D          up;
		unsigned int   pad1;
		RwV3D          at;
		unsigned int   pad2;
		RwV3D          pos;
		unsigned int   pad3;
	} RwMatrix;

	typedef enum RwPrimitiveType
	{
		PRIMITIVE_NULL = 0,
		PRIMITIVE_LINE_SEGMENT = 1,
		PRIMITIVE_LINE_SEGMENT_CONNECTED = 2,
		PRIMITIVE_TRIANGLE = 3,
		PRIMITIVE_TRIANGLE_STRIP = 4,
		PRIMITIVE_TRIANGLE_FAN = 5,
		PRIMITIVE_POINT = 6,
	  PRIMITIVE_LAST = ((int)((~((unsigned int)0))>>1))
	} RwPrimitiveType;

	typedef enum RwCameraType
	{
		RW_CAMERA_NULL = 0,
		RW_CAMERA_PERSPECTIVE = 1,
		RW_CAMERA_ORTHOGRAPHIC = 2,
		RW_CAMERA_LAST = ((int)((~((unsigned int)0))>>1))
	} RwCameraType;

	typedef enum RpAtomicFlags
	{
		ATOMIC_COLLISION = 1,
		ATOMIC_VISIBLE = 4,
		ATOMIC_LAST = ((int)((~((unsigned int)0))>>1))
	} RpAtomicFlags;

	typedef enum RwRasterLockFlags
	{
		RASTER_LOCK_WRITE = 1,
		RASTER_LOCK_READ = 2,
		RASTER_LOCK_LAST = ((int)((~((unsigned int)0))>>1))
	} RwRasterLockFlags;

	typedef enum RwTransformOrder
	{
		TRANSFORM_INITIAL = 0,
		TRANSFORM_BEFORE = 1,
		TRANSFORM_AFTER = 2,
		TRANSFORM_LAST = ((int)((~((unsigned int)0))>>1))
	} RwTransformOrder;

	typedef enum RpLightType
	{
		LIGHT_TYPE_NULL = 0,

		LIGHT_TYPE_DIRECTIONAL = 1,
		LIGHT_TYPE_AMBIENT = 2,

		LIGHT_TYPE_POINT = 0x80,
		LIGHT_TYPE_SPOT_1 = 0x81,
		LIGHT_TYPE_SPOT_2 = 0x82,

		LIGHT_TYPE_LAST = ((int)((~((unsigned int)0))>>1))
	} RpLightType;

	typedef enum RpLightFlags
	{
		LIGHT_ILLUMINATES_ATOMICS = 1,
		LIGHT_ILLUMINATES_GEOMETRY = 2,
		LIGHT_FLAGS_LAST = ((int)((~((unsigned int)0))>>1))
	} RpLightFlags;

	typedef struct RwObject
	{
		unsigned char type;
		unsigned char subtype;
		unsigned char flags;
		unsigned char privateFlags;
		void *parent;
	} RwObject;

	typedef struct RwVertex
	{
	  RwV3D        position;
	  RwV3D        normal;
	  unsigned int color;
	  float        u,v;
	} RwVertex;

	typedef struct RwListEntry
	{
		RwListEntry *next,*prev;
	} RwListEntry;

	typedef struct RwList
	{
		RwListEntry root;
	} RwList;

	typedef struct RwFrame
	{
		RwObject         object;
		void             *pad1,*pad2;
		RwMatrix         modelling;
		RwMatrix         ltm;
		RwList           objects;
		struct RwFrame   *child;
		struct RwFrame   *next;
		struct RwFrame   *root;
		unsigned char    pluginData[8];
		char             szName[16];
	} RwFrame;

	typedef struct RwTexDictionary
	{
		RwObject     object;
		RwList       textures;
		RwListEntry  globalTXDs;
	} RwTexDictionary;

	typedef struct RwTexture
	{
		RwRaster           *raster;
		RwTexDictionary    *txd;
		RwListEntry        TXDList;
		char               name[32];
		char               mask[32];
		unsigned int       flags;
		int                refs;
	} RwTexture;

	typedef struct RwTextureCoordinates
	{
	  float u,v;
	} RwTextureCoordinates;

	typedef struct RwRaster
	{
	  RwRaster        *parent;
	  unsigned char   *pixels;
	  unsigned char   *palette;
	  int             width, height, depth;
	  int             stride;
	  short           u, v;
	  unsigned char   type;
	  unsigned char   flags;
	  unsigned char   privateFlags;
	  unsigned char   format;
	  unsigned char   *origPixels;
	  int             origWidth, origHeight, origDepth;
	} RwRaster;

	typedef struct RwColorFloat
	{
	  float r,g,b,a;
	} RwColorFloat;

	typedef struct RwColor
	{
	  unsigned char r,g,b,a;
	} RwColor;

	typedef struct RwObjectFrame
	{
	  RwObject     object;
	  RwListEntry  lFrame;
		void         *callback;
	} RwObjectFrame;

	typedef struct RwCameraFrustum
	{
		RwPlane       plane;
		unsigned char x,y,z;
		unsigned char unknown1;
	} RwCameraFrustum;

	typedef struct RwCamera
	{
		RwObjectFrame        object;
		RwCameraType         type;
		RwCameraPreCallback  preCallback;
		RwCameraPostCallback postCallback;
		RwMatrix             matrix;
		RwRaster             *bufferColor;
		RwRaster             *bufferDepth;
		RwV2D                screen;
		RwV2D                screenInverse;
		RwV2D                screenOffset;
		float                nearplane;
		float                farplane;
		float                fog;
		float                unknown1;
		float                unknown2;
		RwCameraFrustum      frustum4D[6];
		RwBBox               viewBBox;
		RwV3D                frustum3D[8];
	} RwCamera;

	typedef struct RpInterpolation
	{
		unsigned int     unknown1;
		unsigned int     unknown2;
		float            unknown3;
		float            unknown4;
		float            unknown5;
	} RpInterpolation;

	typedef struct RpAtomic
	{
	  RwObjectFrame    object;
	  void             *info;
	  RpGeometry       *geometry;
	  RwSphere         bspherelocal;
	  RwSphere         bsphereWorld;
	  RpClump          *clump;
	  RwListEntry      globalClumps;
	  RpAtomicCallback renderCallback;
		RpInterpolation  interpolation;
	  unsigned short   frame;
	  unsigned short   unknown7;
	  RwList           sectors;
	  void             *render;
	} RpAtomic;

	typedef struct RpAtomicContainer
	{
		RpAtomic	*atomic;
		char		szName[17];
	} RpAtomicContainer;

	typedef struct RpLight
	{
		RwObjectFrame   object;
		float           radius;
		RwColorFloat    color;
		float           unknown1;
		RwList          sectors;
		RwListEntry     globalLights;
		unsigned short  frame;
		unsigned short  unknown2;
	} RpLight;

	typedef struct RpClump
	{
		RwObject        object;
		RwList          atomics;
		RwList          lights;
		RwList          cameras;
		RwListEntry     globalClumps;
		RpClumpCallback callback;
	} RpClump;

	typedef struct RpMaterialLighting
	{
	  float ambient, specular, diffuse;
	} RpMaterialLighting;

	typedef struct RpMaterial
	{
		RwTexture*          texture;
		RwColor             color;
		void                *render;
		RpMaterialLighting  lighting;
		short               refs;
		short               id;
	} RpMaterial;

	typedef struct RpMaterials
	{
	  RpMaterial **materials;
	  int        entries;
	  int        unknown;
	} RpMaterials;

	typedef struct RpTriangle
	{
	  unsigned short v1, v2, v3;
	  unsigned short materialId;
	} RpTriangle;

	typedef struct RpGeometry
	{
	  RwObject             object;
	  unsigned int         flags;
	  unsigned short       unknown1;
	  short                refs;
	  int                  triangles_size;
	  int                  vertices_size;
	  int                  unknown_size;
	  int                  texcoords_size;
	  RpMaterials          materials;
	  RpTriangle           *triangles;
	  RwColor              *colors;
	  RwTextureCoordinates *texcoords[8];
	  void                 *unknown2;
	  void                 *info;
	  void                 *unknown3;
	} RpGeometry;

	typedef int          (* RwIOCallbackClose) (void *data);
	typedef unsigned int (* RwIOCallbackRead)  (void *data, void *buffer, unsigned int length);
	typedef int          (* RwIOCallbackWrite) (void *data, const void *buffer, unsigned int length);
	typedef int          (* RwIOCallbackOther) (void *data, unsigned int offset);

	typedef enum RwStreamType
	{
		STREAM_TYPE_NULL = 0,
		STREAM_TYPE_FILE = 1,
		STREAM_TYPE_FILENAME = 2,
		STREAM_TYPE_BUFFER = 3,
		STREAM_TYPE_CALLBACK = 4,
		STREAM_TYPE_LAST = ((int)((~((unsigned int)0))>>1))
	} RwStreamType;

	typedef enum RwStreamMode
	{
		STREAM_MODE_NULL = 0,
		STREAM_MODE_READ = 1,
		STREAM_MODE_WRITE = 2,
		STREAM_MODE_APPEND = 3,
		STREAM_MODE_LAST = ((int)((~((unsigned int)0))>>1))
	} RwStreamMode;

	typedef struct RwBuffer
	{
		void            *ptr;
		unsigned int    size;
	} RwBuffer;

	typedef union RwStreamTypeData
	{
		struct
		{
			unsigned int      position;
			unsigned int      size;
			void              *ptr;
		};

		struct
		{
			void              *file;
		};

		struct
		{
			RwIOCallbackClose callbackClose;
			RwIOCallbackRead  callbackRead;
			RwIOCallbackWrite callbackWrite;
			RwIOCallbackOther callbackOther;
			void              *ptr;
		};
	} RwStreamTypeData;

	typedef struct RwStream
	{
		RwStreamType        type;
		RwStreamMode        mode;
		int                 pos;
		RwStreamTypeData    data;
		int                 id;
	} RwStream;

	typedef struct RwError
	{
		int err1,err2;
	} RwError;
]]
