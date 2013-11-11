package undo;

import driver.util.AroundAdvice;
import driver.util.Driver;

public aspect UndoDynamic extends UndoFeature {

	pointcut driver() : if (Driver.isActivated("undo")); // true default
	
	void around() : adviceexecution() && within(UndoFeature)
		&& !@annotation(AroundAdvice) {
		if (Driver.isActivated("undo")){
			proceed();
		}
	}
}
