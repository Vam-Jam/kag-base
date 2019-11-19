#define SERVER_ONLY

#include "Hitters.as";

u8 limit = 15; //ticks between hitting

void onInit(CRules@ this)
{
	onRestart(this);
}

void onRestart(CRules@ this)
{
	//u16[] empty;
	//this.set("water_ids",empty);
}

/*
void onBlobCreated(CRules@ this, CBlob@ blob)
{
    string name = blob.getName();
	if (name == "wooden_door" || name == "ladder")
	{
		u16[] ids;
		this.get("water_ids",ids);

		ids.push_back(blob.getNetworkID());

		this.set("water_ids",ids);
	}
}
*/

/*void onSetStatic(CBlob@ this, const bool isStatic)
{
	string name = this.getName();
	if(isStatic && (name == "wooden_door" || name == "ladder"))
	{
		if(this.isInWater())
		{
			print("placed");
			ids.push_back(this.getNetworkID());
		}
	}
}*/

void onBlobDie(CRules@ this, CBlob@ blob)
{
    string name = blob.getName();
	if (name == "wooden_door" || name == "ladder")
	{
		u16[] ids;
		u16 id = blob.getNetworkID();
		this.get("water_ids",ids);

		int index = ids.find(id);
		if (index != -1)
		{
			ids.erase(index);
		}

		this.set("water_ids",ids);


	}
}

void onSetTile(CMap@ this, u32 index, TileType newtile, TileType oldtile)
{
	print("sup");
}

void onTick(CRules@ this)
{
	//limit
	if(((getGameTime() * 997) % limit) != 0)
		return;

	//print("getting");
	u16[] ids;
	this.get("water_ids",ids);

	CMap@ map = getMap();
	for (uint i = 0; i < ids.length; i++)
	{
		//print("looping");
		CBlob@ b = getBlobByNetworkID(ids[i]);
		if (b is null)
		{
			ids.erase(i--);
			continue;
		}

		/*Vec2f pos = b.getPosition();
		Vec2f[] postocheck =
		{
			pos + Vec2f(map.tilesize, 0),
			pos + Vec2f(-map.tilesize, 0),
			pos + Vec2f(0, -map.tilesize)
		};
		
		bool water = false;
		for (uint j = 0; j < postocheck.length; j++)
		{
			Vec2f wpos = postocheck[j];
			if (map.isInWater(wpos))
			{
				water = true;
				break;
			}
		}
		*/
		if(b.isInWater() && !b.isAttached())
		{
			b.server_Hit(b, b.getPosition(), Vec2f(), 0.5f, Hitters::water, true);
		}
	}
}
