Oberon Desktop Calculator (CAS)

Calc.Reset
Calc.Set  alpha := 33H  beta := 1000H  ~
Calc.List

Calc.Hex alpha + beta
Calc.Dec alpha^2 * 3
Calc.Char "j" + 7
Calc.Real cos pi

Warning:
	Due to Texts scanner problems, a "-" should be
	followed by a digit or a space to get proper results !

Expression Syntax:
	Expr = Term {AddOp Term}.
	Term = Factor {MulOp Factor}.
	Factor = Atom {PowOp Atom}.
	Atom = Number | Functor Atom | ident | "(" Expr ")".
	PowOp = "^".
	MulOp = "*" | "/" | "%" | "<" | ">".	-- % modulo, < shift left, > shift right
	AddOp = ["+" | "-"].	-- no add op: addition(!)
	Number = (digit {digit}) | (digit {hexDigit} "H") | (digit {hexDigit} "X") | (""" char """).
	Functor = "arccos" | "arcsin" | "arctan" | "cos" | "entier" | "exp" | "ln" | "short" | "sign" | "sin" | "sqrt" | "tan".

All operators except for "^" are left-associative; "^" is right-associative.