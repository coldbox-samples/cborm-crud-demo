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
		describe( "persons api suite", function(){
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
				var event = this.GET( "api/persons/index" );
				// expectations go here.
				expect( event.getRenderedContent() ).toBeJSON();
			} );

			it( "create", function(){
				var event  = this.POST( "api/persons/create" );
				// expectations go here.
				var person = event.getPrivateValue( "Person" );
				expect( person ).toBeComponent();
				expect( person.getId() ).notToBeNull();
			} );

			it( "show", function(){
				// Create mock
				var event  = this.POST( "api/persons/create" );
				// Retrieve it
				var event  = this.GET( "api/persons/show", { id : event.getPrivateValue( "Person" ).getId() } );
				// expectations go here.
				var person = event.getPrivateValue( "Person" );
				expect( person ).toBeComponent();
				expect( person.getId() ).notToBeNull();
			} );

			it( "update", function(){
				// Create mock
				var event  = this.POST( "api/persons/create" );
				var event  = this.POST( "api/persons/update", { id : event.getPrivateValue( "Person" ).getId() } );
				// expectations go here.
				var person = event.getPrivateValue( "Person" );
				expect( person ).toBeComponent();
				expect( person.getId() ).notToBeNull();
				expect( person.getName() ).toBe( "Bob" );
			} );

			it( "delete", function(){
				// Create mock
				var event = this.POST( "api/persons/create" );
				// Create mock
				var event = this.DELETE( "api/persons/delete", { id : event.getPrivateValue( "Person" ).getId() } );
				expect( event.getRenderedContent() ).toInclude( "Entity Deleted" );
			} );
		} );
	}

}
