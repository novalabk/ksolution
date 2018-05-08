package com.boot.ksolution.core.db.type;

import java.io.IOException;
import java.io.Serializable;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Properties;
import java.util.Set;
import java.util.stream.Collectors;

import org.hibernate.HibernateException;
import org.hibernate.boot.registry.classloading.internal.ClassLoaderServiceImpl;
import org.hibernate.boot.registry.classloading.spi.ClassLoaderService;
import org.hibernate.engine.spi.SessionImplementor;
import org.hibernate.type.SerializationException;
import org.hibernate.usertype.ParameterizedType;
import org.hibernate.usertype.UserType;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;


public class MySQLJSONUserType implements ParameterizedType, UserType{
	
	private static final ObjectMapper objectMapper = new ObjectMapper();
    private static final ClassLoaderService classLoaderService = new ClassLoaderServiceImpl();

    public static final String JSON_TYPE = "json";
    public static final String CLASS = "CLASS";
    
    private Class JsonClassType;
    
   
	//UserType
	@Override
	public Object assemble(Serializable cached, Object owner) throws HibernateException {
		return deepCopy(cached);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Object deepCopy(Object value) throws HibernateException {
		if (!(value instanceof Collection)) {
            return value;
        }
		Collection<?> collection = (Collection)value;
		Collection collectionClone = CollectionFactory.newInstance(collection.getClass());
		collectionClone.addAll(collection.stream().map(this::deepCopy).collect(Collectors.toList()));
		return collectionClone;
	}
	
	static final class CollectionFactory{
		@SuppressWarnings("unchecked") //<E,T>선언
		static <E, T extends Collection<E>> T newInstance (Class<? extends Collection> collectionClass) {
			if (List.class.isAssignableFrom(collectionClass)) {  //상위 클래스 여부
                return (T) new ArrayList<E>();
            } else if (Set.class.isAssignableFrom(collectionClass)) {
                return (T) new HashSet<E>();
            } else {
                throw new IllegalArgumentException("Unsupported collection type : " + collectionClass);
            }
		}
	}

	@Override
	public Serializable disassemble(Object value) throws HibernateException {
		Object deepCopy = deepCopy(value);

        if (!(deepCopy instanceof Serializable)) {
            throw new SerializationException(String.format("%s is not serializable class", value), null);
        }

        return (Serializable) deepCopy;
	}

	@Override
	public boolean equals(Object x, Object y) throws HibernateException {
		if (x == y) {
            return true;
        }

        if ((x == null) || (y == null)) {
            return false;
        }

        return x.equals(y);
	}

	@Override
	public int hashCode(Object x) throws HibernateException {
		assert (x != null);
        return x.hashCode();
	}

	@Override
	public boolean isMutable() {
		return true;
	}

	@Override
	public Object nullSafeGet(ResultSet resultSet, String[] names, SessionImplementor sharedSessionContractImplementor, Object o)
			throws HibernateException, SQLException {
		try {
			if(resultSet.getBytes(names[0]) != null) {
				final String json = new String(resultSet.getBytes(names[0]), "UTF-8");
				return objectMapper.readValue(json, JsonClassType);
			}
			return null;
		}catch(IOException e) {
			throw new HibernateException(e);
		}
	}

	@Override
	public void nullSafeSet(PreparedStatement st, Object value, int index, SessionImplementor sharedSessionContractImplementor)
			throws HibernateException, SQLException {
		try {
			final String json = value == null ? null : objectMapper.writeValueAsString(value);
			st.setObject(index,  json);
		} catch(JsonProcessingException e) {
			throw new HibernateException(e);
		}
		
	}

	@Override
	public Object replace(Object original, Object target, Object owner) throws HibernateException {
		return deepCopy(original);
	}

	@Override
	public Class returnedClass() {
		return Object.class;
	}

	@Override
	public int[] sqlTypes() {
		return new int[]{Types.JAVA_OBJECT};
	}
	//UserType

	
	//ParameterizedType
	@Override
	public void setParameterValues(Properties parameters) {
		final String clazz = (String)parameters.get(CLASS);
		JsonClassType = classLoaderService.classForName(clazz);
	}
	
	public static void main(String[] args) {
		
        List<String> alpha = Arrays.asList("a", "b", "c", "d");

        //Before Java8
        List<String> alphaUpper = new ArrayList<>();
        for (String s : alpha) {
            alphaUpper.add(s.toUpperCase());
        }

        System.out.println(alpha); //[a, b, c, d]
        System.out.println(alphaUpper); //[A, B, C, D]

        // Java 8
        List<String> collect = alpha.stream().map(String::toUpperCase).collect(Collectors.toList());
        System.out.println(collect); //[A, B, C, D]

        // Extra, streams apply to any data type.
        List<Integer> num = Arrays.asList(1,2,3,4,5);
        
        System.out.println(num.stream().map(n -> n * 2).count());
        List<Integer> collect1 = num.stream().map(n -> n * 2).collect(Collectors.toList());
        System.out.println(collect1); //[2, 4, 6, 8, 10]

        /*List<Staff> staff = Arrays.asList(
                new Staff("mkyong", 30, new BigDecimal(10000)),
                new Staff("jack", 27, new BigDecimal(20000)),
                new Staff("lawrence", 33, new BigDecimal(30000))
        );

        //Before Java 8
        List<String> result = new ArrayList<>();
        for (Staff x : staff) {
            result.add(x.getName());
        }
        System.out.println(result); //[mkyong, jack, lawrence]

        //Java 8
        List<String> collect = staff.stream().map(x -> x.getName()).collect(Collectors.toList());
        System.out.println(collect); //[mkyong, jack, lawrence]
*/
        
    }
}
