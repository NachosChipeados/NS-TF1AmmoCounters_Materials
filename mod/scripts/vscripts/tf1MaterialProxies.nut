// Material proxies to hide ammo counters while cloaked + other stuff
// Cloak proxy taken from CRF (Thanks, Creamy) and renamed so it doesn't cause any issues

global function VMTCallback_CloakToAlpha_TF1
global function VMTCallback_CloakToAlpha_Blank

global function VMTCallback_AmmoToSpinRate
global function VMTCallback_AmmoToSpinRate_Reserve
global function VMTCallback_ClipAmmoColor
global function VMTCallback_RemainingAmmo
global function VMTCallback_RemainingAmmoColor
global function VMTCallback_MaxCarryAmmo

global function VMTCallback_ProScreen
global function VMTCallback_ProScreenColor

global function TF1_AmmoCol

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

global const vector AMMO_COL_FRACHIGH = <133, 231, 255>
global const vector AMMO_COL_FRACMID = <255, 128, 64>
global const vector AMMO_COL_FRACLOW = <255, 75, 66>

var function VMTCallback_CloakToAlpha_TF1( entity ent )
{
	if ( GetConVarBool( "TF1AMMO.debug_hide" ) )
		return 0.0

	if ( IsLobby() )
		return 0.0

	if ( IsCloaked( ent ) )
		return 0.0
	else
		return 1.0
}

var function VMTCallback_CloakToAlpha_Blank( entity ent )
{
	if ( GetConVarBool( "TF1AMMO.debug_hide" ) )
		return 0.0

	if ( !GetConVarBool( "TF1AMMO.blank_rounds" ) )
		return 0.0

	if ( IsLobby() )
		return 0.0

	if ( IsCloaked( ent ) )
		return 0.0
	else
		return 1.0
}

var function VMTCallback_AmmoToSpinRate( entity ent )
{
	if ( IsLobby() )
		return 0.0

	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return 0.0

	entity weapon = player.GetActiveWeapon()
	if ( !IsValid( weapon ) )
		return 0.0

	int currentAmmo = weapon.GetWeaponPrimaryClipCount()
	int maxAmmo = weapon.GetWeaponPrimaryClipCountMax()

	int spinMultiplier = ( maxAmmo - currentAmmo ) * 10

	return spinMultiplier
}

var function VMTCallback_AmmoToSpinRate_Reserve( entity ent )
{
	if ( IsLobby() )
		return 0.0

	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return 0.0

	entity weapon = player.GetActiveWeapon()
	if ( !IsValid( weapon ) )
		return 0.0

	int currentAmmo = player.GetWeaponAmmoStockpile( weapon )
	int maxAmmo = weapon.GetWeaponSettingInt( eWeaponVar.ammo_stockpile_max )

	int spinMultiplier = ( maxAmmo - currentAmmo ) * 10

	return spinMultiplier
}

var function VMTCallback_ClipAmmoColor( entity ent )
{
	if ( IsLobby() )
		return Vector( 1, 1, 1 )

	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return Vector( 1, 1, 1 )

	entity weapon = player.GetActiveWeapon()
	if ( !IsValid( weapon ) )
		return Vector( 1, 1, 1 )

	int currentAmmo = weapon.GetWeaponPrimaryClipCount()
	int maxAmmo = weapon.GetWeaponPrimaryClipCountMax()

	return TF1_AmmoCol( currentAmmo, maxAmmo )
}

// The regular VMT proxies for these dont work if the weapon doesnt use clips
// for some fucking reason (ie charge rifle)
var function VMTCallback_RemainingAmmo( entity ent )
{
	if ( IsLobby() )
		return 0.0

	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return 0.0

	entity weapon = player.GetActiveWeapon()
	if ( !IsValid( weapon ) )
		return 0.0

	int currentAmmo = player.GetWeaponAmmoStockpile( weapon )

	return currentAmmo
}

var function VMTCallback_RemainingAmmoColor( entity ent )
{
	if ( IsLobby() )
		return Vector( 1, 1, 1 )

	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return Vector( 1, 1, 1 )

	entity weapon = player.GetActiveWeapon()
	if ( !IsValid( weapon ) )
		return Vector( 1, 1, 1 )

	int currentAmmo = player.GetWeaponAmmoStockpile( weapon )
	int maxAmmo = weapon.GetWeaponSettingInt( eWeaponVar.ammo_stockpile_max )

	return TF1_AmmoCol( currentAmmo, maxAmmo )
}

var function VMTCallback_MaxCarryAmmo( entity ent )
{
	if ( IsLobby() )
		return 0.0

	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return 0.0

	entity weapon = player.GetActiveWeapon()
	if ( !IsValid( weapon ) )
		return 0.0

	int maxAmmo = weapon.GetWeaponSettingInt( eWeaponVar.ammo_stockpile_max )

	return maxAmmo
}

var function VMTCallback_ProScreen( entity ent )
{
#if MP
	if ( IsLobby() )
		return 0.0

	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return 0.0

	entity weapon = player.GetActiveWeapon()
	if ( !IsValid( weapon ) )
		return 0.0

	string weaponName = weapon.GetWeaponClassName()

	if ( !ItemDefined( weaponName ) )
		return 0.0

	int proScreenKills = WeaponGetProScreenKills( player, weaponName )

	return proScreenKills
#else
	return 0.0
#endif
}

var function VMTCallback_ProScreenColor( entity ent )
{
#if MP
	if ( IsLobby() )
		return Vector( 1, 1, 1 )

	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return Vector( 1, 1, 1 )

	entity weapon = player.GetActiveWeapon()
	if ( !IsValid( weapon ) )
		return Vector( 1, 1, 1 )

	vector col = GetConVarFloat3( "TF1AMMO.col_proScreen" )
#else
	vector col = GetConVarFloat3( "TF1AMMO.col_proScreenDisabled" )
#endif

 	return col * ( 1.0 / 255.0 )
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

vector function TF1_AmmoCol( int currentAmmo, int maxAmmo )
{
	vector fracHigh = GetConVarFloat3( "TF1AMMO.col_fracHigh" )
	vector fracMid = GetConVarFloat3( "TF1AMMO.col_fracMid" )
	vector fracLow = GetConVarFloat3( "TF1AMMO.col_fracLow" )

 	if ( currentAmmo <= maxAmmo * 0.1 )
 	{
 		return fracLow * (1.0 / 255.0)
 	}
 	else if ( currentAmmo < maxAmmo * 0.4 )
 	{
 		return fracMid * (1.0 / 255.0)
 	}
 	else
 	{
 		return fracHigh * (1.0 / 255.0)
 	}

	return Vector( 1, 1, 1 )
}

//Stolen from 4V (thanks nerd)
//Stolen again from Khalmee loll
vector function GetConVarFloat3( string convar )
{
    array<string> value = split( GetConVarString( convar ), " " )
    try{
        return Vector(value[0].tofloat(), value[1].tofloat(), value[2].tofloat()) 
    }
    catch(ex){
        throw "Invalid convar " + convar + "! make sure it is a float3 and formatted as \"X Y Z\""
    }
    unreachable
}

// Taken from tf1 _cl_material_proxies.nut
// Really only here for reference
// Also kinda interesting that these used to be done in script instead
// Wonder why they changed it

// Use ClipAmmoColor Proxy
// function VMTCallback_ClipAmmoColor( player )
// {
// 	if ( !player.GetActiveWeapon() )
// 		return Vector( 1, 1, 1 )
//
// 	local clipAmmo = player.GetActiveWeaponPrimaryAmmoLoaded()
// 	local maxClipAmmo = player.GetActiveWeaponPrimarymaxAmmoLoaded()
//
// 	if ( clipAmmo <= maxClipAmmo * 0.1 )
// 	{
// 		return Vector( 255, 75, 66 ) * (1.0 / 255.0)
// 	}
// 	else if ( clipAmmo < maxClipAmmo * 0.4 )
// 	{
// 		return Vector( 255, 128, 64 ) * (1.0 / 255.0)
// 	}
// 	else
// 	{
// 		return Vector( 133, 231, 255 ) * (1.0 / 255.0)
// 	}
// }

// Use BackgroundAmmoColor Proxy
// function VMTCallback_BackgroundAmmoColor( player )
// {
// 	if ( !player.GetActiveWeapon() )
// 	{
// 		return Vector( 1, 1, 1 )
// 	}
//
//
// 	local clipAmmo = player.GetActiveWeaponPrimaryAmmoLoaded()
// 	local maxClipAmmo = player.GetActiveWeaponPrimarymaxAmmoLoaded()
//
// 	if ( clipAmmo <= maxClipAmmo * 0.1 )
// 	{
// 		return Vector( 255, 175, 166 ) * (1.0 / 255.0)
// 	}
// 	else
// 	{
// 		return Vector( 255, 255, 255 ) * (1.0 / 255.0)
// 	}
// }

// Use RemainingAmmoColor instead
// function VMTCallback_RemainingAmmoColor( player )
// {
// 	if ( !player.GetActiveWeapon() )
// 		return Vector( 1, 1, 1 )
//
// 	local remainingAmmo = player.GetActiveWeaponPrimaryAmmoTotal()
// 	local maxClipAmmo = player.GetActiveWeaponPrimarymaxAmmoLoaded()
//
// 	if ( remainingAmmo <= maxClipAmmo * 1 )
// 	{
// 		return Vector( 255, 75, 66 ) * (1.0 / 255.0)
// 	}
// 	else if ( remainingAmmo <= maxClipAmmo * 3 )
// 	{
// 		return Vector( 255, 128, 64 ) * (1.0 / 255.0)
// 	}
// 	else
// 	{
// 		return Vector( 133, 231, 255 ) * (1.0 / 255.0)
// 	}
// }

// Use HoloSight
// function VMTCallback_HoloSight( entity )
// {
// 	return GetLocalViewPlayer().GetAdsFraction()
// }
