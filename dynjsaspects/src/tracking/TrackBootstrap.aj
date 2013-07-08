package tracking;

import java.lang.invoke.CallSite;
import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles.Lookup;
import java.lang.invoke.MethodType;
import java.lang.reflect.Constructor;
import java.lang.reflect.Method;
import java.util.Arrays;

import org.aspectj.lang.annotation.SuppressAjWarnings;

public aspect TrackBootstrap {

	static MethodType mt;

	// track bootstrap
	@SuppressAjWarnings("adviceDidNotMatch")
	CallSite around(String identifier, MethodType type) : execution(CallSite *.*(..)) && args(Lookup, identifier, type, ..) && !within(tracking..*) && !within(wrapper..*){

		CallSite cs = proceed(identifier, type);

		System.out.println("BOOTSTRAP = " + thisJoinPoint.getSignature() + " METHODHANDLE: " + cs.dynamicInvoker().toString() + " ARGS: "
				+ Arrays.toString(thisJoinPoint.getArgs()) + " : " + identifier + ", " + type.toMethodDescriptorString());

		mt = type;

		return cs;
	}

	// track CallSite Creations
	@SuppressAjWarnings("adviceDidNotMatch")
	CallSite around() : execution(CallSite *.*(..)) && !within(tracking..*) && !within(wrapper..*){

		System.out.print("CHANGED CALLSITE: " + thisJoinPoint.getSignature() + " ARGS: ");
		for (Object arg : thisJoinPoint.getArgs()) {
			System.out.print(arg.toString());
		}
		System.out.println();

		return proceed();

	}

	// track CallSite.setTarget
	@SuppressAjWarnings("adviceDidNotMatch")
	Object around() : call(* CallSite.setTarget(..)) && !within(tracking..*) && !within(wrapper..*){

		System.out.print("SET CALLSITE TARGET: " + thisJoinPoint.getSignature() + " ARGS: ");
		for (Object arg : thisJoinPoint.getArgs()) {
			System.out.print(arg.toString());
		}
		System.out.println();

		return proceed();

	}

	// track MethodHandle Creation
	@SuppressAjWarnings("adviceDidNotMatch")
	MethodHandle around() : execution(MethodHandle *.*(..)) && !within(tracking..*) && !within(wrapper..*){

		MethodHandle mh = proceed();

		System.out.println("METHODHANDLE = " + thisJoinPoint.getSignature() + " METHODHANDLE: " + mh.toString() + " ARGS: "
				+ Arrays.toString(thisJoinPoint.getArgs()));
		
		Class<?> mhn;
		try {
			mhn = Class.forName("java.lang.invoke.MethodHandleNatives");
			Constructor<?> con = mhn.getDeclaredConstructor();
			con.setAccessible(true);
			Object mhnInstance = con.newInstance();
			Method getTargetMethod = mhn.getDeclaredMethod("getTargetMethod", new Class<?>[]{MethodHandle.class});
			getTargetMethod.setAccessible(true);
			Method inside = (Method) getTargetMethod.invoke(mhnInstance, mh);
			System.out.println("INSIDE = " + inside.toGenericString());
			
		} catch (Throwable e) {
			e.printStackTrace();
		}

		return mh;
	}

	// track MethodHandle.invoke
	@SuppressAjWarnings("adviceDidNotMatch")
	Object around(Object[] args) : call(* MethodHandle.invoke*(..)) && args(args) && !within(tracking..*) && !within(wrapper..*){

		System.out.println("INVOKE = " + thisJoinPoint.getSignature() + " ARGS: " + Arrays.toString(args));

		return proceed(args);

	}

	// track Lookup
	@SuppressAjWarnings("adviceDidNotMatch")
	after(Class<?> refc, String name, MethodType type) returning (MethodHandle mh):
		 call(* Lookup.findStatic(..)) && args(refc, name, type, ..) && !within(wrapper..*) {

		System.out.println("LOOKUP = " + thisJoinPoint.getSignature() + " ARGS: " + Arrays.toString(thisJoinPoint.getArgs()));
	}

	// track greet
	@SuppressAjWarnings("adviceDidNotMatch")
	Object around() : execution(* *.*greet*(..)) && !within(tracking..*) && !within(wrapper..*){

		System.out.println("FOUND! = " + thisJoinPoint.getSignature());

		return proceed();

	}

}
