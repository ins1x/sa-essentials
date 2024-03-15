#ifndef SAMPFUNCS_API_H__
#define SAMPFUNCS_API_H__

#include <string>
#include <vector>
#include <Windows.h>
#include <stdint.h>

#pragma warning(push)
#pragma warning(disable : 4251)

typedef class CPlugin *PPLUGIN;
typedef void(__stdcall *CommandProc) (std::string params);

class SAMPFUNCS_API SFPluginInfo
{
public:
	SFPluginInfo(HMODULE, std::string);
	HMODULE									getPluginHandle(void);
	std::string								getPluginName(void);

private:
	HMODULE									m_hPlugin;
	std::string								m_strPluginName;
};

struct SAMPFUNCS_API stCommandInfo
{
	enum CommandType
	{
		NOPE,
		SCRIPT,
		PLUGIN
	};

	stCommandInfo(std::string, CommandType, void*);

	std::string								name;
	CommandType								type;
	union
	{
		struct CScriptThread				*thread;
		class SFPluginInfo					*plugin;
		void								*owner;
	};
};

class SAMPFUNCS_API SAMPFUNCS
{
public:
	PPLUGIN pPlugin;

	class SFRakNet *getRakNet(void);
	class SFSAMP *getSAMP(void);
	class SFRender *getRender(void);
	class SFGame *getGame(void);
	class SFCLEO *getCLEO(void);

	void									Log(const char* pText, ...);
	void									LogFile(const char* pText, ...);
	void									LogConsole(const char* pText, ...);
	bool									initPlugin(void (__stdcall *PluginThread) (void), HMODULE hModule);
	unsigned int							getAPIVersion(void);
	unsigned int							getSFVersion(void);
	void									registerConsoleCommand(std::string cmd, CommandProc callback);
	void									unregisterConsoleCommand(std::string cmd);
	void									execConsoleCommand(std::string command);
	bool									isConsoleOpened(void);
	bool									isPluginLoaded(std::string strPluginName);
	void									loadPlugin(std::string strPluginName);
	void									unloadPlugin(std::string strPluginName);
	std::vector<stCommandInfo>				getChatCommands(void);
	std::vector<stCommandInfo>				getConsoleCommands(void);
	void									setConsoleCommandDescription(std::string command, std::string description);
	void									Log(const std::string& pText);
};

#include "SFRender.h"
#include "SFRakNet.h"
#include "SFSAMP.h"
#include "SFCLEO.h"
#include "SFGame.h"

#pragma warning(pop)

#endif // SAMPFUNCS_API_H__
