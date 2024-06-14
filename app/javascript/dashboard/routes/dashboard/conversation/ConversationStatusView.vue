<template>
    <!-- <div class="min-w-[230px] h-full py-2">
      <div class="bg-black-100 h-full rounded-xl w-full py-4 px-2">
        <label>
          Visualização:
        </label>
        <woot-button
          type="button"
          :disabled="true"
          class="button-visualization"
        >
          <span class="flex items-center gap-0.5">
            <fluent-icon icon="arrow-trending-lines" size="16" />
            Kanban
          </span>
        </woot-button>
        <woot-button
          type="button"
          @click="redirectToDashboard"
          class="button-visualization"
        > 
          <span class="flex items-center gap-0.5">
            <fluent-icon icon="chat" size="16" />
            Conversas
          </span>
        </woot-button>
        <div class="mt-4" v-on:click="() => toggleModalFunil('open')">
            <ejs-button cssClass="e-flat" :isPrimary="false" d='dlgbtn' v-on:click="() => toggleModal('open')">
              Configurar funil
            </ejs-button>
          </div>
      </div>
    </div> -->

    <div class="col-md-12 control-section" id="container">
      <div class="content-wrapper" id="container-kanban">
        <div class="flex justify-between items-center w-full">
          <!-- <div class="container-button-visualization">""
            <label>
              Visualização:
            </label>
            <woot-button
              type="button"
              :disabled="true"
              class="button-visualization"
            >
              <span class="flex items-center gap-0.5">
                <fluent-icon icon="arrow-trending-lines" size="16" />
                Kanban
              </span>
            </woot-button>
            <woot-button
              type="button"
              @click="redirectToDashboard"
              class="button-visualization"
            > 
              <span class="flex items-center gap-0.5">
                <fluent-icon icon="chat" size="16" />
                Conversas
              </span>
            </woot-button>
            <div class="mt-4" v-on:click="() => toggleModalFunil('open')">
                <ejs-button cssClass="e-flat" :isPrimary="false" d='dlgbtn' v-on:click="() => toggleModal('open')">
                  Configurar funil
                </ejs-button>
              </div>
          </div> -->
          <div v-on:click="() => toggleModalFunil('open')">
            <ejs-button cssClass="e-flat" :isPrimary="false" d='dlgbtn'>
              Configurar funil
            </ejs-button>
          </div>
          <div class="container-search">
            <span class="flex items-center gap-0.5">
              <fluent-icon icon="filter" size="30" class="icon-filter"/>
              <span class="mb-2 MR-4">
                <div>
                  <div class="grid grid-cols-1 gap-4 md:grid-cols-1 lg:grid-cols-2 xl:grid-cols-3">
                    <div class="flex flex-col">
                      <label for="name" class="text-stone-600 text-sm font-medium">Nome</label>
                      <input type="text" id="name" placeholder="Filtre por nome" class="mt-2 block w-full rounded-md border border-gray-200 px-2 py-2 shadow-sm outline-none focus:border-blue-500 focus:ring focus:ring-blue-200 focus:ring-opacity-50" />
                    </div>
  
                    <div class="flex flex-col">
                      <label for="date" class="text-stone-600 text-sm font-medium">Data</label>
                      <input type="date" id="date" class="mt-2 block w-full rounded-md border border-gray-200 px-2 py-2 shadow-sm outline-none focus:border-blue-500 focus:ring focus:ring-blue-200 focus:ring-opacity-50" />
                    </div>
  
                    <div class="flex flex-col">
                      <label for="status" class="text-stone-600 text-sm font-medium">Funil</label>
  
                      <select id="status" class="mt-2 block w-full rounded-md border border-gray-200 px-2 py-2 shadow-sm outline-none focus:border-blue-500 focus:ring focus:ring-blue-200 focus:ring-opacity-50">
                        <option checked>Selecione</option>
                        <option>Agendados</option>
                        <option>Reagendados</option>
                        <option>Remarcados</option>
                        <option>Tratativas</option>
                      </select>
                    </div>
                  </div>
                </div>
              </span>
              <ejs-textbox width="250px" class="e-large" placeholder="Pesquisar" ref="SearchText" id="search_text"></ejs-textbox>
              <woot-button
                type="button"
                class="button-search"
              >
                <span class="flex items-center gap-0.5">
                  <fluent-icon icon="search" size="16" />
                </span>
              </woot-button>
            </span>
          </div>
        </div>
        <ejs-kanban cssClass="kanban-card-default" id="kanban" keyField="status" :dataSource="conversationList"
        :cardSettings="cardSettings" :cardClick="onCardClick" ref="KanbanObj" :allowToggle="allowToggle" :dragStart="dragStart"  :dragStop="dragStop">
          <e-columns>
            <e-column headerText="Agendados" keyField="open" :allowToggle="allowToggle"></e-column>
            <e-column headerText="Reagendados" keyField="mock1" :allowToggle="allowToggle"></e-column>
            <e-column headerText="Remarcados" keyField="mock2" :allowToggle="allowToggle"></e-column>
            <e-column headerText="Tratativas" keyField="mock3" :allowToggle="allowToggle"></e-column>
          </e-columns>
        </ejs-kanban>
      </div>
  
      <Modal :show="showModalFunil" :onClose="() => toggleModalFunil('close')" :w60="true">
      <div class="h-[82vh] w-full px-4 pt-16">
        <h2 class="text-xl font-semibold mb-8">Configurar Etapas</h2>
        <ejs-grid :dataSource="data" :editSettings='editSettings' :cell-edit="rowSelected">
            <e-columns>
                <e-column field='nomeEtapa' headerText='Etapas do Funil' textAlign='center'></e-column>
                <e-column field='camposObrigatorios' headerText='Campos Obrigatórios' textAlign='center' editType='booleanedit' displayAsCheckBox='true' type='boolean' ></e-column>
                <e-column field='campoValor' headerText='Campo de Valor' textAlign='center' editType='booleanedit' displayAsCheckBox='true' type='boolean' ></e-column>
                <e-column headerText='Etapa Final' textAlign='center' field="etapaFinal" editType='booleanedit' displayAsCheckBox='true' type='boolean' ></e-column>
            </e-columns>
        </ejs-grid>
        <woot-button
          type="button"
          class="button-visualization mt-4"
          v-on:click="() => pushTable()"
        >
          Adicionar etapa
        </woot-button>
        <hr>
        <h2 class="text-xl font-semibold my-8">Campos que vão aparecer no card</h2>
        <div class="w-[350px] pb-8">
          <ejs-grid :dataSource="[{nomeCampo: 'Campo 1', campoSelecionado: false}, {nomeCampo: 'Tag 1', campoSelecionado: false}]" :editSettings='editSettings'>
              <e-columns>
                  <e-column field='nomeCampo' headerText='Nome do campo' textAlign='center'></e-column>
                  <e-column field='campoSelecionado' headerText='' textAlign='center' editType='booleanedit' displayAsCheckBox='true' type='boolean' ></e-column>
              </e-columns>
          </ejs-grid>
        </div>
      </div>
    </Modal>

    <Modal :show="showModalChat" :onClose="() => toggleModalChat('close')" :w80="true">
      <div class="h-[82vh] w-full px-4 pt-16">
        <conversation-box
          v-if="true"
          :inbox-id="1"
          :is-contact-panel-open="true"
          :is-on-expanded-layout="true"
          @contact-panel-toggle="false"
          class="h-full"
        />
      </div>
    </Modal>
    </div>
</template>
<style>
@import '../../../../../../node_modules/@syncfusion/ej2-base/styles/material.css';
@import '../../../../../../node_modules/@syncfusion/ej2-buttons/styles/material.css';
@import '../../../../../../node_modules/@syncfusion/ej2-layouts/styles/material.css';
@import '../../../../../../node_modules/@syncfusion/ej2-dropdowns/styles/material.css';
@import '../../../../../../node_modules/@syncfusion/ej2-navigations/styles/material.css';
@import '../../../../../../node_modules/@syncfusion/ej2-popups/styles/material.css';
@import '../../../../../../node_modules/@syncfusion/ej2-vue-kanban/styles/material.css';
@import '../../../../../../node_modules/@syncfusion/ej2-vue-inputs/styles/bootstrap.css';
@import "../../../../../../node_modules/@syncfusion/ej2-vue-grids/styles/tailwind.css";

.e-kanban.kanban-card-default .e-card-footer-css {
  align-self: center;
  background-repeat: no-repeat;
  background-size: cover;
  background-position: center;
  height: 16px;
  width: 16px;
}
.e-kanban.kanban-card-default .e-improvement {
  background-image: url(https://syncfusion.atlassian.net/secure/viewavatar?size=medium&avatarId=15507&avatarType=issuetype);
}
.e-kanban.kanban-card-default .e-story {
  background-image: url(https://syncfusion.atlassian.net/secure/viewavatar?size=medium&avatarId=15515&avatarType=issuetype);
}
.e-kanban.kanban-card-default .e-epic {
  background-image: url(https://syncfusion.atlassian.net/secure/viewavatar?size=medium&avatarId=15507&avatarType=issuetype);
}
.e-kanban.kanban-card-default .e-bug {
  background-image: url(https://syncfusion.atlassian.net/secure/viewavatar?size=medium&avatarId=15503&avatarType=issuetype);
}
.e-kanban.kanban-card-default .e-others {
  background-image: url(https://syncfusion.atlassian.net/images/icons/issuetypes/documentation.png);
}
.e-kanban.kanban-card-default .e-low {
  margin-right: auto;
  background-image: url(https://syncfusion.atlassian.net/images/icons/priorities/trivial.svg);
}
.e-kanban.kanban-card-default .e-high {
  margin-right: auto;
  background-image: url(https://syncfusion.atlassian.net/images/icons/priorities/major.svg);
}
.e-kanban.kanban-card-default .e-critical {
  margin-right: auto;
  background-image: url(https://syncfusion.atlassian.net/images/icons/priorities/critical.svg);
}
.e-kanban.kanban-card-default .e-release {
  margin-right: auto;
  background-image: url(https://syncfusion.atlassian.net/images/icons/priorities/critical.svg);
}
.e-kanban.kanban-card-default .e-normal {
  margin-right: auto;
  background-image: url(https://syncfusion.atlassian.net/images/icons/priorities/minor.svg);
}
.e-kanban.kanban-card-default .e-nancy-davloio {
  background-image: url(https://ej2.syncfusion.com/demos/src/kanban/images/Nancy%20Davloio.png);
}
.e-kanban.kanban-card-default .e-andrew-fuller {
  background-image: url(https://ej2.syncfusion.com/demos/src/kanban/images/Andrew%20Fuller.png);
}
.e-kanban.kanban-card-default .e-janet-leverling {
  background-image: url(https://ej2.syncfusion.com/demos/src/kanban/images/Janet%20Leverling.png);
}
.e-kanban.kanban-card-default .e-steven-walker {
  background-image: url(https://ej2.syncfusion.com/demos/src/kanban/images/Steven%20walker.png);
}
.e-kanban.kanban-card-default .e-michael-suyama {
  background-image: url(https://ej2.syncfusion.com/demos/src/kanban/images/Michael%20Suyama.png);
}
.e-kanban.kanban-card-default .e-robert-king {
  background-image: url(https://ej2.syncfusion.com/demos/src/kanban/images/Robert%20King.png);
}
.e-kanban.kanban-card-default .e-margaret-hamilt {
  background-image: url(https://ej2.syncfusion.com/demos/src/kanban/images/Margaret%20hamilt.png);
}

.e-kanban.kanban-card-default .e-nancy-davloio, .e-kanban.kanban-card-default .e-andrew-fuller, .e-kanban.kanban-card-default .e-janet-leverling,
.e-kanban.kanban-card-default .e-steven-walker, .e-kanban.kanban-card-default .e-michael-suyama, .e-kanban.kanban-card-default .e-robert-king, .e-kanban.kanban-card-default .e-margaret-hamilt  {
  border-radius: 72px;
  height: 40px;
  width: 40px;
}

#container {
  height: 100%;
  background: #FFF;
}

#container-kanban {
  padding: 10px 20px;
}

.e-kanban .e-kanban-table.e-content-table .e-content-row:not(.e-swimlane-row) td {
  background: #f5f5f5;
  height: 800px;
  border-radius: 15px;
}

.e-kanban .e-card-wrapper::-webkit-scrollbar {
  width: 8px;
}

.e-kanban .e-card-wrapper::-webkit-scrollbar-thumb {
  background-color: #dbdbdb;
  border-radius: 6px;
}

.e-kanban .e-card-wrapper::-webkit-scrollbar-track {
  background-color: #ebebeb;
  border-radius: 10px;
}

.e-kanban .e-kanban-content .e-content-row .e-content-cells .e-card-wrapper .e-card {
  border-radius: 15px;
}

.e-kanban .e-kanban-content .e-content-row .e-content-cells .e-card-wrapper .e-card:hover {
  background-color: rgb(216, 216, 216);
}

.e-kanban .e-kanban-content .e-content-row .e-content-cells.e-collapsed .e-collapse-header-text {
  rotate: 180deg;
}

.e-kanban .e-kanban-header .e-header-cells {
  border-radius: 15px;
}

.button-visualization {
  border-radius: 15px;
  background-color: #00BDD1 !important;
}

.container-button-visualization {
  margin: 10px 10px 40px 10px;
}

.container-search {
  margin: 10px 10px 10px 10px;
  display: flex;
  justify-content: center;
}

.e-input:not(:valid), .e-input:valid, .e-float-input.e-control-wrapper input:not(:valid), .e-float-input.e-control-wrapper input:valid, .e-float-input input:not(:valid), .e-float-input input:valid, .e-input-group input:not(:valid), .e-input-group input:valid, .e-input-group.e-control-wrapper input:not(:valid), .e-input-group.e-control-wrapper input:valid, .e-float-input.e-control-wrapper textarea:not(:valid), .e-float-input.e-control-wrapper textarea:valid, .e-float-input textarea:not(:valid), .e-float-input textarea:valid, .e-input-group.e-control-wrapper textarea:not(:valid), .e-input-group.e-control-wrapper textarea:valid, .e-input-group textarea:not(:valid), .e-input-group textarea:valid {
  height: 2.5rem;
}

.e-input-group:not(.e-success):not(.e-warning):not(.e-error):not(.e-float-icon-left),
.e-input-group:hover:not(.e-success):not(.e-warning):not(.e-error):not(.e-float-icon-left) { /* csslint allow: adjoining-classes */
  border-radius: 15px;
}

.button-search {
  margin-left: 15px;
  border-radius: 15px;
  background-color: #00BDD1 !important;
}

.icon-filter {
  color: #00BDD1 !important;
  margin-right: 15px;
}

</style>
<script>
import Vue from "vue";
import { extend } from "@syncfusion/ej2-base";
import { KanbanComponent, ColumnDirective, ColumnsDirective, KanbanPlugin, } from "@syncfusion/ej2-vue-kanban";
import { ButtonPlugin } from "@syncfusion/ej2-vue-buttons";
import { TextBoxPlugin } from "@syncfusion/ej2-vue-inputs";
import { kanbanData } from "./datasource";
import { GridComponent, Edit, GridPlugin } from '@syncfusion/ej2-vue-grids';
import { TextBoxComponent } from "@syncfusion/ej2-vue-inputs";
import ConversationBox from '../../../components/widgets/conversation/ConversationBox.vue';
import Modal from '../../../components/Modal.vue'
import { mapGetters } from 'vuex';
import uiSettingsMixin from 'dashboard/mixins/uiSettings';


Vue.use(KanbanPlugin);
Vue.use(TextBoxPlugin);
Vue.use(ButtonPlugin);
Vue.use(GridPlugin);

export default {
  components: {
    'ejs-kanban': KanbanComponent,
    'e-column': ColumnDirective,
    'e-columns': ColumnsDirective,
    'ejs-textbox': TextBoxComponent,
    'ejs-grid': GridComponent,
    'Modal': Modal,
    ConversationBox
  },
  mixins:[uiSettingsMixin],
  props: {
    conversationId: {
      type: [String, Number],
      default: 0,
    },
  },
  data: function() {
    return {
      kanbanData: extend([], kanbanData, null, true),
      cardSettings: {
        contentField: "name",
        headerField: "name",
        tagsField: 'status',
        grabberField: 'color',
      },
      allowToggle: true,
      showModalFunil: false,
      showModalChat: false,
      editSettings: { allowEditing: true, mode: 'Batch'},
      data: [],
      statusOnStartDrag: '',
    };
  },
  provide: {
    kanban: [],
    grid: [Edit],
  },
  beforeMount: function() {
    this.updateUISettings({
      show_secondary_sidebar: false,
      previously_used_sidebar_view: false,
    });
  },
  watch: {
    conversationId() {
      this.fetchConversationIfUnavailable();
    },
  },
  mounted() {
    this.$store.dispatch('agents/get');
    this.initialize();
    this.$watch('$store.state.route', () => this.initialize());
    this.$watch('chatList.length', () => {
      this.setActiveChat();
    });
  },
  beforeMount: function() {
    this.updateUISettings({
      show_secondary_sidebar: false,
      previously_used_sidebar_view: false,
    });
  },
  methods: {
    initialize() {
      this.$store.dispatch('setActiveInbox', this.inboxId);
      this.setActiveChat();
    },
    setActiveChat() {
      if (this.conversationId) {
        const selectedConversation = this.findConversation();
        // If conversation doesn't exist or selected conversation is same as the active
        // conversation, don't set active conversation.
        if (
          !selectedConversation ||
          selectedConversation.id === this.currentChat.id
        ) {
          return;
        }
        const { messageId } = this.$route.query;
        this.$store
          .dispatch('setActiveChat', {
            data: selectedConversation,
            after: messageId,
          })
          .then(() => {
            bus.$emit(BUS_EVENTS.SCROLL_TO_MESSAGE, { messageId });
          });
      } else {
        this.$store.dispatch('clearSelectedState');
      }
    },
    findConversation() {
      const conversationId = parseInt(this.conversationId, 10);
      const [chat] = this.chatList.filter(c => c.id === conversationId);
      return chat;
    },
    fetchConversationIfUnavailable() {
      if (!this.conversationId) {
        return;
      }
      const chat = this.findConversation();
      if (!chat) {
        this.$store.dispatch('getConversation', this.conversationId);
      }
    },
    onCardClick: function(_args) {
      // const id = 1; // Substituir pelo id da conversa
      // const conversationUrl = `/app/accounts/1/conversations/${id}`;
      // window.open(conversationUrl, '_blank');
      this.toggleModalChat('open')
    },
    redirectToDashboard() {
      this.$router.push('/app/accounts/1/dashboard');
    },
    toggleModalFunil(action) {
      if (action == 'open') {
        this.showModalFunil = true
      } else {
        this.showModalFunil = false
      }
    },
    toggleModalChat(action) {
      if (action == 'open') {
        this.showModalChat = true
      } else {
        this.showModalChat = false
      }
    },
    rowSelected(e) {
      console.log(e, this.data[0])
    },
    pushTable() {
      const hasId = this.data.at(-1)?.id
      const newId = hasId >= 0 ? hasId + 1 : 0 
      this.data.push({id: newId, nomeEtapa: `Etapa ${newId}`, camposObrigatorios: false, campoValor: false, etapaFinal: false})
    },
    dragStart(event) {
      this.statusOnStartDrag = event?.data[0]?.Status;
      console.log(event);

    },
    dragStop(event) {
      console.log(event);
    },
  },
  computed: {
    ...mapGetters({
      chatList: 'getAllConversations',
      currentChat: 'getSelectedChat',
      mineChatsList: 'getMineChats',
    }),
    isContactPanelOpen() {
      if (this.currentChat.id) {
        const { is_contact_sidebar_open: isContactSidebarOpen } =
          this.uiSettings;
        return isContactSidebarOpen;
      }
      return false;
    },
    conversationList() {
      const filters = {
            assigneeType: "me",
            status: "open",
            sortBy: "last_activity_at_desc",
            page: 3
      };
      let conversationList = [];
      let formatedConversationList = [];
      conversationList = [...this.mineChatsList(filters)];

      conversationList.map(conversation => {
        let getData = {
          name: conversation?.meta.sender.name,
          status: conversation?.status,
          color: "#02897B",
        };
        formatedConversationList.push(getData);
      });

      return formatedConversationList;
    },
  },
}
</script>
