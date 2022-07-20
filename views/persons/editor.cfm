<cfoutput>
<div>
	<h2 class="mb-3">
		Person Editor
		<cfif prc.person.isLoaded()>
			- #prc.person.getName()#
		</cfif>
	</h2>

	#html.startForm(
		action : "persons.save"
	)#

		#html.hiddenField( name: "id", bind : prc.person )#

		<cfif prc.person.isLoaded()>
			<div class="mb-3">
				<label for="id" class="form-label">Id: </label>
				<span class="badge bg-info">#prc.person.getId()#</span>
			</div>
		</cfif>

		<div class="mb-3">
			<label for="name" class="form-label">Name</label>
			#html.inputField(
				name : "name",
				class : "form-control",
				placeholder : "Jon James",
				required : true,
				bind : prc.person
			)#
		</div>

		<div class="mb-3">
			<label for="email" class="form-label">Email Address</label>
			#html.emailField(
				name : "email",
				class : "form-control",
				placeholder : "jjames@ortussolutions.com",
				required : true,
				bind : prc.person
			)#
		</div>

		<div class="mb-3">
			<label for="age" class="form-label">Age</label>
			#html.inputField(
				type : "number",
				name : "age",
				min : 0,
				max : 120,
				class : "form-control",
				placeholder : "44",
				required : true,
				bind : prc.person
			)#
		</div>

		<div class="float-end mt-3">
			<a
				href="#event.buildlink( 'persons' )#"
				class="btn btn-light">
				Cancel
			</a>
			<button
				type="submit"
				class="btn btn-primary"
			>
				Save
			</button>
		</div>

	#html.endForm()#
</div>
</cfoutput>
