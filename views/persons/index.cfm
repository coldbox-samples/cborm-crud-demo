<cfoutput>
<div>

	<div class="float-end">
		<a
			class="btn btn-info"
			href="#event.buildLink( 'persons.editor' )#"
		>
			Create Person
		</a>
	</div>

	<h2>Persons (#prc.persons.len()#)</h2>

	<cfif flash.exists( "notice" )>
		<cfset notice = flash.get( "notice" )>
		<div
			class="alert alert-#notice.type# alert-dismissible fade show"
			role = "alert"
			>
			#notice.message#

			<button
				type="button"
				class="btn-close"
				data-bs-dismiss="alert"
				aria-label="Close"></button>
		</div>
	</cfif>

	<table
		class="mt-3 table table-hover table-responsive"
	>
		<thead>
			<th>Name</th>
			<th>Email</th>
			<th>Age</th>
			<th width="150">Actions</th>
		</thead>
		<tbody>
			<cfloop array="#prc.persons#" index="person">
				<tr>
					<td>
						<a href="#event.buildLink( 'persons.show.id', person.getId() )#">
							#person.getName()#
						</a>
					</td>
					<td>#person.getEmail()#</td>
					<td>#person.getAge()#</td>
					<td>
						#html.startForm(
							action : "persons.delete",
							onSubmit : "return confirm( 'Are you sure?' )"
						)#
							#html.hiddenField( name : "id", bind : person )#
							<a
								href="#event.buildLink( 'persons.editor.id', person.getId() )#"
								class="btn btn-sm btn-info"
							>
								Edit
							</a>

							<button
								class="btn btn-sm btn-danger"
								type="submit"
							>
								Delete
							</button>
						#html.endForm()#
					</td>
				</tr>
			</cfloop>
		</tbody>
	</table>
</div>
</cfoutput>
