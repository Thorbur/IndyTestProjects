package tracking;

import java.lang.invoke.CallSite;
import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.MethodHandles.Lookup;
import java.lang.invoke.MethodType;
import java.lang.reflect.Method;
import java.util.Arrays;

import org.aspectj.lang.annotation.SuppressAjWarnings;

import de.ecspride.indyaspectwrapper.model.MemberNameInfo;
import de.ecspride.indyaspectwrapper.util.Java7ReflectionHelper;
import de.ecspride.indyaspectwrapper.wrapper.MethodHandleWrapper;

public aspect TrackIndy {

	@SuppressAjWarnings("adviceDidNotMatch")
	CallSite around(String name, MethodType type) :
	 execution(CallSite *.*bootstrap*(..)) && args(Lookup, name, type, ..) && !within(tracking..*) && !within(wrapper..*){

		CallSite cs = proceed(name, type);

//		if (!"runScript, <init>, println".contains(name)) {
//			cs = wrapper.Wrapper.wrapandinject(cs, name, type);
//		}

		System.err.println(" CallSite: " + cs.dynamicInvoker().toString() + " Args: "
				+ Arrays.toString(thisJoinPoint.getArgs()) + " : " + name + ", " + type.toMethodDescriptorString());
		
		System.err.println(Java7ReflectionHelper.getInsideMethod(cs.getTarget()));

		return cs;
	}


	@SuppressAjWarnings("adviceDidNotMatch")
	@SuppressWarnings("rawtypes")
	after(Class c, Object o) returning(CallSite cs) : call(* *(..)) && args(.., c, o) && !within(tracking..*) && !within(wrapper..*){

		System.err.println("FOUND! CallSite: " + cs.dynamicInvoker().toString() + " Args: " + c.getCanonicalName() + ", "
				+ o.getClass().getName());
		for (Class<?> cl : ((Class[]) o)) {
			System.err.println(cl.getCanonicalName());
		}
	}
	
	Java7ReflectionHelper java7ReflectionHelper = new Java7ReflectionHelper();
	MethodHandleWrapper wrapper = new MethodHandleWrapper(this.getClass().getCanonicalName());
	
	@SuppressAjWarnings("adviceDidNotMatch")
	MethodHandle around() : 
		call(MethodHandle MethodHandles.explicitCastArguments(..)) && !within(tracking..*) && !within(wrapper..*) {

		MethodHandle mh = proceed();

		MemberNameInfo mni = java7ReflectionHelper.getInsideMemberNameInfo(mh);
		try {
			Method inside = mni.getDeclaringClass().getDeclaredMethod(mni.getName(), mni.getMethodType().parameterArray());
			inside.setAccessible(true); // TODO: needed?

			mh = wrapper.getWrappedMethodHandleWithMethod(inside, mh);

		} catch (Throwable e) {
			e.printStackTrace();
		}

		return mh;
	}
	
}
