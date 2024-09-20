<!-- eslint-disable prettier/prettier -->
<template>
  <section class="w-screen flex">
    <section class="min-w-[250px] h-full py-2 bordas">
      <div class="h-full rounded-xl w-full py-4 px-2">
        <label> Visualização: </label>

        <section class="flex flex-col gap-8 mt-12">
          <div v-if="teamsList.length">
            <h2 class="mb-3">Times:</h2>
            <span class="flex items-center gap-2">
              <div class="flex items-center">
                <input
                  id="todos-os-times"
                  v-model="selectedTeamId"
                  value="0"
                  type="radio"
                  class="h-4 w-4 cursor-pointer mr-1"
                />
                <label
                  for="todos-os-times"
                  class="ms-2 text-sm font-medium text-gray-900 dark:text-gray-300 cursor-pointer"
                  >Todos os Times</label
                >
              </div>
            </span>
            <span
              v-for="item in teamsList"
              :key="item.id"
              class="flex items-center gap-2"
            >
              <div class="flex items-center">
                <input
                  :id="item.id"
                  v-model="selectedTeamId"
                  type="radio"
                  :value="item.id"
                  class="h-4 w-4 cursor-pointer mr-1"
                />
                <label
                  :for="item.id"
                  class="ms-2 text-sm font-medium text-gray-900 dark:text-gray-300 cursor-pointer"
                >
                  {{
                    item.name.replace(/(^\w{1})|(\s+\w{1})/g, letter =>
                      letter.toUpperCase()
                    )
                  }}
                </label>
              </div>
            </span>
          </div>

          <div>
            <h2>Caixa de entrada:</h2>
          </div>

          <div class="sidebar-labels-wrap">
            <div v-if="labelsList.length">
              <h2 class="mb-2">Marcadores:</h2>

              <ul class="pt-2 mb-0 ml-0 list-none">
                <li class="mt1">
                  <ul class="mb-0 ml-0 list-none">
                    <li
                      :class="{ 'label-select': activeLabelTitle === 'todos' }"
                    >
                      <a
                        class="inline-flex text-left max-w-full w-full items-center cursor-pointer"
                        @click.prevent="labelSelect('todos')"
                        ><!---->
                        <span
                          class="inline-flex rounded-sm bg-slate-100 h-3 w-3.5 mr-1.5 rtl:mr-0 rtl:ml-1.5 border border-black dark:border-slate-900"
                          style="background-color: white"
                        />
                        <div
                          class="items-center flex overflow-hidden whitespace-nowrap text-ellipsis w-full justify-between"
                        >
                          <span
                            title="todos_os_marcadores"
                            class="text-xs text-slate-700 dark:text-slate-100 text-ellipsis overflow-hidden whitespace-nowrap max-w-full"
                          >
                            Todos os Marcadores
                          </span>
                        </div>
                      </a>
                    </li>
                    <li
                      :class="{ 'label-select': activeLabelTitle === 'open' }"
                    >
                      <a
                        class="inline-flex text-left max-w-full w-full items-center cursor-pointer"
                        @click.prevent="labelSelect('open')"
                        ><!---->
                        <span
                          class="inline-flex rounded-sm bg-slate-100 h-3 w-3.5 mr-1.5 rtl:mr-0 rtl:ml-1.5 border border-black dark:border-slate-900"
                          style="background-color: rgb(224 231 228)"
                        />
                        <div
                          class="items-center flex overflow-hidden whitespace-nowrap text-ellipsis w-full justify-between"
                        >
                          <span
                            title="nao_atribuidas"
                            class="text-xs text-slate-700 dark:text-slate-100 text-ellipsis overflow-hidden whitespace-nowrap max-w-full"
                          >
                            Não Atribuídas
                          </span>
                        </div>
                      </a>
                    </li>
                    <li
                      v-for="label in labelsList"
                      :key="label.id"
                      :class="{
                        'label-select': activeLabelTitle === label.title,
                      }"
                    >
                      <a
                        url="javascrip:;"
                        class="inline-flex text-left max-w-full w-full items-center cursor-pointer"
                        :value="label.title"
                        @click.prevent="labelSelect(label)"
                      >
                        <woot-label
                          :value="label.title"
                          :title="label.description"
                          :description="label.title"
                          :show-close="false"
                          :color="label.color"
                          variant="dashed"
                          class="max-w-[calc(100%-0.5rem)]"
                        />
                      </a>
                    </li>
                  </ul>
                </li>
              </ul>
            </div>
          </div>
        </section>
      </div>
    </section>
    <conversation-status-view
      v-if="showing === 'kanban'"
      :selected-team="selectedTeamId"
      :selected-label="selectedLabel"
    />
    <conversation-view v-else />
  </section>
</template>

<script>
import ConversationStatusView from './ConversationStatusView';
import ConversationView from './ConversationView';
import uiSettingsMixin from 'dashboard/mixins/uiSettings';
import eventListenerMixins from 'shared/mixins/eventListenerMixins';
import conversationLabelMixin from 'dashboard/mixins/conversation/labelMixin';

import { mapGetters } from 'vuex';

export default {
  components: {
    'conversation-status-view': ConversationStatusView,
    'conversation-view': ConversationView,
  },
  mixis: [conversationLabelMixin, eventListenerMixins],
  data: function () {
    return {
      showing: 'kanban',
      selectedTeamId: 0,
      selectedLabel: '',
      activeLabelTitle: 'todos',
    };
  },
  mounted() {
    this.$store.dispatch('labels/get');
  },

  methods: {
    toggleView: function (value) {
      this.showing = value;
    },
    labelSelect(label) {
      if (label === 'todos' || label === 'open') {
        this.selectedLabel = label;
        this.activeLabelTitle = label;
      } else {
        this.selectedLabel = label.title;
        this.activeLabelTitle = label.title;
      }
    },
    teamSelect(event) {
      this.selectedTeamId = event.target.value;
    },
  },
  computed: {
    ...mapGetters({
      teamsList: 'teams/getTeams',
      labelsList: 'labels/getLabels',
    }),
  },
  mixins: [uiSettingsMixin],
  beforeDestroy: function () {
    this.updateUISettings({
      show_secondary_sidebar: true,
      previously_used_sidebar_view: true,
    });
  },
};
</script>

<style lang="scss" scoped>
.bordas {
  border-right: 1px solid rgba(0, 0, 0, 0.03);
}
.label-select {
  background-color: #dcf0fd;
  padding-left: 3px;
  border-radius: 5px;
  margin-left: 0px;
}
</style>
