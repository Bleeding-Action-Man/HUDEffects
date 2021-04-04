// Written by Dr.TerV for killingfloor.ru
// Fixed by Essence & Vel-San
// Last Update: April 4th 2021
// Downsides:
// - Server is Grey-listed (Get rekt I guess)
// - Your server log will be polluted with 'Material Not found' for missing overlays

class HUDEffects extends Mutator
  Config(HUDEffects_Config);

var config bool bSpectatorOverlay, bVomitScreen, bNearDeath, bFireOverlay, bHitOverlay;

replication
{
  reliable if(Role==ROLE_Authority)
  bSpectatorOverlay, bVomitScreen, bNearDeath, bFireOverlay, bHitOverlay;
}

// Disable HUD Before player starts
simulated function PreBeginPlay()
{
  DisableHUDEffects();
  DisableMonsterEffects();
}

simulated function DisableHUDEffects()
{
  MutLog("-----|| Disabling Selected HUD Effects ||-----");
  // HUD Class Effects
  if(!bSpectatorOverlay) class'HUDKillingFloor'.Default.SpectatorOverlay=None;
  if(!bNearDeath) class'HUDKillingFloor'.Default.NearDeathOverlay=None;
  if(!bFireOverlay) class'HUDKillingFloor'.Default.FireOverlay=None;
}

simulated function DisableMonsterEffects()
{
  // TODO: Change bHitOverlay to bSlashOverlay (Siren+Stalker)
  // TODO: Create new var for the shitty retarded 'Sepia' color that ruins the colors in-game
  // TODO: Remove 'Blood' effect from clot damage or crawler etc..
  // TODO: Check all monster HUD effects
  // TODO: Check if we can completey remove screen shake without creating extra class (Might be impossible tho :/)
  // TODO: Seperate each monster modification into a function

  // Bloat Vomit
  if(!bVomitScreen)
  {
  MutLog("-----|| Disabling Bloat HUD Effect ||-----");
  Class'DamTypeVomit'.Default.HudTime=0.0;
  }

  // All hit overlays
  if(!bHitOverlay)
  {
  MutLog("-----|| Disabling Hit HUD Effect ||-----");
  Class'DamTypeZombieAttack'.Default.HudTime=0.0;
  Class'DamTypeZombieAttack'.Default.HUDDamageTex=None;
  Class'DamTypeZombieAttack'.Default.HUDUberDamageTex=None;
  Class'DamTypeSlashingAttack'.Default.HudTime=0.0;
  Class'DamTypeSlashingAttack'.Default.HUDDamageTex=None;
  Class'DamTypeSlashingAttack'.Default.HUDUberDamageTex=None;
  }
}

function TimeStampLog(coerce string s)
{
  log("["$Level.TimeSeconds$"s]" @ s, 'HUDEffects');
}

function MutLog(string s)
{
  log(s, 'HUDEffects');
}

defaultproperties
{
  GroupName="KF-HUDEffectsMut"
  FriendlyName="HUD Effects Disabler - v1.0"
  Description="Disable/enable HUD effects (Film grain, Near death screen, Bloat Vomit Overlay, Siren Shake, Fire overlay)"
  bAlwaysRelevant=True
  RemoteRole=ROLE_SimulatedProxy
  bAddToServerPackages=True
}