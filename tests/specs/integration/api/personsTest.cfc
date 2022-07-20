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
				var event = GET( "api/persons/index" );
				// expectations go here.
				expect( event.getResponse() ).toHaveStatus( 200 );
				expect( event.getResponse().getData() ).toBeArray();
			} );

			it( "create a new person", function(){
				var event = POST(
					"api/persons/create",
					{ name : "api test", email : "apitest@test.com", age : 40 }
				);
				var response = event.getResponse();
				// expectations go here.
				expect( response.getStatusCode() ).toBe( 200, response.getMessagesString() );
				expect( response.getData() ).toBeStruct();
				expect( response.getData().name ).toBe( "api test" );
			} );

			it( "can show a persisted person", function(){
				var target = getInstance( "Person" )
					.new( {
						name  : "integration test",
						email : "test@test.com",
						age   : 20
					} )
					.save();
				var event    = get( "api/persons/show/id/#target.getId()#" );
				var response = event.getResponse();
				// expectations go here.
				expect( response.getStatusCode() ).toBe( 200, response.getMessagesString() );
				expect( response.getData() ).toBeStruct();
				expect( response.getData().name ).toBe( "integration test" );
			} );

			it( "can show an exception when viewing a person that doesn't exist", function(){
				var event    = get( "api/persons/show/id/#createUUID()#" );
				var response = event.getResponse();
				// expectations go here.
				expect( response.getStatusCode() ).toBe( 404, response.getMessagesString() );
			} );

			it( "show an exception when updating an invalid person", function(){
				var event    = get( "api/persons/show/update", { id : createUUID(), name : "hello there" } );
				var response = event.getResponse();
				// expectations go here.
				expect( response.getStatusCode() ).toBe( 404, response.getMessagesString() );
			} );

			it( "update a persisted person", function(){
				var target = getInstance( "Person" )
					.new( {
						name  : "integration test",
						email : "test@test.com",
						age   : 20
					} )
					.save();
				var event    = POST( "api/persons/update", { id : target.getId(), name : "integration test mod" } );
				var response = event.getResponse();
				// expectations go here.
				expect( response.getStatusCode() ).toBe( 200, response.getMessagesString() );
				expect( response.getData() ).toBeStruct();
				expect( response.getData().name ).toBe( "integration test mod" );
			} );

			it( "can delete a valid person", function(){
				var target = getInstance( "Person" )
					.new( {
						name  : "integration test",
						email : "test@test.com",
						age   : 20
					} )
					.save();
				var event    = DELETE( "api/persons/delete", { id : target.getId() } );
				var response = event.getResponse();
				expect( response.getStatusCode() ).toBe( 200, response.getMessagesString() );
				expect( event.getRenderedContent() ).toInclude( "Person Deleted" );
			} );

			it( "can show an exception when trying to delete an invalid person", function(){
				var event    = DELETE( "api/persons/delete", { id : createUUID() } );
				var response = event.getResponse();
				expect( response.getStatusCode() ).toBe( 404, response.getMessagesString() );
			} );
		} );
	}

}
