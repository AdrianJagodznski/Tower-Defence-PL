/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <amxmisc>
#include <td>
#include <fun>

#define PLUGIN "TD: Shop | 25% speed"
#define VERSION "1.0"
#define AUTHOR "tomcionek15 & grs4"

new iItem;
public plugin_init() 
{
	new id = register_plugin(PLUGIN, VERSION, AUTHOR)
	iItem = td_shop_register_item("25% szybkosci", "Bedziesz o 25% szybszy", 250, 1, id)
	
}
public td_shop_item_selected(id, itemid)
{
	if(iItem == itemid)
	{
		new Float:fSpeed = float(td_get_user_info(id, PLAYER_EXTRA_SPEED))
		
		if(fSpeed <= 0.0)
			fSpeed = 62.5
		else
			fSpeed += ( (fSpeed / 4.0) + 62.5 )
		
		td_set_user_info(id, PLAYER_EXTRA_SPEED, floatround(fSpeed));
	}
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1045\\ f0\\ fs16 \n\\ par }
*/
