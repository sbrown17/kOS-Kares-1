global stagingRocket TO FALSE.
function main {
    launchStart().
    print "Lift Off!".
    ascentGuidance().
    until apoapsis > 95000 {
        abortSystemMonitor().
        ascentStaging().
    }
    // circularizationBurn().
    // spacecraftConfigManeuver().
    // munarTransferBurn().
    // munarOrbitalBurn().
    

}

function launchStart {
    sas OFF.
    print "Guidance Internal".
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
    SET stagingRocket TO TRUE.
    PRINT "Staging rocket...".
    stage.
    SET stagingRocket TO FALSE.
}

function ascentGuidance {
    lock targetPitch to 88.963 - 1.03287 * alt:radar^0.409511.
    // lets try nat. log (e ^ 2)
    //lock targetPitch to alt:radar * constant:e ^ 2.
    lock steering to heading(90, targetPitch).
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

function abortSystemMonitor {
    // mass differential detection
    // find smallest mass of object that could cause catastrophic loss and monitor for instantaneous loss of said mass or above?
    // MUST NOT BE MONITORED DURING STAGING
    // Account for inclination change that is too severe
    PRINT "Monitoring for abort procedure...".
    UNTIL (not stagingRocket and Constant:g0 > 10) {
        GLOBAL SHIPMASS IS MASS.
        WAIT 0.1.
        IF (MASS < SHIPMASS - 0.16) {
            ABORT ON.
            WAIT 1.
            stageRocket().
        }
    }
}
main().
