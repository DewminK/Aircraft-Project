:- module(inference, [
    backward_chain/2,
    forward_chain/2
]).

:- use_module(rules).


/*
   ============================================================
   BACKWARD CHAINING
   ============================================================
*/

backward_chain(departure, Result) :-
    rules:departure_decision(Result).

backward_chain(landing, Result) :-
    rules:landing_decision(Result).


/*
   ============================================================
   FORWARD CHAINING
   ============================================================
*/

forward_chain(departure, DerivedFacts) :-
    findall(Fact,
        departure_fact(Fact),
        Facts),
    sort(Facts, DerivedFacts).

forward_chain(landing, DerivedFacts) :-
    findall(Fact,
        landing_fact(Fact),
        Facts),
    sort(Facts, DerivedFacts).


/*
   ============================================================
   DERIVED DEPARTURE FACTS
   ============================================================
*/

departure_fact(correct_aircraft_model) :-
    rules:correct_aircraft_model.

departure_fact(takeoff_weight_exceeded) :-
    rules:takeoff_weight_exceeded.

departure_fact(landing_weight_exceeded) :-
    rules:landing_weight_exceeded.

departure_fact(zero_fuel_weight_exceeded) :-
    rules:zero_fuel_weight_exceeded.

departure_fact(fuel_capacity_exceeded) :-
    rules:fuel_capacity_exceeded.

departure_fact(engine_problem) :-
    rules:engine_problem.

departure_fact(flight_control_problem) :-
    rules:flight_control_problem.

departure_fact(landing_gear_problem) :-
    rules:landing_gear_problem.

departure_fact(hydraulic_problem) :-
    rules:hydraulic_problem.

departure_fact(electrical_problem) :-
    rules:electrical_problem.

departure_fact(takeoff_runway_unavailable) :-
    rules:takeoff_runway_unavailable.

departure_fact(takeoff_clearance_missing) :-
    rules:takeoff_clearance_missing.

departure_fact(takeoff_configuration_invalid) :-
    rules:takeoff_configuration_invalid.

departure_fact(takeoff_runway_condition_poor) :-
    rules:takeoff_runway_condition_poor.

departure_fact(poor_visibility) :-
    rules:poor_visibility.

departure_fact(adverse_weather) :-
    rules:adverse_weather.

departure_fact(departure_not_recommended) :-
    rules:departure_not_recommended.


/*
   ============================================================
   DERIVED LANDING FACTS
   ============================================================
*/

landing_fact(landing_weight_exceeded) :-
    rules:landing_weight_exceeded.

landing_fact(landing_runway_unavailable) :-
    rules:landing_runway_unavailable.

landing_fact(landing_gear_problem) :-
    rules:landing_gear_problem.

landing_fact(landing_runway_condition_poor) :-
    rules:landing_runway_condition_poor.

landing_fact(approach_speed_above_reference) :-
    rules:approach_speed_above_reference.

landing_fact(approach_speed_below_reference) :-
    rules:approach_speed_below_reference.

landing_fact(crosswind_condition_high) :-
    rules:crosswind_condition_high.

landing_fact(poor_visibility) :-
    rules:poor_visibility.

landing_fact(go_around_recommended) :-
    rules:go_around_recommended.

landing_fact(landing_not_recommended) :-
    rules:landing_not_recommended.