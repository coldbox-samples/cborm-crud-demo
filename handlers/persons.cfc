/**
 * I manage Persons
 */
component{

	/**
	 * List all Persons
	 */
	function index( event, rc, prc ){
		return getInstance( "Person" )
			.list( asQuery=false )
			.map( function( item ){
				return item.getMemento( includes="id" );
			} );
	}

	/**
	 * create a person
	 */
	function create( event, rc, prc ){
		prc.person = getInstance( "Person" )
			.new( {
				name 	: "Luis",
				age 	: 40,
				lastVisit : now()
			} )
			.save();
		return prc.person.getMemento( includes="id" );
	}

	/**
	 * show a person
	 */
	function show( event, rc, prc ){
		return getInstance( "Person" )
			.get( rc.id ?: 0 )
			.getMemento( includes="id" );
	}

	/**
	 * Update a person
	 */
	function update( event, rc, prc ){
		prc.person = getInstance( "Person" )
			.getOrFail( rc.id ?: '' )
			.setName( "Bob" )
			.save();
		return prc.person.getMemento( includes="id" );
	}

	/**
	 * Delete a Person
	 */
	function delete( event, rc, prc ){
		try{
			getInstance( "Person" )
				.getOrFail( rc.id ?: '' )
				.delete();
			// Or use the shorthnd notation which is faster
			// getIntance( "Person" ).deleteById( rc.id ?: '' )
		} catch( any e ){
			return "Error deleting entity: #e.message# #e.detail#";
		}

		return "Entity Deleted!";
	}

}