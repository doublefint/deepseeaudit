/// Example of using audit subsystem in app code
Class habra.audit Extends %CSP.Page {

/// Register your own event types 
ClassMethod EventTypesRegister() As %Status {
	#; Event types register in %SYS namespace
	new $namespace s $namespace = "%SYS"
	
	#; set status = ##class(Security.Events).Create( Source, Type, Name, Description )
	s source = "habra", type="audit"
	s scC = ##class(Security.Events).Create( source, type, "create", "Create event example" ) 
	s scR = ##class(Security.Events).Create( source, type, "read",	 "Read event example" )
	s scU = ##class(Security.Events).Create( source, type, "update", "Update event example" )
	s scD = ##class(Security.Events).Create( source, type, "delete", "Delete event example" )
	
	Q scC && scR && scU && scD
}

/// Simple html form with few buttons
ClassMethod OnPage() As %Status {

 &html<<!DOCTYPE html><html><head><title>Audit Example</title>
 <style> form { display: flex; justify-content: space-around; align-items: center; } </style>
 </head><body>

<h3>Hello, #($username)#!</h3><hr>
<form method='post'>
	<button name='create'>Create</button>
	<button name='read'  >Read  </button>
	<button name='update'>Update</button>
	<button name='delete'>Delete</button>
</form>
</body></html>>
 Quit 1
}

/// Parse html form submit
ClassMethod OnPreHTTP() As %Boolean [ ServerOnly = 1 ] {
	#; form send to server only button name, like below:
	#; http://[server]/[app]/[class]?name=
	s name = $order( %request.Data("") )	;which button?
	#; save button name into Audit subsystem ( Source, Type, Name, EventData, Description )
	s status = ##class(%SYSTEM.Security).Audit( "habra", "audit", name, "button", "1984" )
	Q 1
}

}
