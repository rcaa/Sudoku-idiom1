package guesser;

import driver.util.AroundAdvice;
import driver.util.Driver;

public aspect GuesserDynamic extends GuesserFeature {

	pointcut driver() : if (Driver.isActivated("guesser")); // true default
	
	void around() : adviceexecution() && within(GuesserFeature)
		&& !@annotation(AroundAdvice) {
		if (Driver.isActivated("guesser")){
			proceed();
		}
	}
}
