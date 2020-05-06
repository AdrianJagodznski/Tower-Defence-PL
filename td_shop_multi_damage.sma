#include <amxmodx>
#include <td>
#include <colorchat>

#define PLUGIN "TD: Shop | Multi Damage"
#define VERSION "1.0"
#define AUTHOR "tomcionek15 & grs4"


new iItem;
new g_iWaveNums[33];

public plugin_init() 
{
	new id = register_plugin(PLUGIN, VERSION, AUTHOR)
	
	iItem = td_shop_register_item("MEGA DMG", "Zadajesz tylko obrazenia HS i Krytyczne", 300, 0, id)
}

public td_reset_player_info(iPlayer)
	g_iWaveNums[iPlayer] = 0;

public client_disconnected(iPlayer)
	g_iWaveNums[iPlayer] = 0;
	
public td_shop_item_selected(id, itemid)
{
	if(iItem == itemid)
	{
		g_iWaveNums[id] += 1;
		
		ColorChat(id, GREEN, "[TD]^x01 MEGA DMG bedzie aktywne przez %d fal!", g_iWaveNums[id]);
		
		SetOff(id + 54155);
	}
	return PLUGIN_CONTINUE;
}
public td_wave_ended(iEndedWave)
{
	for(new i = 1; i < 33 ; i++)
		if(g_iWaveNums[i] > 0)
			g_iWaveNums[i]--;
}
public SetOff(id)
{
	id -= 54155;
	
	if(g_iWaveNums[id] == 0)
	{
		set_hudmessage(200, 255, 0, 0.60, 0.69, 0, 0.1, 4.0, 0.1, 0.1, -1)
		show_hudmessage(id,"MEGA DMG wylaczone!")

		ColorChat(id, GREEN, "[TD]^x01 MEGA DMG wylaczone!");
		return;
	}
	set_hudmessage(200, 255, 0, 0.60, 0.60, 1, 0.1, 1.1, 0.1, 0.1, -1)
	show_hudmessage(id,"MEGA DMG: %d %s pozostalo", g_iWaveNums[id], g_iWaveNums[id] == 1 ? "fala" : "fal")
	
	set_task(1.0, "SetOff", id + 54155);
}	
public td_take_damage(id, ent, iWeapon, Float:damage, szData[3]) 
{
	if(g_iWaveNums[id]) 
	{
		szData[1] = 1; // critic
		szData[2] = 1; //hs
	}
}
