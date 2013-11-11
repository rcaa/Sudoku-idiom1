package undo;

import java.awt.Event;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;

import javax.swing.JMenu;
import javax.swing.JMenuItem;
import javax.swing.KeyStroke;

import base.Board;
import base.BoardManager;
import base.Gui;
import base.ListenerFactory;
import base.SudokuGenerator;

public abstract privileged aspect UndoFeature {
	
	pointcut hook_createUndoItem(Gui cthis, JMenu optionsMenu) 
	 : execution(* Gui.hook_createUndoItem(..)) && this(cthis) && args(optionsMenu);
	
	before(Gui cthis, JMenu optionsMenu) : hook_createUndoItem(cthis, optionsMenu) {
		optionsMenu.add(cthis.createUndoMenuItem());
	}
	
	pointcut hook_undo(BoardManager cthis) 
	: execution(* BoardManager.hook_undo(..)) && this(cthis);
	
	before(BoardManager cthis) : hook_undo(cthis) {
		cthis.undo();
	}
	
	pointcut hook_undo2(BoardManager bm) 
	: execution(* SudokuGenerator.hook_undo2(..)) && args(bm);
	
	before(BoardManager bm) : hook_undo2(bm) {
		bm.undo();
	}
	
	public ActionListener ListenerFactory.getUndoListener() {
		return new UndoListener(bm);
	}
	
	public void BoardManager.undo() {
		if (!history.empty()) {
			board = (Board) history.pop();
			updateSudokuViews();
		}
	}	
	public JMenuItem Gui.createUndoMenuItem() {
		JMenuItem loadMenuItem = new JMenuItem();
		loadMenuItem.setText("Undo");
		loadMenuItem.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_U,
				Event.CTRL_MASK, true));
		loadMenuItem.addActionListener(listenerFactory.getUndoListener());
		return loadMenuItem;
	}
}