// Material proxy to hide ammo counters while cloaked
// Taken from CRF (Thanks, Creamy) and renamed so it doesn't cause any issues

global function VMTCallback_CloakToAlpha_TF1
global function VMTCallback_CloakToAlpha_Blank

var function VMTCallback_CloakToAlpha_TF1( entity ent )
{
	if( IsCloaked( ent ) || IsLobby() )
		return 0.0
	else
		return 1.0
}

var function VMTCallback_CloakToAlpha_Blank( entity ent )
{
	bool shouldShow = GetConVarBool( "TF1AMMO.blank_rounds" )

	if( IsLobby() )
		return 0.0

	if( IsCloaked( ent ) )
		return 0.0
	else
		return shouldShow
}
