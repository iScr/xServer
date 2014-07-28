-module (area_server_final).
-compile(export_all).

start() -> spawn(area_server_final, loop, []).

area(Pid, What) -> rpc(Pid, What).


loop() ->
	receive 
		{From, {rectangle, W, H}} ->
			From ! {self(), W * H},
			loop();
		{From, {circle, R}} ->
			From ! {self(), R * R * 3.14},
			loop();
		{From, Other} ->
			From ! {self(), {error, Other}},
			loop()
	end.


rpc(Pid, Request) ->
	Pid ! {self(), Request},
	receive 
		{Pid, Response} ->
			Response
	end.