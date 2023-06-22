#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
    setDvarIfUninitialized("allowDophinDive", 1);
    level.allowDophinDive = getDvarInt("allowDophinDive");

	thread onPlayerConnected();
}

onPlayerConnected() {
	level endon( "disconnect" );

	for(;;) {
		level waittill( "connected", player );

        if( level.allowDophinDive )
		    player thread dolphinDive();
    }
}

dolphinDive()
{
	self endon("dolphindiveoff");
	while(1)
	{
		veloc = self getVelocity();
		wait 0.01;
		if(abv(veloc[1]) > 140 && self getstance() == "crouch")
		{
			self AllowAds(false);
			self thread launchMe(100,65,true);
			self setStance("prone");
			self AllowAds(true);
			while(!self isonground())
		{
			wait 0.001;
		}
			self notify("dolphindive");
		} 
		wait 0.001;
	}
}

launchMe(force,height,slide)
{
	vec = anglestoforward(self getplayerangles());
	mo = self.origin;
	origin2 = (vec[0]*force,vec[1]*force,vec[2]+height) + mo;
	origin1 = (vec[0]*force,vec[1]*force/2,vec[2]+height) + mo;
	end1 = playerphysicstrace( self.origin, origin1 );
	end2 = playerphysicstrace( self.origin, origin2 );
	self setorigin(end1);
	wait 0.05; self setorigin(end2);
	if(isDefined(slide) && slide)
	{
		while(!self isonground())
		{ 
			wait 0.001;
		} 
		vec = anglestoforward(self getplayerangles());
		mo = self.origin;
		so = (vec[0]*1.5,vec[1]*1.5,vec[2]*1.5) + mo;
		se = physicstrace( self.origin, so );
		self setorigin(se);
	}
}

abv(n)
{
	if(n < 0 )
	{
		return n * -1;
	}
	else
	{
		return n;
	}
}