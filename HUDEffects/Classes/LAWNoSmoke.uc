// Custom class to disable SmokeTrail from all weapons
// Extending LAW Projectile + LAW itself

class LAWNoSmoke extends LAWProj;

// Override to remove smoke on ALL CLIENTS and not just dedicated servers
simulated function PostBeginPlay()
{
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