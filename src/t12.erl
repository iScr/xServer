-module (t12).
-compile(export_all).


start() -> register(start, spawn(?MODULE, loop, [])).

start(AnAtom, Fun) ->
	rpc(start, {AnAtom, Fun}).
	


rpc(Pid, Request) ->
	% io:format("do rpc"),
	Pid ! {self(), Request},
	receive 
		{Pid, Response} ->
			io:format("rpc return ~p~n", [Response]);
		Other ->
			io:format("rpc receive other ~p~n", [Other])
	end.


loop() ->
	receive 
		{From, {AnAtom, Fun}} ->
			case whereis(AnAtom) of
				undefined ->
					Result = register(AnAtom, spawn(Fun)),

					From ! {self(),Result},
					loop();

				Pid ->
					From ! {self(), {error, Pid}},
					loop()
			end;
		{From, Other} ->
			io:format("loop other ~n"),
			From ! {error, {other, Other}},
			loop()
	end.



test() ->
	spawn(fun() -> start(test, fun() -> test1 end) end),
	spawn(fun() -> start(test, fun() -> test1 end) end),
	spawn(fun() -> start(test, fun() -> test1 end) end),
	spawn(fun() -> start(test, fun() -> test1 end) end).



