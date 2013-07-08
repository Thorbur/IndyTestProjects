package aspects;

import org.aspectj.lang.annotation.SuppressAjWarnings;

public aspect MeetingAspect {
	pointcut greeting() : 
	      call (public * *.greet(..));
	
	pointcut meeting() : call(public * *..meets(..));
	

	@SuppressAjWarnings("adviceDidNotMatch")
	after(): greeting() {
		ask();
	}
	
	@SuppressAjWarnings("adviceDidNotMatch")
	before(): meeting(){
		System.out.println("We have a meeting!");
	}
	
	void ask(){
		System.out.println("WE: Do you speak English?");
	}
	
	@SuppressAjWarnings("adviceDidNotMatch")
	void around() : greeting(){
		System.out.print("STRANGER: ");
		proceed();
	}

}
