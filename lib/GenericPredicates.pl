% map (+L, +Mapper, -Lo)
% where Mapper = mapper(I, O, UNARY_OP)
% e.g. Mapper = mapper(X, Y, Y is X + 1)
map([], _, []).
map([H | T], M, [H2 | T2]) :-
	map(T, M, T2), copy_term(M, mapper(H, H2, OP)), call(OP).

% filter(+L, +Predicate, -Lo)
% where Predicate = predicate(I, UNARY_OP)
% e.g. Predicate = predicate(X, X > 3)
filter([], _, []).
filter([H | T], P, [H | T2]) :- filter(T, P, T2), copy_term(P, predicate(H, OP)), call(OP), !.
filter([H | T], P, L) :- filter(T, P, L).

% reduce(+L, +Reducer, -Res)
% where Reducer = reducer(I1, I2, O, BINARY_OP)
% e.g. Reducer = reducer(X, Y, Z, Z is X + Y)
reduce([H], _, H).
reduce([H, H2 | T], R, Res) :- copy_term(R, reducer(H, H2, Res1, OP)), call(OP), reduce([Res1 | T], R, Res).

% foldLeft(+L, +Z, +Folder, -Res)
% where Z is the initial value
% Folder = folder(I1, I2, O, BINARY_OP)
% e.g. Z = 5, Folder = folder(X, Y, Z, Z is X + Y)
foldLeft([], H, _, H).
foldLeft([H | T], Z, F, Res) :- copy_term(F, folder(H, Z, Res1, OP)), call(OP), foldLeft(T, Res1, F, Res).

% foldRight(+L, +Z, + Folder, -Res)
% where Z is the initial value
% Folder = folder(I1, I2, O, BINARY_OP)
% The difference from foldLeft is that it starts from the end of the list
% e.g. Z = 5, Folder = folder(Y, X, Z, Z is X + Y)
foldRight([], H, _, H).
foldRight([H | T], Z, F, Res) :- foldRight(T, Z, F, Res2), copy_term(F, folder(Res2, H, Res, OP)), call(OP).

map_folded(L, mapper(H, H2, OP), LO) :- foldRight(L, [], folder(Z, H, [H2 | Z], OP), LO).

reduce_folded([H | T], reducer(X, Y, O, OP), L) :- foldLeft(T, H, folder(Y, X, O, OP), L).
