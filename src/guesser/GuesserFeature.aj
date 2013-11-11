package guesser;

import java.util.List;

import base.Board;
import base.BoardManager;

public abstract privileged aspect GuesserFeature {

	pointcut hook_guesser(BoardManager cthis, Board board, List solutions) 
	 : execution(* BoardManager.id_pattern(..)) && this(cthis) && args(board, solutions);
	
	before(BoardManager cthis, Board board, List solutions) : hook_guesser(cthis, board, solutions) {
		Guesser guesser = new Guesser();
		List guessed = guesser.guess(board);
		for (int i = 0; i < guessed.size(); i++)
			solutions.addAll(cthis.solve(((Board) guessed.get(i))));
	}
}