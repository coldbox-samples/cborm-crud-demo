/**
 * I manage Persons using an ActiveEntity approach
 */
component {

	/**
	 * List all Persons
	 */
	function index( event, rc, prc ){
		prc.persons = getInstance( "Person" ).list();
		event.setView( "persons/index" );
	}

	/**
	 * Show a person card
	 */
	function show( event, rc, prc ){
		prc.person = getInstance( "Person" ).getOrFail( rc.id ?: 0 );
		event.setView( "persons/show" );
	}

	/**
	 * Editor for new or persisted persons
	 */
	function editor( event, rc, prc ){
		prc.person = getInstance( "Person" ).get( rc.id ?: 0 );
		event.setView( "persons/editor" );
	}

	/**
	 * Save a new or persisted person
	 */
	function save( event, rc, prc ){
		prc.person = getInstance( "Person" )
			.get( rc.id ?: 0 )
			.populate( memento: rc, exclude: "id" )
			.save();
		flash.put( "notice", { type : "info", message : "Person saved!" } );
		relocate( "persons" );
	}

	/**
	 * Delete a Person
	 */
	function delete( event, rc, prc ){
		try {
			getInstance( "Person" ).getOrFail( rc.id ?: 0 ).delete();
			flash.put( "notice", { type : "info", message : "Person deleted!" } );
		} catch ( "EntityNotFound" e ) {
			flash.put( "notice", { type : "warning", message : "Invalid id sent!" } );
		} catch ( any e ) {
			flash.put(
				"notice",
				{
					type    : "danger",
					message : "Error deleting person: #e.message & e.detail#"
				}
			);
		}

		relocate( "persons" );
	}

}
