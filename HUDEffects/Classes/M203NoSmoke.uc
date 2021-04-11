// Custom class to disable SmokeTrail from all weapons
// Extending M32 Projectile + M32 itself

class M203NoSmoke extends M79NoSmoke;

defaultproperties
{
  MyDamageType=Class'KFMod.DamTypeM203Grenade'
}

