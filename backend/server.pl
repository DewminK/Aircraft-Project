:- module(server, [start_server/1]).

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_cors)).

:- use_module(facts).
:- use_module(inference).
:- use_module(explanation).

% Allow the React dev server (and any other origin) to call this API.
:- set_setting(http:cors, [*]).

:- http_handler(
    root(api/evaluate),
    evaluate_handler,
    [methods([get,post,options])]
).


start_server(Port) :-
    http_server(http_dispatch, [port(Port)]).


evaluate_handler(Request) :-
    memberchk(method(options), Request),
    !,
    cors_enable(Request, [
        methods([post])
    ]),
    format("Content-type: text/plain~n~n").

evaluate_handler(Request) :-
    cors_enable(Request, [
        methods([post])
    ]),

    http_read_json_dict(Request, Input),

    update_facts(Input),

    to_atom(Input.get(decisionType), DecisionType),

    get_decision(
        DecisionType,
        Decision
    ),

    get_derived_facts(
        DecisionType,
        DerivedFacts
    ),

    get_explanation(
        DecisionType,
        Explanation
    ),

    reply_json_dict(_{
        decision: Decision,
        derivedFacts: DerivedFacts,
        explanation: Explanation,
        aircraft: "Airbus A350-900"
    }).


/*
   ============================================================
   UPDATE FACTS
   ============================================================
*/

update_facts(Input) :-

    retractall(facts:current_aircraft_weight(_)),
    assertz(
        facts:current_aircraft_weight(
            Input.get(aircraftWeight)
        )
    ),

    retractall(facts:current_landing_weight(_)),
    assertz(
        facts:current_landing_weight(
            Input.get(landingWeight)
        )
    ),

    retractall(facts:current_zero_fuel_weight(_)),
    assertz(
        facts:current_zero_fuel_weight(
            Input.get(zeroFuelWeight)
        )
    ),

    retractall(facts:current_fuel_capacity(_)),
    assertz(
        facts:current_fuel_capacity(
            Input.get(fuelQuantity)
        )
    ),

    to_atom(Input.get(engineStatus), EngineStatus),
    retractall(facts:engine_status(_)),
    assertz(facts:engine_status(EngineStatus)),

    to_atom(Input.get(flightControls), FlightControls),
    retractall(facts:flight_controls(_)),
    assertz(facts:flight_controls(FlightControls)),

    to_atom(Input.get(landingGear), LandingGear),
    retractall(facts:landing_gear(_)),
    assertz(facts:landing_gear(LandingGear)),

    to_atom(Input.get(hydraulicSystem), HydraulicSystem),
    retractall(facts:hydraulic_system(_)),
    assertz(facts:hydraulic_system(HydraulicSystem)),

    to_atom(Input.get(electricalSystem), ElectricalSystem),
    retractall(facts:electrical_system(_)),
    assertz(facts:electrical_system(ElectricalSystem)),

    to_atom(Input.get(takeoffRunwayAvailable), TakeoffRunwayAvailable),
    retractall(facts:takeoff_runway_available(_)),
    assertz(facts:takeoff_runway_available(TakeoffRunwayAvailable)),

    to_atom(Input.get(takeoffClearance), TakeoffClearance),
    retractall(facts:takeoff_clearance(_)),
    assertz(facts:takeoff_clearance(TakeoffClearance)),

    to_atom(Input.get(landingRunwayAvailable), LandingRunwayAvailable),
    retractall(facts:landing_runway_available(_)),
    assertz(facts:landing_runway_available(LandingRunwayAvailable)),

    to_atom(Input.get(landingRunwayCondition), LandingRunwayCondition),
    retractall(facts:landing_runway_condition(_)),
    assertz(facts:landing_runway_condition(LandingRunwayCondition)),

    retractall(facts:approach_speed(_)),
    assertz(
        facts:approach_speed(
            Input.get(approachSpeed)
        )
    ),

    to_atom(Input.get(goAroundAvailable), GoAroundAvailable),
    retractall(facts:go_around_available(_)),
    assertz(facts:go_around_available(GoAroundAvailable)).


/*
   ============================================================
   HELPERS
   ============================================================
*/

% Converts JSON string values (and numbers/atoms) into atoms,
% since http_read_json_dict/2 returns string values by default
% but the rule base compares against atoms (e.g. `normal`, `fault`).
to_atom(Value, Atom) :-
    ( string(Value) -> atom_string(Atom, Value) ; Atom = Value ).


/*
   ============================================================
   DECISION
   ============================================================
*/

get_decision(departure, Decision) :-
    inference:backward_chain(
        departure,
        Decision
    ).

get_decision(landing, Decision) :-
    inference:backward_chain(
        landing,
        Decision
    ).


/*
   ============================================================
   FORWARD-CHAINING OUTPUT
   ============================================================
*/

get_derived_facts(departure, Facts) :-
    inference:forward_chain(
        departure,
        Facts
    ).

get_derived_facts(landing, Facts) :-
    inference:forward_chain(
        landing,
        Facts
    ).


/*
   ============================================================
   EXPLANATION
   ============================================================
*/

get_explanation(departure, Explanation) :-
    explanation:departure_explanation(
        Explanation
    ).

get_explanation(landing, Explanation) :-
    explanation:landing_explanation(
        Explanation
    ).