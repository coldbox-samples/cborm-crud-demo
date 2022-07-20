/**
 * A cool Person entity
 */
component
	persistent="true"
	table     ="persons"
	extends   ="cborm.models.ActiveEntity"
{

	// Primary Key
	property
		name     ="id"
		fieldtype="id"
		column   ="id"
		generator="uuid"
		setter   ="false";

	// Properties
	property name="name"      ormtype="string";
	property name="email"     ormtype="string";
	property name="age"       ormtype="integer";
	property name="lastVisit" ormtype="timestamp";

	this.constraints = {
		name  : { required : true },
		email : { required : true },
		age   : { required : true, type : "integer" }
	};

	function init(){
		super.init();
		return this;
	}

	function isLoaded(){
		return !isNull( variables.id ) && len( variables.id );
	}

}
