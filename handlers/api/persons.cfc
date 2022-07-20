/**
 * This is a persons API using active entity
 */
component extends="coldbox.system.RestHandler" {

	/**
	 * List all Persons
	 */
	function index( event, rc, prc ){
		event
			.getResponse()
			.setData(
				getInstance( "Person" )
					.list()
					.map( function( item ){
						return item.getMemento();
					} )
			);
	}

	/**
	 * Create a person
	 */
	function create( event, rc, prc ){
		prc.person = getInstance( "Person" ).new( rc ).save();
		event.getResponse().setData( prc.person.getMemento() );
	}

	/**
	 * Show a single persisted person
	 */
	function show( event, rc, prc ){
		prc.person = getInstance( "Person" ).getOrFail( rc.id ?: 0 );
		event.getResponse().setData( prc.person.getMemento() );
	}

	/**
	 * Update a person
	 */
	function update( event, rc, prc ){
		prc.person = getInstance( "Person" )
			.getOrFail( rc.id ?: "" )
			.populate( memento: rc, excludes: "id" )
			.save();
		event.getResponse().setData( prc.person.getMemento() );
	}

	/**
	 * Delete a Person
	 */
	function delete( event, rc, prc ){
		getInstance( "Person" ).getOrFail( rc.id ?: "" ).delete();
		event.getResponse().addMessage( "Person deleted!" );
	}

}
