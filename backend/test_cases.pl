:- begin_tests(flightpilot).

:- use_module(facts).
:- use_module(rules).
:- use_module(inference).


/*
   ============================================================
   HELPER
   ============================================================
*/

set_departure_scenario(
    Weight,
    ZeroFuelWeight,
    Fuel,
    Engine,
    Controls,
    Gear,
    Runway,
    Clearance,
    Configuration,
    Weather,
    Visibility
) :-

    retractall(facts:current_aircraft_weight(_)),
    assertz(facts:current_aircraft_weight(Weight)),

    retractall(facts:current_zero_fuel_weight(_)),
    assertz(facts:current_zero_fuel_weight(ZeroFuelWeight)),

    retractall(facts:current_fuel_capacity(_)),
    assertz(facts:current_fuel_capacity(Fuel)),

    retractall(facts:engine_status(_)),
    assertz(facts:engine_status(Engine)),

    retractall(facts:flight_controls(_)),
    assertz(facts:flight_controls(Controls)),

    retractall(facts:landing_gear(_)),
    assertz(facts:landing_gear(Gear)),

    retractall(facts:takeoff_runway_available(_)),
    assertz(facts:takeoff_runway_available(Runway)),

    retractall(facts:takeoff_clearance(_)),
    assertz(facts:takeoff_clearance(Clearance)),

    retractall(facts:takeoff_configuration(_)),
    assertz(facts:takeoff_configuration(Configuration)),

    retractall(facts:weather_condition(_)),
    assertz(facts:weather_condition(Weather)),

    retractall(facts:visibility_condition(_)),
    assertz(facts:visibility_condition(Visibility)).


/*
   ============================================================
   TC01 - NORMAL DEPARTURE
   ============================================================
*/

test(normal_departure) :-

    set_departure_scenario(
        250000,
        180000,
        120000,
        normal,
        normal,
        normal,
        yes,
        yes,
        configured,
        normal,
        good
    ),

    inference:backward_chain(
        departure,
        recommended
    ).


/*
   ============================================================
   TC02 - TAKEOFF WEIGHT EXCEEDED
   ============================================================
*/

test(takeoff_weight_exceeded) :-

    set_departure_scenario(
        290000,
        180000,
        120000,
        normal,
        normal,
        normal,
        yes,
        yes,
        configured,
        normal,
        good
    ),

    rules:takeoff_weight_exceeded,

    inference:backward_chain(
        departure,
        not_recommended
    ).


/*
   ============================================================
   TC03 - ZERO FUEL WEIGHT EXCEEDED
   ============================================================
*/

test(zero_fuel_weight_exceeded) :-

    set_departure_scenario(
        250000,
        200000,
        120000,
        normal,
        normal,
        normal,
        yes,
        yes,
        configured,
        normal,
        good
    ),

    rules:zero_fuel_weight_exceeded,

    inference:backward_chain(
        departure,
        not_recommended
    ).


/*
   ============================================================
   TC04 - ENGINE FAULT
   ============================================================
*/

test(engine_fault) :-

    set_departure_scenario(
        250000,
        180000,
        120000,
        fault,
        normal,
        normal,
        yes,
        yes,
        configured,
        normal,
        good
    ),

    rules:engine_problem,

    inference:backward_chain(
        departure,
        not_recommended
    ).


/*
   ============================================================
   TC05 - RUNWAY UNAVAILABLE
   ============================================================
*/

test(runway_unavailable) :-

    set_departure_scenario(
        250000,
        180000,
        120000,
        normal,
        normal,
        normal,
        no,
        yes,
        configured,
        normal,
        good
    ),

    rules:takeoff_runway_unavailable,

    inference:backward_chain(
        departure,
        not_recommended
    ).


/*
   ============================================================
   TC06 - CLEARANCE MISSING
   ============================================================
*/

test(clearance_missing) :-

    set_departure_scenario(
        250000,
        180000,
        120000,
        normal,
        normal,
        normal,
        yes,
        no,
        configured,
        normal,
        good
    ),

    rules:takeoff_clearance_missing,

    inference:backward_chain(
        departure,
        not_recommended
    ).


/*
   ============================================================
   TC07 - POOR VISIBILITY
   ============================================================
*/

test(poor_visibility) :-

    set_departure_scenario(
        250000,
        180000,
        120000,
        normal,
        normal,
        normal,
        yes,
        yes,
        configured,
        normal,
        poor
    ),

    rules:poor_visibility,

    inference:backward_chain(
        departure,
        not_recommended
    ).


/*
   ============================================================
   TC08 - ADVERSE WEATHER
   ============================================================
*/

test(adverse_weather) :-

    set_departure_scenario(
        250000,
        180000,
        120000,
        normal,
        normal,
        normal,
        yes,
        yes,
        configured,
        adverse,
        good
    ),

    rules:adverse_weather,

    inference:backward_chain(
        departure,
        not_recommended
    ).


/*
   ============================================================
   TC09 - HIGH APPROACH SPEED
   ============================================================
*/

test(high_approach_speed) :-

    retractall(facts:current_landing_weight(_)),
    assertz(facts:current_landing_weight(195000)),

    retractall(facts:approach_speed(_)),
    assertz(facts:approach_speed(150)),

    retractall(facts:landing_runway_available(_)),
    assertz(facts:landing_runway_available(yes)),

    retractall(facts:landing_runway_condition(_)),
    assertz(facts:landing_runway_condition(dry)),

    retractall(facts:landing_gear(_)),
    assertz(facts:landing_gear(normal)),

    retractall(facts:go_around_available(_)),
    assertz(facts:go_around_available(yes)),

    rules:approach_speed_above_reference,

    inference:backward_chain(
        landing,
        go_around
    ).


/*
   ============================================================
   TC10 - LOW APPROACH SPEED
   ============================================================
*/

test(low_approach_speed) :-

    retractall(facts:current_landing_weight(_)),
    assertz(facts:current_landing_weight(195000)),

    retractall(facts:approach_speed(_)),
    assertz(facts:approach_speed(130)),

    retractall(facts:landing_runway_available(_)),
    assertz(facts:landing_runway_available(yes)),

    retractall(facts:landing_runway_condition(_)),
    assertz(facts:landing_runway_condition(dry)),

    retractall(facts:landing_gear(_)),
    assertz(facts:landing_gear(normal)),

    retractall(facts:go_around_available(_)),
    assertz(facts:go_around_available(yes)),

    rules:approach_speed_below_reference,

    inference:backward_chain(
        landing,
        go_around
    ).


/*
   ============================================================
   TC11 - LANDING WEIGHT EXCEEDED
   ============================================================
*/

test(landing_weight_exceeded) :-

    retractall(facts:current_landing_weight(_)),
    assertz(facts:current_landing_weight(210000)),

    rules:landing_weight_exceeded,

    inference:backward_chain(
        landing,
        not_recommended
    ).


/*
   ============================================================
   TC12 - LANDING RUNWAY UNAVAILABLE
   ============================================================
*/

test(landing_runway_unavailable) :-

    retractall(facts:current_landing_weight(_)),
    assertz(facts:current_landing_weight(195000)),

    retractall(facts:landing_runway_available(_)),
    assertz(facts:landing_runway_available(no)),

    rules:landing_runway_unavailable,

    inference:backward_chain(
        landing,
        not_recommended
    ).


/*
   ============================================================
   TC13 - HIGH CROSSWIND
   ============================================================
*/

test(high_crosswind) :-

    retractall(facts:current_landing_weight(_)),
    assertz(facts:current_landing_weight(195000)),

    retractall(facts:landing_runway_available(_)),
    assertz(facts:landing_runway_available(yes)),

    retractall(facts:landing_runway_condition(_)),
    assertz(facts:landing_runway_condition(dry)),

    retractall(facts:landing_gear(_)),
    assertz(facts:landing_gear(normal)),

    retractall(facts:crosswind_speed(_)),
    assertz(facts:crosswind_speed(25)),

    retractall(facts:go_around_available(_)),
    assertz(facts:go_around_available(yes)),

    rules:crosswind_condition_high,

    inference:backward_chain(
        landing,
        go_around
    ).


/*
   ============================================================
   TC14 - FORWARD CHAINING
   ============================================================
*/

test(forward_chaining) :-

    set_departure_scenario(
        290000,
        180000,
        120000,
        normal,
        normal,
        normal,
        yes,
        yes,
        configured,
        normal,
        good
    ),

    inference:forward_chain(
        departure,
        DerivedFacts
    ),

    member(
        takeoff_weight_exceeded,
        DerivedFacts
    ),

    member(
        departure_not_recommended,
        DerivedFacts
    ).


/*
   ============================================================
   TC15 - BACKWARD CHAINING
   ============================================================
*/

test(backward_chaining) :-

    set_departure_scenario(
        290000,
        180000,
        120000,
        normal,
        normal,
        normal,
        yes,
        yes,
        configured,
        normal,
        good
    ),

    inference:backward_chain(
        departure,
        not_recommended
    ).


:- end_tests(flightpilot).