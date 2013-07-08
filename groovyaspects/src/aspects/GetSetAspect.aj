package aspects;




public aspect GetSetAspect {

//	@SuppressAjWarnings("adviceDidNotMatch")
//	after() : get(* val){
//		System.out.println("Got Value!");
//	}
//
//	@SuppressAjWarnings("adviceDidNotMatch")
//	after() : set(* val){
//		System.out.println("Set Value!");
//	}
//
//	@SuppressAjWarnings("adviceDidNotMatch")
//	Object around(Object o) : set(* val) && args(o){
//		return proceed(Integer.valueOf(7));
//	}
//	
//	@SuppressAjWarnings("adviceDidNotMatch")
//	after(): withincode(* setVal(..)){
//		System.out.println("WITHINCODE");
//	}
//	
//	@SuppressAjWarnings("adviceDidNotMatch")
//	after(): call(* setVal(..)){
//		System.out.println("CALL");
//	}
//	
//	@SuppressAjWarnings("adviceDidNotMatch")
//	after(): execution(* setVal(..)){
//		System.out.println("EXECUTION");
//	}
//	
//	@SuppressAjWarnings("adviceDidNotMatch")
//	after(): initialization(myObject.new(..)) && !within(GetSetAspect){
//		System.out.println("INITIALIZATION");
//	}
//	
//	@SuppressAjWarnings("adviceDidNotMatch")
//	after(): preinitialization(myObject.new()) && !withincode(* Wrapper.getMatchingAdvices(..)){
//		System.out.println("PREINITIALIZATION");
//		
//	}
//	
//	@SuppressAjWarnings("adviceDidNotMatch")
//	after(): staticinitialization(myObject){
//		System.out.println("STATICINITIALIZATION");
//	}
	
}
