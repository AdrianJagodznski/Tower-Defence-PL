#include <amxmodx>
#include <td>

new iItem;
public plugin_init(){
	new id = register_plugin("TD: SHOP| Napalm Nade", "1.0", "GT Team")
	
	iItem = td_shop_register_item("Granat zapalajacy", "Podpala zadajac 500 DMG w 10 sekund", 30, 0, id)
}

public td_shop_item_selected(id, itemid)
{
	if(iItem == itemid)
	{
		if(td_give_user_napalm_grenade(id) == 0)
		{
			client_print(id, print_center, "Osiagnales limit granatow podpalajacych");

			return PLUGIN_HANDLED;
		}
	}

	return PLUGIN_CONTINUE;
}
