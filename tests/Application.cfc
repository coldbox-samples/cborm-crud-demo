/**
********************************************************************************
Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************
*/
component{

	// APPLICATION CFC PROPERTIES
	this.name 				= "ColdBoxTestingSuite";
	this.sessionManagement 	= true;
	this.setClientCookies 	= true;
	this.sessionTimeout 	= createTimeSpan( 0, 0, 15, 0 );
	this.applicationTimeout = createTimeSpan( 0, 0, 15, 0 );
    // Turn on/off white space management
	this.whiteSpaceManagement = "smart";
    this.enableNullSupport = shouldEnableFullNullSupport();

	// Create testing mapping
	this.mappings[ "/tests" ] = getDirectoryFromPath( getCurrentTemplatePath() );
	// Map back to its root
	rootPath = REReplaceNoCase( this.mappings[ "/tests" ], "tests(\\|/)", "" );
	this.mappings["/root"]   = rootPath;

	// Locate the cborm module for events
	this.mappings[ "/cborm" ] = rootPath & "modules/cborm";

	// ORM Settings + Datasource
	this.datasource = "cbormcrud"; // The default dsn name in the ColdBox scaffold
	this.ormEnabled = "true";
	this.ormSettings = {
		cfclocation = [ "models" ], // Where our entities exist
		logSQL = false, // Remove after development to false.
		dbcreate = "update", // Generate our DB
		automanageSession = false, // Let cborm manage it
		flushAtRequestEnd = false, // Never do this! Let cborm manage it
		eventhandling = true, // Enable events
		eventHandler = "cborm.models.EventHandler", // Who handles the events
		skipcfcWithError = true // Yes, because we must work in all CFML engines
	};

	public boolean function onRequestStart( targetPage ){
		// Set a high timeout for long running tests
		setting requestTimeout="9999";
		// New ColdBox Virtual Application Starter
		request.coldBoxVirtualApp = new coldbox.system.testing.VirtualApp( appMapping = "/" );

		// ORM Reload for fresh results
		if( structKeyExists( url, "fwreinit" ) ){
			if( structKeyExists( server, "lucee" ) ){
				pagePoolClear();
			}
			ormReload();
			request.coldBoxVirtualApp.shutdown();
		}

		// If hitting the runner or specs, prep our virtual app
		if ( getBaseTemplatePath().replace( expandPath( "/tests" ), "" ).reFindNoCase( "(runner|specs)" ) ) {
			request.coldBoxVirtualApp.startup();
		}

		return true;
	}

	public void function onRequestEnd( required targetPage ) {
		request.coldBoxVirtualApp.shutdown();
	}

    private boolean function shouldEnableFullNullSupport() {
        var system = createObject( "java", "java.lang.System" );
        var value = system.getEnv( "FULL_NULL" );
        return isNull( value ) ? false : !!value;
    }
}
