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
	L2 = lists:flatten(L1),
	L3 = dict:to_list(same_fun_name_map(L2, dict:new())),
	lists:sort(fun({_, N1}, {_, N2}) -> 
		N1 > N2
	end, L3).



same_fun_name_map([], Dict) ->
	Dict;

same_fun_name_map([H | T], Dict) ->
	Dict1 = case dict:is_key(H, Dict) of
			true -> dict:update(H, fun(Value) -> Value + 1 end, Dict);
			false -> dict:store(H, 1, Dict)
		end,
	same_fun_name_map(T, Dict1).

% count_functions([], X) ->
% 	X;

% count_functions([H|T], #{H => N} = X) ->
% 	count_functions(T, X#{H := N+1});
% count_functions([H|T], X) ->
% 	count_functions(T, X#{H => 1}).

% count_characters(Str) ->
% 	count_characters(Str, #{}).

% count_characters([H|T], #{ H => N } = X) ->
% 	count_characters(T, X#{ H := N+1});

% count_characters([H|T], X) ->
% 	count_characters(T, X#{ H => 1});
% count_characters([], X) ->
% 	X.


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