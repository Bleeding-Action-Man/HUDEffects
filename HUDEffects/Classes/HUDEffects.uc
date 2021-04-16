// Written by Dr.TerV for killingfloor.ru
// Fixed by Essence & Vel-San
// Last Update: April 9th 2021
// Downsides:
// - Server is Grey-listed (Get rekt I guess)
// - Client log will be polluted with 'Material Not found' for missing overlays
//    > Can be fixed by simply replaceing 'None' with a transparent material
// - Client will still see the grain ONLY in lobby, once they join the game it will disapear

class HUDEffects extends Mutator
  Config(HUDEffects_Config);

// Config Vars & Structs
struct HUD_Effects
{
  var config bool bSpectatorOverlay, bNearDeath, bFireOverlay,
                  bShittySepia, bDoorUseMessage, bDoorSealedMessage, bZedTimeMessage;
};

struct ZED_Effects
{
  var config bool bVomitScreen, bSlashOverlay;
};

struct Weapon_Effects
{
  var config bool bSmokeTrail;
};

// I'm retarded & have no clue, even after researching a shitton on the topic
// Why COUNT=1 results in an Illegal expression...
const COUNT = 2;

// 3 Lists of the above structs
var() config HUD_Effects aHUD_Effects[COUNT];
var() config ZED_Effects aZED_Effects[COUNT];
var() config Weapon_Effects aWeapon_Effects[COUNT];

// 3 Local var lists of the above structs
var HUD_Effects TmpHUD_Effects[COUNT];
var ZED_Effects TmpZED_Effects[COUNT];
var Weapon_Effects TmpWeapon_Effects[COUNT];

replication
{
  reliable if(Role==ROLE_Authority)
             aHUD_Effects, aZED_Effects, aWeapon_Effects,
             TmpHUD_Effects, TmpZED_Effects, TmpWeapon_Effects;
}

// Disable Selected options Before player starts
simulated function PostBeginPlay()
{
  setTimer(1, false);
}

simulated function Timer()
{
  // Get Server Vars
  GetServerVars();

  if (!isServer())
  {
    DisableHUDEffects();
  }
  else MutLog("-----|| Server detected - Modifying only 'Client' HUDs to avoid log file flooding ||-----");

  DisableMonsterEffects();
  DisableWeaponEffects();
}

simulated function bool isServer()
{
  if (Level.NetMode == NM_DedicatedServer) return true;
  else return false;
}

simulated function DisableHUDEffects()
{
  MutLog("-----|| Disabling Selected HUD Effects ||-----");
  if(!TmpHUD_Effects[0].bSpectatorOverlay) class'HUDKillingFloor'.Default.SpectatorOverlay=None;
  if(!TmpHUD_Effects[0].bNearDeath) class'HUDKillingFloor'.Default.NearDeathOverlay=None;
  if(!TmpHUD_Effects[0].bFireOverlay) class'HUDKillingFloor'.Default.FireOverlay=None;
  if(!TmpHUD_Effects[0].bShittySepia) class'HUDKillingFloor'.Default.VisionOverlay=None;
  if(!TmpHUD_Effects[0].bDoorUseMessage) class'WaitingMessage'.Default.DoorMessage="";
  if(!TmpHUD_Effects[0].bDoorSealedMessage) class'WaitingMessage'.Default.WeldedShutMessage="";
  if(!TmpHUD_Effects[0].bZedTimeMessage) class'WaitingMessage'.Default.ZEDTimeActiveMessage="";
}

simulated function DisableMonsterEffects()
{
  MutLog("-----|| Disabling Selected Monster Effects ||-----");
  // TODO: Remove 'Blood' effect from clot damage or crawler etc..
  // TODO: Check all monster HUD effects
  // TODO: Check if we can completey remove screen shake without creating extra class (Might be impossible tho :/)

  // Bloat Vomit
  if(!TmpZED_Effects[0].bVomitScreen) DisableVomit();

  // Slash hit overlays
  if(!TmpZED_Effects[0].bSlashOverlay) DisableSirenStalkerSlash();
}

simulated function DisableWeaponEffects()
{
  // TODO: Add support for all weapons that have 'Rocket Trail' except SeekerSix, all my homies hate SeekerSix
  // TODO: Maybe add option for 'Rocket/Grenade Smoke Explosion' & not just trail ?
  MutLog("-----|| Disabling Selected Weapon Effects ||-----");
  if(!TmpWeapon_Effects[0].bSmokeTrail) DisableSmokeTrail();
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

simulated function DisableSmokeTrail()
{
  MutLog("-----|| Disabling Grenade Launchers Smoke Trail Effect ||-----");
  Class'M79Fire'.Default.ProjectileClass=Class'HUDEffects.M79NoSmoke';
  Class'GoldenM79Fire'.Default.ProjectileClass=Class'HUDEffects.M79NoSmoke';
  Class'M32Fire'.Default.ProjectileClass=Class'HUDEffects.M32NoSmoke';
  Class'CamoM32Fire'.Default.ProjectileClass=Class'HUDEffects.M32NoSmoke';
  Class'M203Fire'.Default.ProjectileClass=Class'HUDEffects.M203NoSmoke';
  Class'LAWFire'.Default.ProjectileClass=Class'HUDEffects.LAWNoSmoke';
  Class'FlareRevolverFire'.Default.ProjectileClass=Class'HUDEffects.FlareRevolversNoSmoke';
  Class'DualFlareRevolverFire'.Default.ProjectileClass=Class'HUDEffects.FlareRevolversNoSmoke';
}

simulated function GetServerVars()
{
  MutLog("-----|| Fetching Server Vars ||-----");

  TmpHUD_Effects[0] = aHUD_Effects[0];
  TmpZED_Effects[0] = aZED_Effects[0];
  TmpWeapon_Effects[0] = aWeapon_Effects[0];
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
  FriendlyName="HUD Effects Disabler - v1.4"
  Description="Disable annoying HUD effects; Made by Flame, Essence, Dr.Terv & Vel-San."
  bAlwaysRelevant=True
  RemoteRole=ROLE_SimulatedProxy
  bAddToServerPackages=True
}