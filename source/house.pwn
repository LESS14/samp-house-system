#define SSCANF_NO_NICE_FEATURES // Use apenas caso não esteja usando o Compilador da Comunidade(https://github.com/pawn-lang/compiler)

// ======== Includes ========
#include <a_samp> // Include Padrão do SA-MP
#include <Pawn.CMD> // Processador de comandos By Katursis(https://github.com/katursis/Pawn.CMD)
#include <sscanf2> // Sscanf plugin By Y_LESS(https://github.com/Y-Less/sscanf)
#include <streamer> // Streamer plugin By Incognito(https://github.com/samp-incognito/samp-streamer-plugin)
#include <DOF2> // DOF2(Autor desconhecido ou anônimo): https://pastebin.com/p2KAgAin

// ===== Macros/defines ====
#define MAX_HOUSES 120 // Altere caso queira
#define MAX_PLAYER_HOUSES 5

// ======= Dialogs ======
#define DIALOG_CASAS 0
#define DIALOG_MANAGE_HOUSE 1
#define DIALOG_MANAGE_HOUSE_STRING "{FFFFFF}Teleportar para Casa\nEntrar/Sair\n"

// ===== PASTAS ========
#define HOUSE_PATH "/Casas/casa%d.ini" // Crie a pasta "Casas" na pasta Scriptfiles da sua gamemode

#pragma disablerecursion // Desabilitando recursão do compilador(Delete essa linha caso não esteja dando nenhnum warning relacionado à recursion)


// Cores
#define Vermelho 0xFF0000AA

// ==== Enumeradores ====

enum HInfo {
	Houses[MAX_PLAYER_HOUSES]
};

// Variáveis Globais
static Text3D:textlabelID[MAX_HOUSES], message[128];
new HouseInfo[MAX_PLAYERS][HInfo];

public OnGameModeExit() {
	DOF2_Exit();
	SalvarCasas();
	return 1;
}

public OnGameModeInit() {
	CarregarCasas();
	return 1;
}

main(){}

public OnPlayerRequestClass(playerid, classid) {
	SetSpawnInfo(playerid, -1, 29, 1958.33, 1343.12, 15.36, 269.15, 0, 0, 0, 0, 0, 0);
	SpawnPlayer(playerid);
	return 1;
}

// ====== Funções ======
CarregarCasas() {
    new str[128], icon, iconid;
	for(new i = 0; i < MAX_HOUSES; i++) {
		format(str, sizeof(str), HOUSE_PATH, i);
		if(!DOF2_FileExists(str)) continue;

		if(DOF2_GetInt(str, "TemDono") == 0) {
			icon = CreateDynamicPickup(1273, 1, DOF2_GetFloat(str, "CX"), DOF2_GetFloat(str, "CY"), DOF2_GetFloat(str, "CZ"), -1, -1, -1, 200.0);
			DOF2_SetInt(str, "Id", icon);
			iconid = CreateDynamicMapIcon(DOF2_GetFloat(str, "CX"), DOF2_GetFloat(str, "CY"), DOF2_GetFloat(str, "CZ"), 31, 0, -1, -1, -1, 100.0);
			DOF2_SetInt(str, "IconId", iconid);
			format(message, sizeof(message), "{58E0ED}Casa ID: %d\n{58E0ED}Dono: %s\n{58E0ED}Valor: $%d", i, DOF2_GetString(str, "Owner"), DOF2_GetInt(str, "Valor"));
			textlabelID[i] = CreateDynamic3DTextLabel(message, -1, DOF2_GetFloat(str, "CX"), DOF2_GetFloat(str, "CY"), DOF2_GetFloat(str, "CZ"), 30.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1, -1, 200.0);
			DOF2_SetInt(str, "VirtualWorld", i);
		}
		else {
			if(DOF2_GetInt(str, "TemDono") == 1) {
				icon = CreateDynamicPickup(1272, 1, DOF2_GetFloat(str, "CX"), DOF2_GetFloat(str, "CY"), DOF2_GetFloat(str, "CZ"), -1, -1, -1, 200.0);
				DOF2_SetInt(str, "Id", icon);
				iconid = CreateDynamicMapIcon(DOF2_GetFloat(str, "CX"), DOF2_GetFloat(str, "CY"), DOF2_GetFloat(str, "CZ"), 32, 0, -1, -1, -1, 100.0);
				DOF2_SetInt(str, "IconId", iconid);
				format(message, sizeof(message), "{58E0ED}Casa ID: %d\n{58E0ED}Dono: %s\n{58E0ED}Valor: $%d", i, DOF2_GetString(str, "Owner"), DOF2_GetInt(str, "Valor"));
				textlabelID[i] = CreateDynamic3DTextLabel(message, -1, DOF2_GetFloat(str, "CX"), DOF2_GetFloat(str, "CY"), DOF2_GetFloat(str, "CZ"), 30.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1, -1, 200.0);
				DOF2_SetInt(str, "VirtualWorld", i);
			}
		}
	}
	return 1;
}

SalvarCasas() {
	new str[128];
   	for(new i = 0; i < MAX_HOUSES; i++) {
		format(str, sizeof(str), HOUSE_PATH, i);
		if(DOF2_FileExists(str)) {
			if(DOF2_GetInt(str, "TemDono") == 0) {
				DestroyDynamicPickup(DOF2_GetInt(str, "Id"));
				DestroyDynamicMapIcon(DOF2_GetInt(str, "IconId"));
				DestroyDynamic3DTextLabel(textlabelID[i]);
				textlabelID[i] = Text3D:INVALID_3DTEXT_ID;
			}
			else if(DOF2_GetInt(str, "TemDono") == 1) {
				DestroyDynamicPickup(DOF2_GetInt(str, "Id"));
				DestroyDynamicMapIcon(DOF2_GetInt(str, "IconId"));
				DestroyDynamic3DTextLabel(textlabelID[i]);
				textlabelID[i] = Text3D:INVALID_3DTEXT_ID;
			}
		}
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    	if(dialogid == DIALOG_CASAS) {
		if(response == 1) {
			new pickupid, iconid, string[128];
			for(new i = 0; i < MAX_HOUSES; i++) {
				format(string, sizeof(string), HOUSE_PATH, i);
				if(DOF2_FileExists(string)) {
					if(IsPlayerInRangeOfPoint(playerid, 2.0, DOF2_GetFloat(string, "CX"), DOF2_GetFloat(string, "CY"), DOF2_GetFloat(string, "CZ"))) {
						if(GetPlayerMoney(playerid) < DOF2_GetInt(string, "Valor")) return SendClientMessage(playerid, Vermelho, "~ Você não tem dinheiro Suficiente"); {
							if(GetPlayerHouseCount(playerid) >= MAX_PLAYER_HOUSES) return SendClientMessage(playerid, Vermelho, "~ Você ja atingiu o limite maximo de casas por Player."); {
								DOF2_SetInt(string, "TemDono", 1);
								DOF2_SetString(string, "Owner", PlayerName(playerid));
								GivePlayerMoney(playerid, - DOF2_GetInt(string, "Valor"));
								DestroyDynamicPickup(DOF2_GetInt(string, "Id"));
								pickupid = CreateDynamicPickup(1272, 1, DOF2_GetFloat(string, "CX"), DOF2_GetFloat(string, "CY"), DOF2_GetFloat(string, "CZ"), -1, -1, -1, 200.0);
								DOF2_SetInt(string, "Id", pickupid);
								DestroyDynamicMapIcon(DOF2_GetInt(string, "IconId"));
								iconid = CreateDynamicMapIcon(DOF2_GetFloat(string, "CX"), DOF2_GetFloat(string, "CY"), DOF2_GetFloat(string, "CZ"), 32, 0, -1, -1, -1, 100.0);
								DOF2_SetInt(string, "IconId", iconid);
								format(message, sizeof(message), "{58E0ED}Casa ID: %d\n{58E0ED}Dono: %s\n{58E0ED}Valor: $%d", i, PlayerName(playerid), DOF2_GetInt(string, "Valor"));
								UpdateDynamic3DTextLabelText(textlabelID[i], -1, message);

								format(string, sizeof(string), "{FF6600}[ INFO ] %s comprou uma casa.", PlayerName(playerid), i);
								SendClientMessageToAll(0x00FF7FAA, string);
							}
						}
					}
				}
			}
		}
	}

		else if(dialogid == DIALOG_MANAGE_HOUSE) {
	    new F[128], string[128];
		if(response == 1) {
			if(listitem == 0) {
				new stb[128];
				for(new i = 0; i < MAX_HOUSES; i++) {
					format(stb, sizeof(stb), HOUSE_PATH, i);
					if(!DOF2_FileExists(stb)) continue;
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, 0);
					SetPlayerPosFindZ(playerid, DOF2_GetFloat(stb, "CX"), DOF2_GetFloat(stb, "CY"), DOF2_GetFloat(stb, "CZ"));
				}
			}
			else if(listitem == 1) {
				new temp[256], casas = 1, str1[128], str[128];
				for(new i = 0; i < MAX_HOUSES; i++) {
					format(str, sizeof(str), HOUSE_PATH, i);
					if(DOF2_FileExists(str)) {
					    format(F, sizeof(F), HOUSE_PATH, i);
						if(strcmp(DOF2_GetString(str, "Owner"), PlayerName(playerid), false) == 0) {
							format(temp, sizeof(temp), "Casa ID: %d\n", i);
							strcat(str, temp, sizeof(str1));
							casas++;
							if(casas == 2) {
		                        HouseInfo[playerid][Houses][0] = i;
		                    }
		                    else if(casas == 3) {
		                        HouseInfo[playerid][Houses][1] = i;
		                    }
		                    ShowPlayerDialog(playerid, 55, DIALOG_STYLE_LIST, "Casas", str1, "Ok", "Voltar");
						}
					}
				}
			}

			else if(listitem == 2) {
  				if(GetPVarInt(playerid, "InsideH") == 1) {
					SetPVarInt(playerid, "InsideH", 0);
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, 0);
					SetPlayerPos(playerid, DOF2_GetInt(F, "CX"), DOF2_GetInt(F, "CY"), DOF2_GetInt(F, "CZ"));

					SendClientMessage(playerid, Vermelho, "Você saiu da casa.");
				}

				else if(!GetPVarInt(playerid, "InsideH")) {
			    for(new i = 0; i < MAX_HOUSES; i++) {
				    format(string, 64, HOUSE_PATH, i);
				    if(!DOF2_FileExists(string)) continue;
		    		if(!IsPlayerInRangeOfPoint(playerid, 2.0, DOF2_GetFloat(string, "CX"), DOF2_GetFloat(string, "CY"), DOF2_GetFloat(string, "CZ"))) continue;
					SetPVarInt(playerid, "InsideH", 1);

					SetPlayerVirtualWorld(playerid, playerid+1*5);
					SetPlayerInterior(playerid, DOF2_GetInt(string, "Interior"));
					SetPlayerPos(playerid, DOF2_GetFloat(string, "IX"), DOF2_GetFloat(string, "IY"), DOF2_GetFloat(string, "IZ"));


					SendClientMessage(playerid, -1, "Você entrou na casa para sair use ENTER.");
				}
			}
		}
	}
}
		return 1;
}

VenderCasa(playerid, id) {
    new pickupid, iconid, string[65], str[MAX_PLAYER_NAME], stt[128];
	format(string, sizeof(string), HOUSE_PATH, id);

	DestroyDynamicPickup(DOF2_GetInt(string, "Id"));
	DestroyDynamicMapIcon(DOF2_GetInt(string, "IconId"));
	DestroyDynamic3DTextLabel(textlabelID[id]);
	textlabelID[id] = Text3D:INVALID_3DTEXT_ID;

	format(str, sizeof(str), HOUSE_PATH, DOF2_GetString(string, "Owner"));
	DOF2_SetInt(string, "TemDono", 0);
	DOF2_SetString(string, "Owner", "-");
	GivePlayerMoney(playerid, DOF2_GetInt(string, "Valor"));

	pickupid = CreateDynamicPickup(1273, 1, DOF2_GetFloat(string, "CX"), DOF2_GetFloat(string, "CY"), DOF2_GetFloat(string, "CZ"), -1, -1, -1, 200.0);
	DOF2_SetInt(string, "Id", pickupid);

	iconid = CreateDynamicMapIcon(DOF2_GetFloat(string, "CX"), DOF2_GetFloat(string, "CY"), DOF2_GetFloat(string, "CZ"), 31, 0, -1, -1, -1, 100.0);
	DOF2_SetInt(string, "IconId", iconid);

	format(stt, sizeof(stt), "{58E0ED}Casa ID: %d\n{58E0ED}Dono: %s\n{58E0ED}Valor: $%d", id, DOF2_GetString(string, "Owner"), DOF2_GetInt(string, "Valor"));
	textlabelID[id] = CreateDynamic3DTextLabel(stt, -1, DOF2_GetFloat(string, "CX"), DOF2_GetFloat(string, "CY"), DOF2_GetFloat(string, "CZ"), 30.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1, -1, 200.0);
	return 1;
}

CMD:criarcasa(playerid, const params[]) {
	new Int, Float:pos[3], price;
	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	if(sscanf(params, "dd", Int, price))
	    return SendClientMessage(playerid, Vermelho, "Sintaxe correta: /criarcasa [Interior] [Preço]");
	if(price <= 100*1000 || price > 7*1000000) return SendClientMessage(playerid, Vermelho, "Preço mínimo: R$100 mil | Preço máximo: R$7 milhões");
	CreateHouse(playerid, price, pos[0], pos[1], pos[2], Int);
	return 1;
}

CMD:money(playerid) {
	GivePlayerMoney(playerid, 954564654);
	return 1;
}

CMD:comprarcasa(playerid) {
	new F[64];

	for(new i; i < MAX_HOUSES; i++) {
	    format(F, sizeof(F), HOUSE_PATH, i);
		if(!DOF2_FileExists(F)) continue;
		if(!IsPlayerInRangeOfPoint(playerid, 2.0, DOF2_GetFloat(F, "CX"), DOF2_GetFloat(F, "CY"), DOF2_GetFloat(F, "CZ"))) continue;

		if(DOF2_GetInt(F, "TemDono") == 1) return SendClientMessage(playerid, Vermelho, "x Esta casa já possui proprietário(a).");
		if(GetPlayerMoney(playerid) < DOF2_GetInt(F, "Valor")) return SendClientMessage(playerid, Vermelho, "x Voce não possui dinheiro suficiente.");

		format(message, sizeof(message), "%s[%d] comprou uma casa!", PlayerName(playerid), playerid);
		SendClientMessageToAll(-1, message);
		SendClientMessage(playerid, -1, "Você comprou uma casa!");
		
		ComprarCasa(playerid, i);
		return 1;
	}

	SendClientMessage(playerid, Vermelho, "x Você não está em uma casa.");
	return 1;
}

ComprarCasa(playerid, id) {
    new pickupid, iconid, string[65], str[MAX_PLAYER_NAME], stt[128];
    
    
	format(string, sizeof(string), HOUSE_PATH, id);
 	pickupid = DOF2_GetInt(string, "Pick");
 	iconid = DOF2_GetInt(string, "IconId");

	DestroyDynamicPickup(pickupid);
	DestroyDynamicMapIcon(iconid);
	DestroyDynamic3DTextLabel(textlabelID[id]);
	textlabelID[id] = Text3D:INVALID_3DTEXT_ID;

	format(str, sizeof(str), HOUSE_PATH, DOF2_GetString(string, "Owner"));
	DOF2_SetInt(string, "TemDono", 1);
	DOF2_SetString(string, "Owner", PlayerName(playerid));
	GivePlayerMoney(playerid, - DOF2_GetInt(string, "Valor"));

	CreateDynamicPickup(1272, 1, DOF2_GetFloat(string, "CX"), DOF2_GetFloat(string, "CY"), DOF2_GetFloat(string, "CZ"), -1, -1, -1, 200.0);
	DOF2_SetInt(string, "Pick", 1272);

	iconid = CreateDynamicMapIcon(DOF2_GetFloat(string, "CX"), DOF2_GetFloat(string, "CY"), DOF2_GetFloat(string, "CZ"), 31, 0, -1, -1, -1, 100.0);
	DOF2_SetInt(string, "IconId", iconid);

	format(stt, sizeof(stt), "{58E0ED}Casa ID: %d\n{58E0ED}Dono: %s\n{58E0ED}Valor: $%d", id, DOF2_GetString(string, "Owner"), DOF2_GetInt(string, "Valor"));
	textlabelID[id] = CreateDynamic3DTextLabel(stt, -1, DOF2_GetFloat(string, "CX"), DOF2_GetFloat(string, "CY"), DOF2_GetFloat(string, "CZ"), 30.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1, -1, 200.0);
	return 1;
}

CreateHouse(playerid, pricing, Float:X, Float:Y, Float:Z, interiorid) {
	new bool:ValidInt, iid = interiorid, Float:posi[3];
	
	switch(iid) {
		case 1: ValidInt = true, posi[0] = 244.411987, posi[1] = 305.032989, posi[2] = 999.148437;
		case 2: ValidInt = true, posi[0] = 271.884979, posi[1] = 306.631988, posi[2] = 999.148437;
		case 5: ValidInt = true, posi[0] = 322.197998, posi[1] = 302.497985, posi[2] = 999.148437;
		case 12: ValidInt = true, posi[0] = 1267.663208, posi[1] = -781.323242, posi[2] = 1091.906250;
		default: ValidInt = false;
	}
	
	if(!(ValidInt)) {
		format(message, sizeof(message), "ID Inválido! ids válidos: 1, 2, 5, 12");
		SendClientMessage(playerid, Vermelho, message);
		return 1;
	}

	new id = GenerateHouseID();
	if(id >= MAX_HOUSES) {
		format(message, sizeof(message), "O limite de %d casas foi atingido, não é possível criar mais.", MAX_HOUSES);
		SendClientMessage(playerid, Vermelho, message);
		return 1;
	}

	new houseF[64];
	format(houseF, sizeof(houseF), HOUSE_PATH, id);

	DOF2_CreateFile(houseF);
	DOF2_SetFloat(houseF, "CX", X);
	DOF2_SetFloat(houseF, "CY", Y);
	DOF2_SetFloat(houseF, "CZ", Z);
	DOF2_SetInt(houseF, "ID", id);
	DOF2_SetFloat(houseF, "IX", posi[0]);
	DOF2_SetFloat(houseF, "IY", posi[1]);
	DOF2_SetFloat(houseF, "IZ", posi[2]);
	DOF2_SetInt(houseF, "Interior", interiorid);
	DOF2_SetInt(houseF, "TemDono", 0);
	DOF2_SetString(houseF, "Owner", "-");
	DOF2_SetInt(houseF, "Valor", pricing);

	new pick;
	pick = CreateDynamicPickup(1273, 1, X, Y, Z, -1, -1, -1, 200.0);
	DOF2_SetInt(houseF, "Pick", pick);

	new pick2;
	pick2 = CreateDynamicMapIcon(X, Y, Z, 31, 0, -1, -1, -1, 100.0);
	DOF2_SetInt(houseF, "IconId", pick2);

	format(message, sizeof(message), "{58E0ED}ID: %d\n{58E0ED}Dono: -\n{58E0ED}Preço: $%d", id, pricing);
	textlabelID[id] = CreateDynamic3DTextLabel(message, -1, X, Y, Z, 30.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1, -1, 200.0);

	format(message, sizeof(message), "{EEC943}O(a) Administrador %s Criou uma casa.", PlayerName(playerid), id);
	SendClientMessageToAll(-1, message);
	return 1;
}


GenerateHouseID() {
	static string[128];
	for(new i = 0; i < MAX_HOUSES; i++) {
		format(string, sizeof(string), HOUSE_PATH, i);
		if(i <= 0) continue;
		if(!DOF2_FileExists(string)) return i;
	}
	return MAX_HOUSES;
}

PlayerName(playerid) {
	new Name[MAX_PLAYERS];
	GetPlayerName(playerid, Name, sizeof(Name));
	return Name;
}

GetPlayerHouseCount(playerid) {
	static count, string[128];
	for(new i = 0; i < MAX_HOUSES; i++) {
		format(string, sizeof(string), HOUSE_PATH, i);
		if(DOF2_GetInt(string, "TemDono") == 1) {
			if(strcmp(DOF2_GetString(PlayerName(playerid), "Owner"), PlayerName(playerid), false) == 0) {
				count = count += 1;
			}
		}
	}
	return count;
}

CMD:casa(playerid) {
	new F[MAX_PLAYER_NAME];
	for(new i = 0; i < MAX_HOUSES; i++) {
		format(F, sizeof(F), HOUSE_PATH, PlayerName(playerid));
		if(!DOF2_FileExists(F)) continue;
		else if(!DOF2_GetInt(F, "Owner")) return SendClientMessage(playerid, Vermelho, "Você não tem nenhuma casa"), 1;
		break;
	}
	
	ShowPlayerDialog(playerid, DIALOG_MANAGE_HOUSE, DIALOG_STYLE_LIST, "Casa", DIALOG_MANAGE_HOUSE_STRING, "Selecionar", "Cancelar");
	return 1;
}

CMD:vendercasa(playerid) {
	new strk[128];
	for(new i = 0; i < MAX_HOUSES; i++) {
	format(strk, sizeof(strk), HOUSE_PATH, i);
	if(!DOF2_FileExists(strk)) continue;
	else if(!IsPlayerInRangeOfPoint(playerid, 5.0, DOF2_GetFloat(strk, "CX"), DOF2_GetFloat(strk, "CY"), DOF2_GetFloat(strk, "CZ"))) continue;
	else if(DOF2_GetInt(strk, "TemDono") == 0) return SendClientMessage(playerid, Vermelho, "Esta casa já está a venda.");
	else if(strcmp(PlayerName(playerid), DOF2_GetString(strk, "Owner"))) return SendClientMessage(playerid, Vermelho, "Esta casa não é sua.");
	new std[128];
	format(std, sizeof(std), "%s Vendeu uma casa. ID: %d.", PlayerName(playerid), i);
	SendClientMessageToAll(-1, std);

	SendClientMessage(playerid, Vermelho, "Você vendeu sua casa!");
	return VenderCasa(playerid, i);
	}
	return 1;
}

CMD:ircasa(playerid) {
	SetPlayerInterior(playerid, 5);
	SetPlayerPos(playerid, 1267.663208,-781.323242,1091.906250);
	return 1;
}
