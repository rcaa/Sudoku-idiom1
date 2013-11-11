package base;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class SudokuGenerator {

	public Board generate() {

		Board board = new Board();

		fillBoard(board);

		makeSolvable(board, 50);

		return board;
	}

	private void fillBoard(Board board) {
		BoardManager bm = new BoardManager();

		Random r = new Random();

		bm.setBoard(board);

		int fieldsToFill = Field.POSSIBILITIES * Field.POSSIBILITIES;

		// set all fields with random numbers if possible
		// try to solve, if not possible remove one number and try again...

		for (int i = 0; i < fieldsToFill; i++) {

			int row = r.nextInt(Field.POSSIBILITIES);
			int fieldIndex = r.nextInt(Field.POSSIBILITIES);

			List remainingPos = bm.getField(Structure.ROW, row, fieldIndex)
					.getRemainingPos();

			if (remainingPos.size() > 0) {
				int value = (Integer) remainingPos.get(r.nextInt(remainingPos
						.size()));

				boolean result = bm.trySetFieldPrivate(Structure.ROW, row,
						fieldIndex, new Field(value, true));

				if (!result) {
					hook_undo2(bm);
				}

			} else {
				hook_undo2(bm);
			}

		}

	}

	private void hook_undo2(BoardManager bm) {
		// bm.undo();
	}

	private boolean makeSolvable(Board board, int steps) {
		BoardManager bm = new BoardManager();
		bm.setBoard(board);
		Random r = new Random();
		int k = steps;

		try {

			// board filled, check solution
			List solutions = hook_solveSudokuGenerator(board, bm);
			boolean solvable = !solutions.isEmpty();
			while (k > 0) {
				// remove random number and try again
				board.removeRandomSetField();

				solutions = hook_solveSudokuGenerator(board, bm);
				if (!solutions.isEmpty()) {
					return true;
				}
				k--;
			}

		} catch (CloneNotSupportedException e) {

		}
		return false;
	}

	private List hook_solveSudokuGenerator(Board board, BoardManager bm)
			throws CloneNotSupportedException {
		//bm.solve((Board) board.clone());
		return new ArrayList();
	}

}
