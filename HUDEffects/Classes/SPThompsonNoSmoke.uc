class SPThompsonNoSmoke extends MuzzleFlash1stSPThompson;

simulated function Trigger(Actor Other, Pawn EventInstigator)
{
	Emitters[0].SpawnParticle(2);
	Emitters[1].SpawnParticle(3);
	// Emitters[2].SpawnParticle(1); // Remove Muzzle Smoke
}