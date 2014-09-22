/**
 * Copyright 2005-2014 Restlet
 * 
 * The contents of this file are subject to the terms of one of the following
 * open source licenses: Apache 2.0 or LGPL 3.0 or LGPL 2.1 or CDDL 1.0 or EPL
 * 1.0 (the "Licenses"). You can select the license that you prefer but you may
 * not use this file except in compliance with one of these Licenses.
 * 
 * You can obtain a copy of the Apache 2.0 license at
 * http://www.opensource.org/licenses/apache-2.0
 * 
 * You can obtain a copy of the LGPL 3.0 license at
 * http://www.opensource.org/licenses/lgpl-3.0
 * 
 * You can obtain a copy of the LGPL 2.1 license at
 * http://www.opensource.org/licenses/lgpl-2.1
 * 
 * You can obtain a copy of the CDDL 1.0 license at
 * http://www.opensource.org/licenses/cddl1
 * 
 * You can obtain a copy of the EPL 1.0 license at
 * http://www.opensource.org/licenses/eclipse-1.0
 * 
 * See the Licenses for the specific language governing permissions and
 * limitations under the Licenses.
 * 
 * Alternatively, you can obtain a royalty free commercial license with less
 * limitations, transferable or non-transferable, directly at
 * http://www.restlet.com/products/restlet-framework
 * 
 * Restlet is a registered trademark of Restlet
 */
package ${packageName};

import java.util.ArrayList;
import java.util.List;
import org.restlet.data.MediaType;
import org.restlet.data.Preference;
import org.restlet.data.Reference;
import org.restlet.ext.odata.Query;
import org.restlet.representation.Representation;
import org.restlet.resource.ClientResource;
import org.restlet.resource.ResourceException;
import org.restlet.data.ChallengeScheme;
import org.restlet.data.ChallengeResponse;
import org.restlet.data.Parameter;
import org.restlet.util.Series;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import org.restlet.ext.odata.batch.request.BatchRequest;
import org.restlet.ext.odata.batch.request.impl.BatchRequestImpl;

<#list entityContainer.entities?sort as entitySet>
import ${entityClassPkg}.${entitySet.type.className};
</#list>

<#list schema.complexTypes? sort as ct>
import ${entityClassPkg}.${ct.className};
</#list>

<#compress>
/**
 * Generated by the generator tool for the OData extension for the Restlet framework.<br>
 * 
<#if metadata.metadataRef??> * @see <a href="${metadata.metadataRef}">Metadata of the target OData service</a></#if>
 * 
 */
</#compress>

public class ${className} extends org.restlet.ext.odata.Service {

   /**
    * Constructor.
    * 
    */
    public ${className}() {
        super("${dataServiceUri}");
        <#if challengeScheme??>
        super.setCredentials(new ChallengeResponse(${challengeScheme}, "${userName}", "${password}"));
        </#if>
    }
    
    <#if challengeScheme??>
    public ${className}(String serviceUrl, String userName, String password) {
        super(serviceUrl);
        super.setCredentials(new ChallengeResponse(${challengeScheme}, userName, password));
    }
    </#if>
    
    public ${className}(String serviceUrl, String userName, String password, ChallengeScheme cs) {
        super(serviceUrl);
        super.setCredentials(new ChallengeResponse(cs, userName, password));
    }
 
<#list entityContainer.entities as entitySet>
    <#assign type=entitySet.type>
    /**
     * Adds a new entity to the service.
     * 
     * @param entity
     *            The entity to add to the service.
     * @return entity Type Object
     * 			The newly created entity.
     *	
     * @throws Exception 
     */
    public ${type.className} addEntity(${type.className} entity) throws Exception {
        return <#if entityContainer.defaultEntityContainer>addEntity("/${entitySet.name}", entity);<#else>addEntity("/${entityContainer.name}.${entitySet.name}", entity);</#if>
    }

    /**
     * Creates a query for ${type.normalizedName} entities hosted by this service.
     * 
     * @param subpath
     *            The path to this entity relatively to the service URI.
     * @return A query object.
     */
    public Query<${type.className}> create${type.className}Query(String subpath) {
        return createQuery(subpath, ${type.className}.class);
    }

    <#if (type.blob && type.blobValueRefProperty?? && type.blobValueRefProperty.name??)>
    /**
     * Returns the binary representation of the given media resource.
     * 
     * @param entity
     *            The given media resource.
     * @return The binary representation of the given media resource.
     */
    public Representation getValue(${type.className} entity) throws ResourceException {
        Reference ref = getValueRef(entity);
        if (ref != null) {
            ClientResource cr = createResource(ref);
            return cr.get();
        }

        return null;
    }

    /**
     * Returns the binary representation of the given media resource.
     * 
     * @param entity
     *            The given media resource.
     * @param acceptedMediaTypes
     *            The requested media types of the representation.
     * @return The given media resource.
     */
    public Representation getValue(${type.className} entity,
            List<Preference<MediaType>> acceptedMediaTypes)
            throws ResourceException {
        Reference ref = getValueRef(entity);
        if (ref != null) {
            ClientResource cr = createResource(ref);
            cr.getClientInfo().setAcceptedMediaTypes(acceptedMediaTypes);
            return cr.get();
        }

        return null;
    }

    /**
     * Returns the binary representation of the given media resource.
     * 
     * @param entity
     *            The given media resource.
     * @param mediaType
     *            The requested media type of the representation
     * @return The given media resource.
     */
    public Representation getValue(${type.className} entity, MediaType mediaType)
            throws ResourceException {
        Reference ref = getValueRef(entity);
        if (ref != null) {
            ClientResource cr = createResource(ref);
            return cr.get(mediaType);
        }

        return null;
    }

    /**
     * Returns the reference of the binary representation of the given entity.
     * 
     * @param entity
     *            The media resource.
     * @return The reference of the binary representation of the given entity.
     */
    public Reference getValueRef(${type.className} entity) {
        if (entity != null) {
            return entity.get${type.blobValueRefProperty.name?cap_first}();
        }

        return null;
    }

    /**
     * Sets the value of the given media entry link.
     * 
     * @param entity
     *            The media entry link which value is to be updated
     * @param blob
     *            The new representation.
     * @throws ResourceException
     */
    public void setValue(${type.className} entity, Representation blob)
            throws ResourceException {
        Reference ref = entity.get${type.blobValueEditRefProperty.name?cap_first}();

        if (ref != null) {
            ClientResource cr = createResource(ref);
            cr.put(blob);
        }
    }
    </#if>
</#list>

	/**
     * Returns the instance of BatchRequestImpl for batch requests.
     * 
     * @return The reference of the binary representation of the given entity.
     */
   	public BatchRequest createBatchRequest(){
		return new BatchRequestImpl(this);
	}
	
<#list entityContainer.functionImports as functionImport>

	<#if functionImport.javaReturnType!="void" && !functionImport.simple>
    @SuppressWarnings("unchecked")
	</#if>
	public ${functionImport.javaReturnType} ${functionImport.name}(
	    <#assign i= functionImport.parameters?size>
	    <#list functionImport.parameters as parameter>
	        <#if i==1>
	    	${parameter.javaType} ${parameter.name}
	    	<#else>
		   	${parameter.javaType} ${parameter.name},
		    </#if>
		    <#assign i = i-1>
        </#list>) {
        <#if functionImport.javaReturnType!="void">
        <#if functionImport.collection>
		${functionImport.javaReturnType} ${functionImport.name} = new ArrayList<${functionImport.elementType}>();
		<#elseif functionImport.complex>
		${functionImport.javaReturnType} ${functionImport.name} = new ${functionImport.javaReturnType}();
		<#else>
		${functionImport.javaReturnType} ${functionImport.name} = null;
		</#if>
		</#if>
    	Series<Parameter> parameters = new Series<Parameter>(Parameter.class);
    	<#list functionImport.parameters as parameter>
	    Parameter param${parameter.name} = new Parameter();
    	param${parameter.name}.setName("${parameter.name}");
    	<#if parameter.type?starts_with("List") || parameter.type?starts_with("Collection")>
    	Gson gson = new GsonBuilder().serializeNulls().serializeSpecialFloatingPointValues().create();
    	String jsonValue=gson.toJson(${parameter.name});    	
    	param${parameter.name}.setValue(jsonValue);
    	<#else>
    	param${parameter.name}.setValue(${parameter.name}!=null?${parameter.name}.toString():null);
    	</#if>
		parameters.add(param${parameter.name});
        </#list>
        <#if functionImport.javaReturnType!="void">
    	${functionImport.name} = (${functionImport.javaReturnType})invokeFunction("${functionImport.name}", parameters, ${functionImport.elementType}.class, ${functionImport.name});
    	<#else>
    	invokeComplex("${functionImport.name}", parameters);
    	</#if>
    	<#if functionImport.javaReturnType!="void">
    	return ${functionImport.name};
        </#if>
    }
</#list>
}