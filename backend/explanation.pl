:- module(explanation, [
    departure_explanation/1,
    landing_explanation/1
]).

:- use_module(rules).


/*
   ============================================================
   DEPARTURE EXPLANATIONS
   ============================================================
*/

departure_explanation(Reasons) :-
    findall(Reason,
        departure_reason(Reason),
        Reasons).


departure_reason(
    'The aircraft weight exceeds the configured A350-900 maximum takeoff weight.'
) :-
    rules:takeoff_weight_exceeded.


departure_reason(
    'The zero-fuel weight exceeds the configured A350-900 maximum zero-fuel weight.'
) :-
    rules:zero_fuel_weight_exceeded.


departure_reason(
    'The configured fuel quantity exceeds the A350-900 maximum fuel capacity.'
) :-
    rules:fuel_capacity_exceeded.


departure_reason(
    'An aircraft system problem has been detected.'
) :-
    rules:aircraft_system_problem.


departure_reason(
    'The takeoff runway is unavailable.'
) :-
    rules:takeoff_runway_unavailable.


departure_reason(
    'Takeoff clearance has not been received.'
) :-
    rules:takeoff_clearance_missing.


departure_reason(
    'The aircraft is not in the configured takeoff configuration.'
) :-
    rules:takeoff_configuration_invalid.


departure_reason(
    'The configured runway condition is poor.'
) :-
    rules:takeoff_runway_condition_poor.


departure_reason(
    'The configured weather condition is adverse.'
) :-
    rules:adverse_weather.


departure_reason(
    'The configured visibility condition is poor.'
) :-
    rules:poor_visibility.


departure_reason(
    'All checked departure conditions satisfy the configured rules.'
) :-
    \+ rules:departure_not_recommended.


/*
   ============================================================
   LANDING EXPLANATIONS
   ============================================================
*/

landing_explanation(Reasons) :-
    findall(Reason,
        landing_reason(Reason),
        Reasons).


landing_reason(
    'The landing weight exceeds the configured A350-900 maximum landing weight.'
) :-
    rules:landing_weight_exceeded.


landing_reason(
    'The landing runway is unavailable.'
) :-
    rules:landing_runway_unavailable.


landing_reason(
    'A landing gear problem has been detected.'
) :-
    rules:landing_gear_problem.


landing_reason(
    'The configured landing runway condition is poor.'
) :-
    rules:landing_runway_condition_poor.


landing_reason(
    'The approach speed is above the documented reference approach speed.'
) :-
    rules:approach_speed_above_reference.


landing_reason(
    'The approach speed is below the documented reference approach speed.'
) :-
    rules:approach_speed_below_reference.


landing_reason(
    'The configured crosswind condition has reached the educational warning threshold.'
) :-
    rules:crosswind_condition_high.


landing_reason(
    'The configured visibility condition is poor.'
) :-
    rules:poor_visibility.


landing_reason(
    'A go-around is recommended because one or more landing conditions triggered the go-around rules.'
) :-
    rules:go_around_recommended.


landing_reason(
    'All checked landing conditions satisfy the configured rules.'
) :-
    \+ rules:landing_not_recommended,
    \+ rules:go_around_recommended.