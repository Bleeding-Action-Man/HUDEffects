// Written by Dr.TerV for killingfloor.ru
// Fixed by Essence & Vel-San
// Last Update: April 4th 2021
// Downsides:
// - Server is Grey-listed (Get rekt I guess)
// - Client log will be polluted with 'Material Not found' for missing overlays
// - Client will still see the grain ONLY in lobby, once they join the game
// it will disapear

// TODO: Make the mut client side only, servers shouldn't trigger this at all

class HUDEffects extends Mutator
  Config(HUDEffects_Config);

var config bool bSpectatorOverlay, bNearDeath, bFireOverlay, bShittySepia, bVomitScreen, bSlashOverlay;

replication
{
  reliable if(Role==ROLE_Authority)
  bSpectatorOverlay, bNearDeath, bFireOverlay, bShittySepia, bVomitScreen, bSlashOverlay;
}

// Disable Selected options Before player starts
simulated function PostNetBeginPlay()
{
  if (!isServer())
  {
    DisableHUDEffects();
    DisableMonsterEffects();
  }
  else MutLog("-----|| Server detected - 'HUD' will only modify clients ||-----");
}

simulated function bool isServer()
{
  if (Level.NetMode != NM_Client) return true;
  else return false;
}

simulated function DisableHUDEffects()
{
  MutLog("-----|| Disabling Selected HUD Effects ||-----");
  // HUD Class Effects
  if(!bSpectatorOverlay) class'HUDKillingFloor'.Default.SpectatorOverlay=None;
  if(!bNearDeath) class'HUDKillingFloor'.Default.NearDeathOverlay=None;
  if(!bFireOverlay) class'HUDKillingFloor'.Default.FireOverlay=None;
  if(!bShittySepia) class'HUDKillingFloor'.Default.VisionOverlay=None;
}

simulated function DisableMonsterEffects()
{
  // TODO: Remove 'Blood' effect from clot damage or crawler etc..
  // TODO: Check all monster HUD effects
  // TODO: Check if we can completey remove screen shake without creating extra class (Might be impossible tho :/)

  // Bloat Vomit
  if(!bVomitScreen) DisableVomit();

  // Slash hit overlays
  if(!bSlashOverlay) DisableSirenStalkerSlash();
}

simulated function DisableVomit()
{
  MutLog("-----|| Disabling Bloat HUD Effect ||-----");
  Class'DamTypeVomit'.Default.HudTime=0.0;
}

simulated function DisableSirenStalkerSlash()
{
  MutLog("-----|| Disabling Siren & Stalker Slash Hit HUD Effect ||-----");
  Class'DamTypeZombieAttack'.Default.HudTime=0.0;
  Class'DamTypeZombieAttack'.Default.HUDDamageTex=None;
  Class'DamTypeZombieAttack'.Default.HUDUberDamageTex=None;
  Class'DamTypeSlashingAttack'.Default.HudTime=0.0;
  Class'DamTypeSlashingAttack'.Default.HUDDamageTex=None;
  Class'DamTypeSlashingAttack'.Default.HUDUberDamageTex=None;
}

simulated function TimeStampLog(coerce string s)
{
  log("["$Level.TimeSeconds$"s]" @ s, 'HUDEffects');
}

simulated function MutLog(string s)
{
  log(s, 'HUDEffects');
}

defaultproperties
{
  GroupName="KF-HUDEffectsMut"
  FriendlyName="HUD Effects Disabler - v1.0"
  Description="Disable/enable HUD effects (Film grain, Near death screen, Fire overlay, Sepia Color overlay, Bloat vomit, Siren/Stalker slash)"
  bAlwaysRelevant=True
  RemoteRole=ROLE_SimulatedProxy
  bAddToServerPackages=True
}