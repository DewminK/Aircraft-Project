:- module(rules, [
    % Aircraft identity
    correct_aircraft_model/0,

    % Weight rules
    takeoff_weight_exceeded/0,
    landing_weight_exceeded/0,
    zero_fuel_weight_exceeded/0,
    fuel_capacity_exceeded/0,

    % Aircraft system rules
    engine_problem/0,
    flight_control_problem/0,
    landing_gear_problem/0,
    hydraulic_problem/0,
    electrical_problem/0,
    aircraft_system_problem/0,

    % Takeoff rules
    takeoff_runway_unavailable/0,
    takeoff_clearance_missing/0,
    takeoff_configuration_invalid/0,
    takeoff_runway_condition_poor/0,

    % Landing rules
    landing_runway_unavailable/0,
    approach_speed_above_reference/0,
    approach_speed_below_reference/0,
    crosswind_condition_high/0,
    landing_runway_condition_poor/0,

    % Environmental rules
    poor_visibility/0,
    adverse_weather/0,

    % Decision rules
    departure_not_recommended/0,
    landing_not_recommended/0,
    go_around_recommended/0,

    departure_decision/1,
    landing_decision/1
]).

:- use_module(facts).


/*
   ============================================================
   AIRCRAFT IDENTITY
   ============================================================
*/

correct_aircraft_model :-
    facts:aircraft_model(a350_900).


/*
   ============================================================
   WEIGHT RULES
   ============================================================
*/

takeoff_weight_exceeded :-
    facts:current_aircraft_weight(Weight),
    facts:maximum_takeoff_weight(Max),
    Weight > Max.


landing_weight_exceeded :-
    facts:current_landing_weight(Weight),
    facts:maximum_landing_weight(Max),
    Weight > Max.


zero_fuel_weight_exceeded :-
    facts:current_zero_fuel_weight(Weight),
    facts:maximum_zero_fuel_weight(Max),
    Weight > Max.


fuel_capacity_exceeded :-
    facts:current_fuel_capacity(Fuel),
    facts:maximum_fuel_capacity(Max),
    Fuel > Max.


/*
   ============================================================
   AIRCRAFT SYSTEM RULES
   ============================================================
*/

engine_problem :-
    facts:engine_status(fault).


flight_control_problem :-
    facts:flight_controls(fault).


landing_gear_problem :-
    facts:landing_gear(fault).


hydraulic_problem :-
    facts:hydraulic_system(fault).


electrical_problem :-
    facts:electrical_system(fault).


aircraft_system_problem :-
    engine_problem.

aircraft_system_problem :-
    flight_control_problem.

aircraft_system_problem :-
    landing_gear_problem.

aircraft_system_problem :-
    hydraulic_problem.

aircraft_system_problem :-
    electrical_problem.


/*
   ============================================================
   TAKEOFF RULES
   ============================================================
*/

takeoff_runway_unavailable :-
    facts:takeoff_runway_available(no).


takeoff_clearance_missing :-
    facts:takeoff_clearance(no).


takeoff_configuration_invalid :-
    facts:takeoff_configuration(not_configured).


takeoff_runway_condition_poor :-
    facts:takeoff_runway_condition(poor).


/*
   ============================================================
   LANDING RULES
   ============================================================
*/

landing_runway_unavailable :-
    facts:landing_runway_available(no).


approach_speed_above_reference :-
    facts:approach_speed(Speed),
    facts:reference_final_approach_speed(Reference),
    Speed > Reference.


approach_speed_below_reference :-
    facts:approach_speed(Speed),
    facts:reference_final_approach_speed(Reference),
    Speed < Reference.


crosswind_condition_high :-
    facts:crosswind_speed(Speed),
    Speed >= 20.


landing_runway_condition_poor :-
    facts:landing_runway_condition(poor).


/*
   ============================================================
   ENVIRONMENT RULES
   ============================================================
*/

poor_visibility :-
    facts:visibility_condition(poor).


adverse_weather :-
    facts:weather_condition(adverse).


/*
   ============================================================
   DEPARTURE DECISION RULES
   ============================================================
*/

departure_not_recommended :-
    takeoff_weight_exceeded.

departure_not_recommended :-
    zero_fuel_weight_exceeded.

departure_not_recommended :-
    fuel_capacity_exceeded.

departure_not_recommended :-
    aircraft_system_problem.

departure_not_recommended :-
    takeoff_runway_unavailable.

departure_not_recommended :-
    takeoff_clearance_missing.

departure_not_recommended :-
    takeoff_configuration_invalid.

departure_not_recommended :-
    takeoff_runway_condition_poor.

departure_not_recommended :-
    adverse_weather.

departure_not_recommended :-
    poor_visibility.


/*
   ============================================================
   LANDING DECISION RULES
   ============================================================
*/

landing_not_recommended :-
    landing_weight_exceeded.

landing_not_recommended :-
    landing_runway_unavailable.

landing_not_recommended :-
    landing_gear_problem.

landing_not_recommended :-
    landing_runway_condition_poor.


/*
   ============================================================
   GO-AROUND RULES
   ============================================================
*/

go_around_recommended :-
    approach_speed_above_reference,
    facts:go_around_available(yes).

go_around_recommended :-
    approach_speed_below_reference,
    facts:go_around_available(yes).

go_around_recommended :-
    crosswind_condition_high,
    facts:go_around_available(yes).

go_around_recommended :-
    poor_visibility,
    facts:go_around_available(yes).


/*
   ============================================================
   FINAL DECISIONS
   ============================================================
*/

departure_decision(not_recommended) :-
    departure_not_recommended.

departure_decision(recommended) :-
    correct_aircraft_model,
    \+ departure_not_recommended.


landing_decision(not_recommended) :-
    landing_not_recommended.

landing_decision(go_around) :-
    \+ landing_not_recommended,
    go_around_recommended.

landing_decision(recommended) :-
    \+ landing_not_recommended,
    \+ go_around_recommended.