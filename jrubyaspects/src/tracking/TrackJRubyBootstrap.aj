package tracking;

import java.lang.invoke.CallSite;
import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles.Lookup;
import java.lang.invoke.MethodType;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import org.aspectj.lang.annotation.SuppressAjWarnings;
import org.jruby.internal.runtime.methods.DynamicMethod;

import de.ecspride.indyaspectwrapper.util.Java8ReflectionHelper;

public aspect TrackJRubyBootstrap {

	Map<CallSite, Object[]> trackedCallSites = new HashMap<CallSite, Object[]>();

	@SuppressAjWarnings("adviceDidNotMatch")
	CallSite around(Lookup lookup, String name, MethodType type) :
	 execution(CallSite *.*(..)) && args(lookup, name, type, ..) && !within(tracking..*) && !within(wrapper..*){

		CallSite cs = proceed(lookup, name, type);

		System.out.println("CallSite: " + cs.dynamicInvoker().toString() + " ARGS: " + Arrays.toString(thisJoinPoint.getArgs()));
		// System.out.println("INTERNAL = " + Java8ReflectionHelper.getInsideMemberNameInfo(cs.getTarget()).getName());

		/*
		 * String identifier = name; if (name.contains(":")) { identifier =
		 * identifier.split(":")[1]; }
		 */

		// Get meets Method Object
		/*
		 * if (identifier.equals("meets")) try { cs = Wrapper.wrapandinject(cs,
		 * identifier, type);
		 * 
		 * List<Class<?>> parameters = new ArrayList<Class<?>>();
		 * parameters.add(lookup.lookupClass());
		 * parameters.add(org.jruby.runtime.ThreadContext.class);
		 * parameters.add(org.jruby.runtime.builtin.IRubyObject.class);
		 * parameters.add(org.jruby.runtime.builtin.IRubyObject.class);
		 * parameters.add(org.jruby.runtime.Block.class);
		 * 
		 * Class<?>[] pars = new Class<?>[parameters.size()]; int i = 0; for
		 * (Class<?> c : parameters) { pars[i] = c; i++; }
		 * 
		 * Method m =
		 * lookup.lookupClass().getDeclaredMethod("method__4$RUBY$meets", pars);
		 * System.out.println(m);
		 * 
		 * } catch (SecurityException | NoSuchMethodException e) {
		 * 
		 * e.printStackTrace(); }
		 */

		return cs;
	}

	// track MethodHandle Creation with Dynamic Method
	/*
	 * @SuppressAjWarnings("adviceDidNotMatch") after(DynamicMethod dm) :
	 * execution(MethodHandle *.createRubyHandle(*, DynamicMethod, *)) &&
	 * args(*,dm,*) && !within(tracking..*) && !within(wrapper..*){
	 * 
	 * System.out.println("METHODHANDLE WITH DYNAMICMETHOD = " +
	 * dm.getNativeCall().getNativeName() + " : " +
	 * Arrays.toString(dm.getNativeCall().getNativeSignature()));
	 * 
	 * }
	 */

	// track DynamicMethod Creation
	/*
	 * @SuppressAjWarnings("adviceDidNotMatch") after() returning(DynamicMethod
	 * dyna) : call(DynamicMethod *.*(..)) && !within(tracking..*) &&
	 * !within(wrapper..*){
	 * 
	 * if (dyna != null && dyna.getNativeCall() != null &&
	 * dyna.getNativeCall().getNativeName() != null &&
	 * dyna.getNativeCall().getNativeName().contains("meets")) {
	 * System.out.println("DYNAMICMETHOD CREATION = " +
	 * thisJoinPoint.getSignature()); }
	 * 
	 * }
	 */

	Set<DynamicMethod> dynamicMethods = new HashSet<DynamicMethod>();

	// track DynamicMethod Manipulation
	/*
	 * @SuppressAjWarnings("adviceDidNotMatch") after(String name, Class<?>[]
	 * type) : call(* DynamicMethod.setNativeCall(..)) && args(*, name, *, type,
	 * ..) && !within(tracking..*) && !within(wrapper..*){
	 * 
	 * if (name.contains("meets")) { System.out.println("SET DYNAMIC METHOD = "
	 * + Arrays.toString(thisJoinPoint.getArgs()) + " PARAMS: " +
	 * Arrays.toString(type)); dynamicMethods.add((DynamicMethod)
	 * thisJoinPoint.getTarget()); }
	 * 
	 * }
	 */

	// track DynamicMethod Use
	/*
	 * @SuppressAjWarnings("adviceDidNotMatch") after(DynamicMethod dynam) :
	 * execution(* *.*(..)) && args(dynam, ..) && !within(tracking..*) &&
	 * !within(wrapper..*){
	 * 
	 * if (dynam != null && dynamicMethods.contains(dynam)) {
	 * System.out.println("FOUND DYNAMICMETHOD USE = " +
	 * thisJoinPoint.getSignature()); } }
	 */

	// track MethodHandle Creation
	/*@SuppressAjWarnings("adviceDidNotMatch")
	after() : execution(MethodHandle *.*(..)) && !within(tracking..*) && !within(wrapper..*){

		System.out.println("METHODHANDLE = " + thisJoinPoint.getSignature() + " ARGS: " + Arrays.toString(thisJoinPoint.getArgs()));
	}*/
	
	Java8ReflectionHelper java8ReflectionHelper = new Java8ReflectionHelper();
	
	// track MethodHandle Internals
	@SuppressAjWarnings("adviceDidNotMatch")
	after() returning(MethodHandle mh): execution(MethodHandle *.*(..)) && !within(tracking..*) && !within(wrapper..*){

		System.out.println("MH INTERNAL NAME = " + java8ReflectionHelper.getInsideMemberNameInfo(mh).getName());
	}

	// track Method Creation
	/*
	 * @SuppressAjWarnings("adviceDidNotMatch") after() : call(Method *.*(..))
	 * && !within(tracking..*) && !within(wrapper..*){
	 * 
	 * System.out.println("METHOD = " + thisJoinPoint.getSignature() + " ARGS: "
	 * + Arrays.toString(thisJoinPoint.getArgs())); }
	 */

}
