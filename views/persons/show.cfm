<cfoutput>
	<div>

		<div class="card">
			<div class="card-header">
				<h1>#prc.person.getName()# - #prc.person.getAge()#</h1>
			</div>
			<div class="card-body">

				<h5 class="card-title">#prc.person.getEmail()#</h5>

				<div class="mt-5">
					<a
						class="btn btn-light"
						href="#event.buildLink( 'persons' )#"
					>
						Back
					</a>

					<a
						class="btn btn-primary"
						href="#event.buildLink( 'persons.editor.id', prc.person.getId() )#"
					>
						Edit
					</a>
				</div>
			</div>
		</div>

	</div>
	</cfoutput>
