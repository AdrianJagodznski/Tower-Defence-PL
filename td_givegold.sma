/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <td>
#include <ColorChat>

#define PLUGIN "Tower Defense: GiveGold"
#define VERSION "1.0 Beta"
#define AUTHOR "GT Team"

#define CHAT_PREFIX	"[TD]"
new iPlayerTarget[33];

public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	register_clcmd("say /daj", 	"Menu")
	register_clcmd("say /przekaz", 	"Menu")
	register_clcmd("say /give", 	"Menu")
	register_clcmd("say /send", 	"Menu")
	register_clcmd("givegold", 	"Menu")
	
	register_clcmd("gold_ammount", "GiveGold")
	register_clcmd("gold_ammount_admin", "GiveGoldAdmin", ADMIN_CVAR)
}

public Menu(id)
{
	/* Jeli jest to admin, to daj mu prawo otwarcia menu */
	if((get_user_flags(id) & ADMIN_CVAR))
		goto toMenu
	
	if(!is_user_alive(id))
		return
	
	if(td_get_user_info(id, PLAYER_GOLD) <= 0) {
		ColorChat(id, GREEN, "%s^x01 Nie mozesz wyslac zlota, poniewaz nic nie masz!", CHAT_PREFIX)
		return
	}
	if(get_playersnum() == 0) {
		ColorChat(id, GREEN, "%s Jestes sam!", CHAT_PREFIX)
		return
	}
	toMenu:
	/* Jeli ma prawo do otwarcia, pokaz liste graczy*/
	new menu = menu_create("", "MenuH")
	
	new szName[33]
	new szData[3]
	for(new i = 1; i < 33; i++) {
		if(!is_user_alive(i) || is_user_hltv(i))
			continue
		/* Nie pokazuj swojego nicku  w menu*/
		if(!(get_user_flags(id) & ADMIN_CVAR) && i == id)
			continue ;
			
		get_user_name(i, szName, 32)
		num_to_str(i, szData, 2)
		
		menu_additem(menu, szName, szData)
	}
	
	menu_display(id, menu)
}

public MenuH(id, menu, item)
{
	/* Jeli wybra³ gracza, to wybierz ile masz da株/
	if(item == MENU_EXIT || !is_user_alive(id)) {
		menu_destroy(menu)
		return
	}

	new acces,cb, szData[3], szTarget[33], szTitle[70]
	menu_item_getinfo(menu, item, acces, szData, 2, szTarget, 32, cb)
	
	formatex(szTitle, charsmax(szTitle), "Wybrany gracz: \r%s^n\wIle chcesz mu wyslac?",  szTarget)
	
	new iMenu = menu_create(szTitle, "Menu2H")
	new callback = menu_makecallback("Menu2Cb")
	
	menu_additem(iMenu, "5", szData,_, callback)
	menu_additem(iMenu, "10", szTarget,_, callback)
	menu_additem(iMenu, "25",_,_, callback)
	menu_additem(iMenu, "50",_,_, callback)
	menu_additem(iMenu, "100",_,_, callback)
	menu_additem(iMenu, "Wpisz",_,_, callback)
	menu_additem(iMenu, "Admin Menu",_,ADMIN_CVAR)
	
	menu_display(id, iMenu)
}
public Menu2Cb(id, menu, item)
{
	new gold = td_get_user_info(id, PLAYER_GOLD)
	
	if(item == 0 && gold < 5) return ITEM_DISABLED
	else if(item == 1 && gold < 10) return ITEM_DISABLED
	else if(item == 2 && gold < 25) return ITEM_DISABLED
	else if(item == 3  && gold < 50) return ITEM_DISABLED
	else if(item == 4  && gold < 100) return ITEM_DISABLED
	else if(item == 5  && gold < 1) return ITEM_DISABLED
	
	return ITEM_ENABLED
}
public Menu2H(id, menu, item)
{
	if(item == MENU_EXIT || !is_user_alive(id)) { 
		menu_destroy(menu)
		return
	}
	
	new acces,cb, szData[3], szTarget[33], szTemp[2]
	
	menu_item_getinfo(menu, 1, acces, szTemp, 1, szTarget, 32, cb)
	menu_item_getinfo(menu, 0, acces, szData, 2, szTemp, 1, cb)
	
	new  id2 = iPlayerTarget[id] = str_to_num(szData)
	
	if(item == 0) { 
		ChangeGold(id, id2, 5, 0) 
	}
	else if(item == 1) { 
		ChangeGold(id, id2, 10, 0) 
	}
	else if(item == 2) { 
		ChangeGold(id, id2, 25, 0) 
	}
	else if(item == 3) { 
		ChangeGold(id, id2, 50, 0) 
	}
	else if(item == 4) {
		ChangeGold(id, id2, 100, 0) 
	}
	else if(item == 5) { 
		client_print(id, print_center, "Wpisz ile zlota chcesz przeslac");
		
		console_cmd( id, "messagemode gold_ammount")
	} else if(item == 6) {
		menuAdmin(id, id2)
	}
}

public menuAdmin(id, id2) {	
	new szTargetNick[33];
	new szTitle[64];
	
	get_user_name(id2, szTargetNick, 32)
	
	if(!is_user_alive(id2)) {
		ColorChat(id, GREEN, "%s^x01 Player '%s' is dead!", CHAT_PREFIX, szTargetNick)
		Menu(id)
		return
	}
		
	formatex(szTitle, charsmax(szTitle), "Wybrany gracz: \r%s^n\wIle chcesz mu wyslac?",  szTargetNick)
	
	new iMenu = menu_create(szTitle, "menuAdminH")
	
	new szData[3];
	num_to_str(id2, szData, 2)
	
	menu_additem(iMenu, "5", szData)
	menu_additem(iMenu, "10", szTargetNick)
	menu_additem(iMenu, "25")
	menu_additem(iMenu, "50")
	menu_additem(iMenu, "100")
	menu_additem(iMenu, "Wpisz")
	
	menu_display(id, iMenu)
}

public menuAdminH(id, menu, item)
{
	if(item == MENU_EXIT || !is_user_alive(id)) { 
		menu_destroy(menu)
		return
	}
	
	new acces,cb, szData[3], szTarget[33], szTemp[2]
	
	menu_item_getinfo(menu, 1, acces, szTemp, 1, szTarget, 32, cb)
	menu_item_getinfo(menu, 0, acces, szData, 2, szTemp, 1, cb)
	
	new  id2 = iPlayerTarget[id] = str_to_num(szData)
	
	if(item == 0) { 
		ChangeGold(id,id2, 5, 1) 
	}
	else if(item == 1) { 
		ChangeGold(id,id2, 10, 1) 
	}
	else if(item == 2) { 
		ChangeGold(id,id2, 25, 1) 
	}
	else if(item == 3) { 
		ChangeGold(id,id2, 50, 1) 
	}
	else if(item == 4) {
		ChangeGold(id,id2, 100, 1) 
	}
	else if(item == 5) { 
		client_print(id, print_center, "Wpisz ilde chcesz wyslac");
		
		console_cmd( id, "messagemode gold_ammount_admin")
	}
}

public GiveGoldAdmin(id)
{
	new szAmmount[10]
	
	read_args(szAmmount, 9)
	remove_quotes(szAmmount)
	
	if(str_to_num(szAmmount) <= 0) {
		ColorChat(id, GREEN, "%s^x01 Wartosc '%d' jest za mala, wpisz poprawna!", CHAT_PREFIX, str_to_num(szAmmount))
		menuAdmin(id, iPlayerTarget[id]) 
		return;
	}
	
	ChangeGold(id, iPlayerTarget[id], str_to_num(szAmmount), 1);
}

public GiveGold(id)
{
	new szAmmount[10]
	
	read_args(szAmmount, 9)
	remove_quotes(szAmmount)
	
	if(str_to_num(szAmmount) > td_get_user_info(id, PLAYER_GOLD)) {
		ColorChat(id, GREEN, "%s^x01 Wartosc '%d' jest za duza, wpisz poprawna!", CHAT_PREFIX, str_to_num(szAmmount))
		Menu(id) 
		return;
	} else if(str_to_num(szAmmount) <= 0) {
		ColorChat(id, GREEN, "%s^x01 Wartosc '%d' jest za mala, wpisz poprawna!", CHAT_PREFIX, str_to_num(szAmmount))
		Menu(id) 
		return;
	}
	
	ChangeGold(id, iPlayerTarget[id], str_to_num(szAmmount), 0);
}

ChangeGold(this, target, ammount, admin = 0)
{
	new szName[33]
	new szAdminName[33];
	
	get_user_name(this, szAdminName, 32)
	get_user_name(target, szName, charsmax(szName))
	
	if(!is_user_connected(target)) {
		ColorChat(this, GREEN, "%s^x01 Niestety gracz '%s' nie jest na serwerze!", CHAT_PREFIX,  szName)
		return;
	}
	
	if(!admin)
		td_set_user_info(this, PLAYER_GOLD, td_get_user_info(this, PLAYER_GOLD) - ammount)
	td_set_user_info(target, PLAYER_GOLD, td_get_user_info(target, PLAYER_GOLD) + ammount)
	
	if(!admin)
		ColorChat(this, GREEN, "%s^x01 Wyslales %d zlota do '%s'!", CHAT_PREFIX,  ammount, szName)
	else
		ColorChat(0, GREEN, "%s^x01 Admin '%s' wyslal %d zlota do '%s'!", CHAT_PREFIX,  szAdminName,  ammount, szName)
	
	if(admin)
		ColorChat(target,  GREEN, "%s^x01 Otrzymales od admina '%s' %d zlota", CHAT_PREFIX, szAdminName, ammount)
	else
		ColorChat(0,  GREEN, "%s^x01 Gracz '%s' wyslal Ci '%s' %d zlota!", CHAT_PREFIX, szAdminName, szName, ammount)

	iPlayerTarget[this] = 0;
}
	
