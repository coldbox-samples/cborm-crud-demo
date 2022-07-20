/*******************************************************************************
 *	Integration Test as BDD
 *
 *	Extends the integration class: coldbox.system.testing.BaseTestCase
 *
 *	so you can test your ColdBox application headlessly. The 'appMapping' points by default to
 *	the '/root' mapping created in the test folder Application.cfc.  Please note that this
 *	Application.cfc must mimic the real one in your root, including ORM settings if needed.
 *
 *	The 'execute()' method is used to execute a ColdBox event, with the following arguments
 *	* event : the name of the event
 *	* private : if the event is private or not
 *	* prePostExempt : if the event needs to be exempt of pre post interceptors
 *	* eventArguments : The struct of args to pass to the event
 *	* renderResults : Render back the results of the event
 *******************************************************************************/
component extends="coldbox.system.testing.BaseTestCase" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();
		// do your own stuff here
	}

	function afterAll(){
		// do your own stuff here
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){
		describe( "persons suite", function(){
			// rollback transactions
			aroundEach( function( spec ){
				setup();
				transaction {
					try {
						arguments.spec.body();
					} catch ( any e ) {
						rethrow;
					} finally {
						transactionRollback();
					}
				}
			} );

			it( "can list all persons", function(){
				var event = this.GET( "persons/index" );
				var prc   = event.getPrivateCollection();
				expect( prc.persons ).toBeArray();
				expect( event.getRenderedContent() ).toInclude( "Create Person" );
			} );

			it( "can create a new person", function(){
				var event = this.POST(
					"persons.save",
					{
						name  : "integration test",
						email : "test@test.com",
						id    : "",
						age   : 20
					}
				);
				var prc = event.getPrivateCollection();
				expect( prc.person ).toBeComponent();
				expect( prc.person.getId() ).notToBeNull();
				expect( event.getValue( "relocate_event" ) ).toBe( "persons" );
			} );

			it( "can update a persisted person", function(){
				var target = getInstance( "Person" )
					.populate( {
						name  : "integration test",
						email : "test@test.com",
						age   : 20
					} )
					.save();

				var event = this.POST(
					"persons.save",
					{
						name  : "integration test mod",
						email : target.getEmail(),
						id    : target.getId(),
						age   : 22
					}
				);
				var prc = event.getPrivateCollection();
				expect( prc.person ).toBeComponent();
				expect( prc.person.getId() ).toBe( target.getId() );
				expect( prc.person.getName() ).toBe( "integration test mod" );
				expect( event.getValue( "relocate_event" ) ).toBe( "persons" );
			} );

			it( "can delete a person that exists", function(){
				var target = getInstance( "Person" )
					.populate( {
						name  : "integration test",
						email : "test@test.com",
						age   : 20
					} )
					.save();

				var event = this.POST( "persons.delete", { id : target.getId() } );
				var prc   = event.getPrivateCollection();
				expect( getFlashScope().get( "notice" ).message ).toInclude( "Person deleted!" );
			} );

			it( "will throw an exception when trying to delete an invalid person", function(){
				var event = this.POST( "persons.delete", { id : createUUID() } );
				var prc   = event.getPrivateCollection();
				expect( getFlashScope().get( "notice" ).message ).toInclude( "Invalid id sent!" );
			} );
		} );
	}

}
