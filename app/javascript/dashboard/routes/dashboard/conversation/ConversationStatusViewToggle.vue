<template>
	<section class="w-screen flex">
		<section class="min-w-[230px] h-full py-2 bordas">
		  <div class="h-full rounded-xl w-full py-4 px-2">
		    <label>
		      Visualização:
		    </label>
		    <woot-button
		      type="button"
		      :disabled="showing === 'kanban'"
		      class="button-visualization"
		      @click="() => toggleView('kanban')"
		    >
		      <span class="flex items-center gap-0.5">
		        <fluent-icon icon="arrow-trending-lines" size="16" />
		        Kanban
		      </span>
		    </woot-button>
		    <woot-button
		      type="button"
		      @click="() => toggleView('conversations')"
		      class="button-visualization"
		      :disabled="showing === 'conversations'"
		    > 
		      <span class="flex items-center gap-0.5">
		        <fluent-icon icon="chat" size="16" />
		        Conversas
		      </span>
		    </woot-button>

		    <section class="flex flex-col gap-8 mt-12">
		    	<div>
			    	<h2>Times:</h2>
			    	<span class="flex items-center gap-2">
			    		<input type="checkbox" id="time1">
			    		<label for="time1">Time 1</label>
			    	</span>
			    	<span class="flex items-center gap-2">
			    		<input type="checkbox" id="time2">
			    		<label for="time2">Time 2</label>
			    	</span>
			    	<span class="flex items-center gap-2">
			    		<input type="checkbox" id="time3">
			    		<label for="time3">Time 3</label>
			    	</span>
			    </div>

			    <div>
			    	<h2>Caixa de entrada:</h2>
			    </div>

			    <div>
			    	<h2>Marcadores:</h2>
			    	<span class="flex items-center gap-2">
			    		<input type="checkbox" id="tag1">
			    		<label for="tag1">Tags 1</label>
			    	</span>
			    	<span class="flex items-center gap-2">
			    		<input type="checkbox" id="tag2">
			    		<label for="tag2">Tags 2</label>
			    	</span>
			    	<span class="flex items-center gap-2">
			    		<input type="checkbox" id="tag3">
			    		<label for="tag3">Tags 3</label>
			    	</span>
			    	<span class="flex items-center gap-2">
			    		<input type="checkbox" id="tag4">
			    		<label for="tag4">Tags 4</label>
			    	</span>
			    	<span class="flex items-center gap-2">
			    		<input type="checkbox" id="tag5">
			    		<label for="tag5">Tags 5</label>
			    	</span>
			    </div>
		    </section>
		  </div>
		</section>
		<conversation-status-view v-if="showing === 'kanban'"/>
		<conversation-view v-else/>
	</section>
</template>

<script>
import ConversationStatusView from './ConversationStatusView'
import ConversationView from './ConversationView'
import uiSettingsMixin from 'dashboard/mixins/uiSettings';


	export default {
		components: {
			'conversation-status-view': ConversationStatusView,
			'conversation-view': ConversationView,
		},
		data: function() {
			return {
				showing: 'kanban'
			}
		},
		methods: {
			toggleView: function(value) {
				this.showing = value
			}
		},
		mixins:[uiSettingsMixin],
	  	beforeDestroy: function() {
		    this.updateUISettings({
		      	show_secondary_sidebar: true,
					previously_used_sidebar_view: true,
				});
			},
		}
</script>


<style>
.bordas {
	border-right: 1px solid rgba(0,0,0,0.030);
}
</style>