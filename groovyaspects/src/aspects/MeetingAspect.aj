package aspects;

import org.aspectj.lang.annotation.SuppressAjWarnings;

public aspect MeetingAspect {

	pointcut greeting() : call (public * *.greet(..));

	pointcut meeting() : call(public * *..meets(..));

	pointcut meetingWhom(Object o) : call(public * *..meets(..)) && args(o) && !within(wrapper..*);

	void ask() {
		System.out.println("WE: Do you speak English?");
	}

	@SuppressAjWarnings("adviceDidNotMatch")
	after(): greeting() {
		ask();
	}

	@SuppressAjWarnings("adviceDidNotMatch")
	before(): meeting(){
		System.out.print("We ");
	}

	@SuppressAjWarnings("adviceDidNotMatch")
	before(): meeting(){
		System.out.print("have ");
	}

	@SuppressAjWarnings("adviceDidNotMatch")
	before(): meeting(){
		System.out.print("a ");
	}

	@SuppressAjWarnings("adviceDidNotMatch")
	before(): meeting(){
		System.out.println("meeting!");
	}

	@SuppressAjWarnings("adviceDidNotMatch")
	after(Object o) returning() : meetingWhom(o){
		System.out.println("He was very polite.");
	}

	@SuppressAjWarnings("adviceDidNotMatch")
	after(Object o) returning() : meetingWhom(o){
		System.out.println("The " + o.getClass().getName() + " was nice.");
	}

	@SuppressAjWarnings("adviceDidNotMatch")
	after(Object o): call(public * *..meets(..)) && args(o) && !within(wrapper..*){
		System.out.println("We met a " + o.getClass().getName() + ".");
	}

	@SuppressAjWarnings("adviceDidNotMatch")
	void around() : greeting(){
		System.out.print("STRANGER ");
		proceed();
		System.out.println("WITH A FRIENDLY SMILE.");
	}

	@SuppressAjWarnings("adviceDidNotMatch")
	before(): greeting() {
		System.out.print("YOU ARE MEETING ");
	}

	@SuppressAjWarnings("adviceDidNotMatch")
	void around() : greeting(){
		System.out.print("SAYS: ");
		proceed();
		System.out.print("AND NODS ");
	}

	// test parameter name resolution
	// @SuppressAjWarnings("adviceDidNotMatch")
	// after(Object o, Object kkk, Object x, Object y): call(public *
	// *..meets(..)) && args(o, kkk) && !within(wrapper..*) && this(x) &&
	// target(y){
	// System.out.println("We met a " + o.getClass().getName());
	// }

	// Test execution pointcut
	// @SuppressAjWarnings("adviceDidNotMatch")
	// after() : execution(* *..meets(..)){
	// System.out.println("EXECUTION WORKS!");
	// }

	// test if pointcut
	// pointcut secondMeeting(Object person) : meeting() && args(person) &&
	// if(true); //person.getClass().getName().contains("Japanese"));
	//
	// @SuppressAjWarnings("adviceDidNotMatch")
	// after(Object person) : secondMeeting(person) {
	// System.out.println("We met two People.");
	// }

	// test thisJoinPoint
	// @SuppressAjWarnings("adviceDidNotMatch")
	// after() : greeting(){
	// System.out.println(thisJoinPoint.getTarget());
	// }

	// test parameter bindings
	// @SuppressAjWarnings("adviceDidNotMatch")
	// after(CallSite cs): call(public * *..meets(..)) && args(cs) &&
	// !within(wrapper..*){
	// System.out.println("We met a " + cs.getClass().getName());
	// }

	// test absolut types
	// @SuppressAjWarnings("adviceDidNotMatch")
	// after(): call(void MeetingAspect.ask(..)) && !within(wrapper..*){
	// System.out.println("ASKED!");
	// }

}
