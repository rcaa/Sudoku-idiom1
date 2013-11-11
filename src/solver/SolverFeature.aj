package solver;

import java.util.LinkedList;
import java.util.List;

import base.Board;
import base.BoardManager;
import base.Guesser;

public abstract privileged aspect SolverFeature {
	
	pointcut hook_generateSolutions(BoardManager cthis) 
	 : execution(* BoardManager.hook_generateSolutions(..)) && this(cthis);
	
	List around(BoardManager cthis) throws CloneNotSupportedException : hook_generateSolutions(cthis) {
		return cthis.solve((Board) cthis.board.clone());
	}
	
	pointcut hook_solveSudokuGenerator(Board board, BoardManager bm) : execution(* BoardManager.hook_solveSudokuGenerator(..)) && args(board, bm);
	
	List around(Board board, BoardManager bm) throws CloneNotSupportedException : hook_solveSudokuGenerator(board, bm) {
		return bm.solve((Board) board.clone());
	}
	
	public List BoardManager.solve(Board board) {
		List solutions = new LinkedList();
		List solvers = new LinkedList();
		solvers.add(new ForcedField());
		solvers.add(new ForcedNumber());
		for (int i = 0; i < solvers.size(); i++)
			if (!((Solver) solvers.get(i)).trySolve(board))
				return solutions;
		if (!board.isSolved()) {
			hook_guesser(board, solutions);
		} else {
			solutions.add(board);
		}
		return solutions;
	}

	private void BoardManager.hook_guesser(Board board, List solutions) {
//		Guesser guesser = new Guesser();
//		List guessed = guesser.guess(board);
//		for (int i = 0; i < guessed.size(); i++)
//			solutions.addAll(solve(((Board) guessed.get(i))));
	}
}
