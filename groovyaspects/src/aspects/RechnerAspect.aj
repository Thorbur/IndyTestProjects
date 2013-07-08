package aspects;

import java.util.HashMap;
import java.util.Map;

import org.aspectj.lang.annotation.SuppressAjWarnings;

public aspect RechnerAspect {
	
	pointcut add(Object a, Object b): call(* *.indyAdd(..)) && args(a, b);
	pointcut sub(Object a, Object b): call(* *.indySub(..)) && args(a, b);
	pointcut mul(Object a, Object b): call(* *.indyMul(..)) && args(a, b);
	pointcut div(Object a, Object b): call(* *.indyDiv(..)) && args(a, b);
	
	pointcut register(Object name, Object o): call(* *.register(..)) && args(name, o);
	
	Map<String, Object> objectDB = new HashMap<String, Object>();
	
	@SuppressAjWarnings("adviceDidNotMatch")
	Object around(Object a, Object b): add(a, b) {

		Object erg = proceed(a, b);
		
		appendHistory(a, b, erg, '+');
		clearInput();
		
		return erg;
	}
	
	@SuppressAjWarnings("adviceDidNotMatch")
	Object around(Object a, Object b): sub(a, b) {

		Object erg = proceed(a, b);
		
		appendHistory(a, b, erg, '-');
		clearInput();
		
		return erg;
	}
	
	@SuppressAjWarnings("adviceDidNotMatch")
	Object around(Object a, Object b): mul(a, b) {

		Object erg = proceed(a, b);
		
		appendHistory(a, b, erg, '*');
		clearInput();
		
		return erg;
	}
	
	@SuppressAjWarnings("adviceDidNotMatch")
	Object around(Object a, Object b): div(a, b) {

		Object erg = proceed(a, b);
		
		appendHistory(a, b, erg, '/');
		clearInput();
		
		return erg;
	}
	
	private void appendHistory(Object a, Object b, Object erg, char op){
		
		javax.swing.JTextArea history = (javax.swing.JTextArea) objectDB.get("history");
		history.append(a + " " + op + " " + b + " = " + erg + "\n");
	}
	
	private void clearInput(){
		javax.swing.JTextField op1 = (javax.swing.JTextField) objectDB.get("op1");
		javax.swing.JTextField op2 = (javax.swing.JTextField) objectDB.get("op2");

		op1.setText("");
		op2.setText("");
	}
	
	@SuppressAjWarnings("adviceDidNotMatch")
	after(Object name, Object instance) : register(name, instance) {
		
		objectDB.put((String)name, instance);
		
		if(name.equals("erg")){
			javax.swing.JTextField erg = (javax.swing.JTextField) instance;
			erg.setEditable(false);
		}
		
		if(name.equals("frame")){
			javax.swing.JFrame frame = (javax.swing.JFrame) instance;
			frame.setResizable(false);
		}
	}

}
