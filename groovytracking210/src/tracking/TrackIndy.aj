package tracking;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.reflect.Method;

import org.aspectj.lang.annotation.SuppressAjWarnings;

import de.ecspride.indyaspectwrapper.model.MemberNameInfo;
import de.ecspride.indyaspectwrapper.util.Java7ReflectionHelper;
import de.ecspride.indyaspectwrapper.wrapper.MethodHandleWrapper;

public aspect TrackIndy {

	// Map<CallSite, Object[]> trackedCallSites = new HashMap<CallSite,
	// Object[]>();
	//
	// // tracking bootstrap method and wrap with aspects
	// @SuppressAjWarnings("adviceDidNotMatch")
	// CallSite around(String name, MethodType type) :
	// execution(CallSite *.*bootstrap(..)) && args(Lookup, *, type, name, ..)
	// && !within(tracking..*) && !within(wrapper..*){
	//
	// CallSite cs = proceed(name, type);
	//
	// // CallSite Method Dispatch
	// // if (!"runScript, <init>, println, name, getLogger".contains(name)) {
	// // cs = wrapper.wrapandinject(cs, name, type);
	// // trackedCallSites.put(cs, new Object[] { name, type });
	// // }
	//
	// System.err.println("CallSite: " + cs.dynamicInvoker().toString() +
	// " Args: " + Arrays.toString(thisJoinPoint.getArgs()) + " -> "
	// + name + " = " + type.toMethodDescriptorString());
	//
	// return cs;
	// }

	Java7ReflectionHelper java7ReflectionHelper = new Java7ReflectionHelper();
	MethodHandleWrapper wrapper = new MethodHandleWrapper(this.getClass().getCanonicalName());

	@SuppressAjWarnings("adviceDidNotMatch")
	MethodHandle around() :
	 call(MethodHandle MethodHandles.explicitCastArguments(..)) &&
	 withincode(void *.setCallSiteTarget(..)) {

		MethodHandle mh = proceed();

		MemberNameInfo mni = java7ReflectionHelper.getInsideMemberNameInfo(mh);
		try {
			Method inside = mni.getDeclaringClass().getDeclaredMethod(mni.getName(), mni.getMethodType().parameterArray());
			inside.setAccessible(true);

			mh = wrapper.getWrappedMethodHandleWithMethod(inside, mh);

		} catch (Throwable e) {
			e.printStackTrace();
		}

		return mh;
	}

}
