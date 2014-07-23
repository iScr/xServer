-module (module_test).
-compile(export_all).

return_most_fun_of_module() ->

	Mod_and_fun_list = mod_and_fun_list(),

	F2 = fun({Mod, FunList}) ->
		{Mod, length(FunList)}
	end,

	L1 = [F2(X) || X <- Mod_and_fun_list],
	[H | _T] = lists:reverse(qsort(L1)),
	H.

	% lists:sort(fun({_, N1}, {_, N2}) -> 
	% 	N1 > N2
	% end, L1).


	% length(Mod_and_fun_list).

% [{Module, [fun, fun...]}, {Module, [fun, fun...]}]

return_most_fun_name() ->
	Mod_and_fun_list = mod_and_fun_list(),
	L1 = [X || {_Mod, X } <- Mod_and_fun_list],
	L2 = lists:flatten(L1).

same_fun_name_map([], Map) ->
	Map;

same_fun_name_map([H | T], Map) ->
	case maps:is_key(H, Map) of
		true -> same_fun_name_map(T, Map#{H := maps:get(H, Map) + 1});
		false -> same_fun_name_map(T, Map#{H => 1})
	end.


mod_and_fun_list() ->
	Mod_list = [Mod || {Mod, _File} <- code:all_loaded()],

	F1 = fun(Mod) -> 
		[{exports, FunList} | _T] = apply(Mod, module_info, []),
		{Mod, FunList}
	end,

	[F1(Mod)  || Mod <- Mod_list].



qsort([])-> [];
qsort([H|T]) ->
	{_, CntH} = H, 
	qsort([{Mod, CntX} || {Mod, CntX} <-T, CntX < CntH]) 
	++ [H] ++
	qsort([{Mod, CntX} || {Mod, CntX} <- T,  CntX >= CntH]).