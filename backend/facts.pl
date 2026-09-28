:- module(facts, [
    aircraft_model/1,
    aircraft_manufacturer/1,
    maximum_takeoff_weight/1,
    maximum_landing_weight/1,
    maximum_zero_fuel_weight/1,
    maximum_fuel_capacity/1,
    cruise_mach/1,
    maximum_seating_capacity/1,
    approach_category/1,
    reference_final_approach_speed/1,

    current_aircraft_weight/1,
    current_landing_weight/1,
    current_zero_fuel_weight/1,
    current_fuel_capacity/1,

    engine_status/1,
    flight_controls/1,
    landing_gear/1,
    hydraulic_system/1,
    electrical_system/1,

    takeoff_runway_available/1,
    takeoff_clearance/1,

    landing_runway_available/1,
    landing_runway_condition/1,
    approach_speed/1,
    go_around_available/1,

    airport_condition/1,
    flight_phase/1
]).

% Allow scenario facts to be changed at runtime

:- dynamic current_aircraft_weight/1.
:- dynamic current_landing_weight/1.
:- dynamic current_zero_fuel_weight/1.
:- dynamic current_fuel_capacity/1.

:- dynamic engine_status/1.
:- dynamic flight_controls/1.
:- dynamic landing_gear/1.
:- dynamic hydraulic_system/1.
:- dynamic electrical_system/1.

:- dynamic takeoff_runway_available/1.
:- dynamic takeoff_clearance/1.

:- dynamic landing_runway_available/1.
:- dynamic landing_runway_condition/1.
:- dynamic approach_speed/1.
:- dynamic go_around_available/1.

:- dynamic airport_condition/1.
:- dynamic flight_phase/1.

/*
   ============================================================
   AIRBUS A350-900 REFERENCE SPECIFICATIONS
   ============================================================
*/

aircraft_model(a350_900).

aircraft_manufacturer(airbus).

% Airbus published maximum values
maximum_takeoff_weight(283000).       % kg
maximum_landing_weight(207000).       % kg
maximum_zero_fuel_weight(195700).     % kg
maximum_fuel_capacity(166488).        % litres

cruise_mach(0.85).

maximum_seating_capacity(440).

% Airbus documented aircraft approach category
approach_category(c).

% Airbus final approach speed at MLW
reference_final_approach_speed(140).  % knots

current_aircraft_weight(250000).

current_landing_weight(195000).

current_zero_fuel_weight(180000).

current_fuel_capacity(120000).

engine_status(normal).

flight_controls(normal).

landing_gear(normal).

hydraulic_system(normal).

electrical_system(normal).

takeoff_runway_available(yes).

takeoff_clearance(yes).

landing_runway_available(yes).

landing_runway_condition(dry).

approach_speed(140).

go_around_available(yes).

airport_condition(normal).

flight_phase(pre_takeoff).