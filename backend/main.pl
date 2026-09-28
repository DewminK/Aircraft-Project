:- use_module(server).

:- initialization(main).

main :-
    Port = 8000,
    server:start_server(Port),
    format("Aircraft decision server running at http://localhost:~w/api/evaluate~n", [Port]),
    thread_get_message(_).
