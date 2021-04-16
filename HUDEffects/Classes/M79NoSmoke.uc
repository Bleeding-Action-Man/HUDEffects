// Custom class to disable SmokeTrail from all weapons
// Extending M79 Projectile + M79 itself

class M79NoSmoke extends M79GrenadeProjectile;

// Override to remove smoke on ALL CLIENTS and not just dedicated servers
simulated function PostBeginPlay()
{
  local rotator SmokeRotation;

  BCInverse = 1 / BallisticCoefficient;

  OrigLoc = Location;

  if( !bDud )
  {
    Dir = vector(Rotation);
    Velocity = speed * Dir;
  }

  if (PhysicsVolume.bWaterVolume)
  {
    bHitWater = True;
    Velocity=0.6*Velocity;
  }
  super(Projectile).PostBeginPlay();
}