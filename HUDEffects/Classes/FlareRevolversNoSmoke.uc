// Custom class to disable SmokeTrail from all weapons
// Extending Flare Revolvers Projectile + FlareRevolver and Duals itself

class FlareRevolversNoSmoke extends FlareRevolverProjectile;

// Override to remove smoke on ALL CLIENTS and not just dedicated servers
simulated function PostBeginPlay()
{
  OrigLoc = Location;

  if( !bDud )
  {
    Dir = vector(Rotation);
    Velocity = speed * Dir;
  }

  super(ROBallisticProjectile).PostBeginPlay();
}