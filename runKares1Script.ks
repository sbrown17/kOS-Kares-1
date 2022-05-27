function main {
    launchStart().
    print "Lift Off!".
    ascentGuidance().
    until apoapsis > 70000 {
        ascentStaging().
    }
    // circularizationBurn().
    // spacecraftConfigManeuver().
    // munarTransferBurn().
    // munarOrbitalBurn().


}

function launchStart {
    sas OFF.
    print "Guidance internal".
    lock throttle to 1.
    for i in range(0,10){
        print "Countdown: " + (10 - i).
        wait 1.
    }
    print "All systems go.".
    stageRocket().
}

function stageRocket {
    wait until stage:ready.
    stage.
}

function ascentGuidance {
    // what if we reverse the heading angles so that we can fly a space shuttle on its back similar to IRL
    until altitude > 200 {
        lock steering to heading(0, 85).
    }
    // this is some silly thing wolfram did, im betting a simpler equation could work better (logarithmic! not quadratic!!!!)
    //lock targetPitch to 88.963 - 1.03287 * alt:radar^0.409511.
    // lets try nat. log (e ^ 2)
    lock targetPitch to alt:radar * constant:e ^ 2.
    lock steering to heading(0, targetPitch).
}

function ascentStaging {
    if not(defined oldThrust) {
    global oldThrust is ship:availablethrust.
  }
  if ship:availablethrust < (oldThrust - 10) {
    until false {
      stageRocket(). wait 1.
      if ship:availableThrust > 0 { 
        break.
      }
    }
    global oldThrust is ship:availablethrust.
  }
}
main().