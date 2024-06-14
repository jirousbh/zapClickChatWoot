<template>
  <div class="h-full schedule-vue-sample">
    <section class="flex flex-col w-full h-full">
      <section
        class="min-h-[64px] flex w-full justify-between items-center py-[8px] px-8 border-custom"
      >
        <div class="h-full flex gap-4 items-center">
          <div id="btnsChevron">
            <woot-button type="button" class="chevron-button">
              <span class="flex items-center gap-0.5">
                <fluent-icon icon="chevron-left" size="24" />
              </span>
            </woot-button>
            <woot-button type="button" class="chevron-button">
              <span class="flex items-center gap-0.5">
                <fluent-icon icon="chevron-right" size="24" />
              </span>
            </woot-button>
          </div>
          <span>
            {{
              selectedDate
                .toLocaleString('pt-BR', { month: 'long' })
                .charAt(0)
                .toUpperCase() +
              selectedDate.toLocaleString('pt-BR', { month: 'long' }).slice(1)
            }}
            {{ selectedDate.getFullYear() }}
          </span>
          <button class="today-btn" @click="changeSelectedDateToToday">
            Hoje
          </button>
        </div>

        <div id="btnSearch" class="h-full flex gap-4 items-center">
          <woot-button type="button" class="search-button">
            <span class="flex items-center gap-0.5">
              <fluent-icon icon="search" size="24" />
            </span>
          </woot-button>
          <select class="mb-0" @change="currentViewChange">
            <option value="Day">Dia</option>
            <option value="WorkWeek" selected>Semana</option>
            <option value="Month">Mês</option>
            <option value="Year">Ano</option>
          </select>
        </div>
      </section>

      <div class="h-full col-md-12 control-section">
        <div class="h-full content-wrapper flex">
          <section class="w-[300px] py-4 px-8 flex flex-col items-center gap-8">
            <ejs-menu :items="menuItems" />

            <ejs-calendar id="calendar" :change="onDateChange" />

            <div id="searchNamesContainer" class="w-full flex flex-col gap-4">
              <ejs-autocomplete
                id="searchNames"
                :data-source="names"
                :placeholder="'Buscar por ṕessoa'"
              />

              <ejs-accordion ref="Accordion_Nested">
                <e-accordionitems>
                  <e-accordionitem
                    header="Meus calendários"
                    :content="getMyCalendars()"
                    expanded="true"
                  />
                  <e-accordionitem
                    header="Outros calendários"
                    :content="getOtherCalendars()"
                    expanded="true"
                  />
                </e-accordionitems>
              </ejs-accordion>
            </div>
          </section>
          <ejs-schedule
            id="Schedule"
            :height="'800px'"
            :css-class="cssClass"
            :selected-date="selectedDate"
            :event-settings="eventSettings"
            :group="group"
            :current-view="currentView"
            :resource-header-template="'resourceHeaderTemplate'"
            :timezone="timezone"
            :show-header-bar="false"
          >
            <template #resourceHeaderTemplate="{ data }">
              <div class="template-wrap">
                <div class="resource-image">
                  <img
                    class="resource-image"
                    :src="getImage(data)"
                    :alt="getImage(data)"
                  />
                </div>
                <div class="resource-details">
                  <div class="resource-name">{{ getEmployeeName(data) }}</div>
                  <div class="resource-designation">
                    {{ getEmployeeDesignation(data) }}
                  </div>
                </div>
              </div>
            </template>
            <e-views>
              <e-view option="Day" />
              <e-view option="WorkWeek" />
              <e-view option="Month" :event-template="monthEventTemplate" />
              <e-view option="TimelineWeek" />
            </e-views>
            <e-resources>
              <e-resource
                field="ConferenceId"
                title="Attendees"
                name="Conferences"
                :allow-multiple="allowMultiple"
                :data-source="resourceDataSource"
                text-field="Text"
                id-field="Id"
                color-field="Color"
              />
            </e-resources>
          </ejs-schedule>
        </div>
      </div>
    </section>
  </div>
</template>
<script>
import { extend } from '@syncfusion/ej2-base';
import { resourceConferenceData } from './dataSourceSchedule';
import {
  ScheduleComponent,
  ViewDirective,
  ViewsDirective,
  ResourceDirective,
  ResourcesDirective,
  Day,
  WorkWeek,
  Month,
  TimelineViews,
  Resize,
  DragAndDrop,
} from '@syncfusion/ej2-vue-schedule';
import { CalendarComponent } from '@syncfusion/ej2-vue-calendars';
import { AutoCompleteComponent } from '@syncfusion/ej2-vue-dropdowns';
import {
  AccordionComponent,
  AccordionItemDirective,
  AccordionItemsDirective,
} from '@syncfusion/ej2-vue-navigations';
import { MenuComponent } from '@syncfusion/ej2-vue-navigations';
import uiSettingsMixin from 'dashboard/mixins/uiSettings';

// eslint-disable-next-line vue/one-component-per-file
export default {
  components: {
    'ejs-schedule': ScheduleComponent,
    'e-view': ViewDirective,
    'e-views': ViewsDirective,
    'e-resource': ResourceDirective,
    'e-resources': ResourcesDirective,
    'ejs-calendar': CalendarComponent,
    'ejs-autocomplete': AutoCompleteComponent,
    'ejs-accordion': AccordionComponent,
    'e-accordionitem': AccordionItemDirective,
    'e-accordionitems': AccordionItemsDirective,
    'ejs-menu': MenuComponent,
  },
  mixins: [uiSettingsMixin],
  provide: {
    schedule: [Day, WorkWeek, Month, TimelineViews, Resize, DragAndDrop],
  },
  data() {
    return {
      eventSettings: {
        dataSource: extend([], resourceConferenceData, null, true),
        fields: {
          subject: { title: 'Conference Name', name: 'Subject' },
          description: { title: 'Summary', name: 'Description' },
          startTime: { title: 'From', name: 'StartTime' },
          endTime: { title: 'To', name: 'EndTime' },
        },
      },
      selectedDate: new Date(),
      currentView: 'WorkWeek',
      cssClass: 'groupediting',
      group: {
        allowGroupEdit: true,
        resources: ['Conferences'],
      },
      resourceDataSource: [
        { Text: 'Margaret', Id: 1, Color: '#1aaa55' },
        { Text: 'Robert', Id: 2, Color: '#357cd2' },
        { Text: 'Laura', Id: 3, Color: '#7fa900' },
      ],
      allowMultiple: true,
      names: ['Margaret', 'Robert', 'Laura'],
      menuItems: [
        {
          text: 'Adicionar',
          items: [{ text: 'Evento' }, { text: 'Atividade' }],
        },
      ],
      timezone: 'America/Sao_Paulo',
    };
  },
  computed: {
    getImage() {
      return data => {
        return (
          'https://ej2.syncfusion.com/vue/demos/source/schedule/images/' +
          this.getEmployeeImage(data) +
          '.png'
        );
      };
    },
  },
  beforeMount() {
    this.updateUISettings({
      show_secondary_sidebar: true,
      previously_used_sidebar_view: true,
    });
  },
  methods: {
    getEmployeeName(data) {
      let value = JSON.parse(JSON.stringify(data));
      return value.resourceData
        ? value.resourceData[value.resource.textField]
        : value.resourceName;
    },
    getEmployeeImage(data) {
      let resourceName = this.getEmployeeName(data);
      return resourceName.toLowerCase();
    },
    getEmployeeDesignation(data) {
      let resourceName = this.getEmployeeName(data);
      const resourceRoles = new Map([
        ['Margaret', 'Sales Representative'],
        ['Robert', 'Vice President, Sales'],
      ]);

      return resourceRoles.get(resourceName) || 'Inside Sales Coordinator';
    },
    onDateChange(args) {
      this.selectedDate = args?.value;
    },
    changeSelectedDateToToday() {
      this.selectedDate = new Date();
    },
    onDateChange: function (args) {
      console.log(args)
      this.selectedDate = args?.value
    },
    changeSelectedDateToToday() {
      this.selectedDate = new Date()
    },
    getMyCalendars() {
      return `
        <div>
          <span class='flex items-center gap-4'>
            <input type='checkbox' id='nome'>
            <label for='nome'>Nome</label>
          </span>
          <span class='flex items-center gap-4'>
            <input type='checkbox' id='atividade'>
            <label for='atividade'>Atividade</label>
          </span>
        </div>
      `;
    },
    getOtherCalendars() {
      return `
        <div>
          <span class='flex items-center gap-4'>
            <input type='checkbox' id='nome1'>
            <label for='nome1'>Nome</label>
          </span>
          <span class='flex items-center gap-4'>
            <input type='checkbox' id='nome2'>
            <label for='nome2'>Nome</label>
          </span>
        </div>
      `;
    },
    currentViewChange(event) {
      this.currentView = event?.target.value;
    },
  },
};
</script>

<style>
@import '../../../../../../node_modules/@syncfusion/ej2-base/styles/material.css';
@import '../../../../../../node_modules/@syncfusion/ej2-buttons/styles/material.css';
@import '../../../../../../node_modules/@syncfusion/ej2-calendars/styles/material.css';
@import '../../../../../../node_modules/@syncfusion/ej2-dropdowns/styles/material.css';
@import '../../../../../../node_modules/@syncfusion/ej2-inputs/styles/material.css';
@import '../../../../../../node_modules/@syncfusion/ej2-navigations/styles/material.css';
@import '../../../../../../node_modules/@syncfusion/ej2-popups/styles/material.css';
@import '../../../../../../node_modules/@syncfusion/ej2-vue-schedule/styles/material.css';

.schedule-vue-sample {
  width: 100%;
  height: 100%;
}

.schedule-vue-sample
  .groupediting.e-schedule
  .e-month-view
  .e-appointment
  .e-appointment-details {
  padding: 1px;
  padding-left: 3px;
}

.schedule-vue-sample
  .groupediting.e-schedule
  .e-vertical-view
  .e-resource-cells {
  height: 62px;
}

.schedule-vue-sample .groupediting.e-schedule .template-wrap {
  display: flex;
  text-align: left;
}

.schedule-vue-sample .groupediting.e-schedule .template-wrap .resource-image {
  width: 45px;
  height: 45px;
  background-size: 45px;
  background-repeat: no-repeat;
}

.schedule-vue-sample .groupediting.e-schedule .template-wrap .resource-details {
  padding-left: 10px;
}

.schedule-vue-sample
  .groupediting.e-schedule
  .template-wrap
  .resource-details
  .resource-name {
  font-size: 16px;
  font-weight: 500;
  padding-right: 10px;
}

.schedule-vue-sample
  .groupediting.e-schedule
  .template-wrap
  .resource-details
  .resource-designation {
  font-size: 12px;
}

.schedule-vue-sample
  .groupediting.e-schedule.e-device
  .template-wrap
  .resource-details
  .resource-designation {
  display: none;
}

.schedule-vue-sample
  .groupediting.e-schedule.e-device
  .template-wrap
  .resource-details
  .resource-name {
  font-size: inherit;
  font-weight: inherit;
  padding-top: 5px;
}

.schedule-vue-sample
  .groupediting.e-schedule.e-device
  .e-resource-tree-popup
  .e-fullrow {
  height: 50px;
}

.e-calendar {
  border: none;
}

.e-schedule {
  border: none;
}

.border-custom {
  border-bottom: 1px solid rgba(0, 0, 0, 0.2);
}

.e-time-slots {
  padding: 0 !important;
}

#calendar .e-footer-container {
  display: none !important;
}

#btnsChevron .chevron-button,
#btnSearch .search-button {
  background-color: transparent !important;
  color: rgba(0, 0, 0, 0.8);
}

.e-schedule-table .e-current-day,
.e-calendar .e-content td.e-focused-date .e-today span.e-day,
.e-calendar .e-content td.e-today:not(e-selected) span.e-day,
.e-calendar .e-content td.e-today:hover span.e-day,
.e-schedule .e-vertical-view .e-current-time,
.e-btn.e-flat.e-primary {
  color: rgb(26, 115, 232) !important;
}

.e-calendar .e-content td.e-selected span.e-day {
  background-color: rgb(26, 115, 232) !important;
}

.e-calendar .e-content td.e-focused-date.e-today span.e-day,
.e-calendar .e-content td.e-today span.e-day,
.e-calendar .e-content td.e-today:hover span.e-day,
.e-schedule .e-vertical-view .e-current-timeline,
.e-schedule .e-vertical-view .e-previous-timeline {
  border-color: rgb(26, 115, 232) !important;
}

.e-accordion
  .e-acrdn-item.e-select.e-selected.e-expand-state
  > .e-acrdn-header
  .e-acrdn-header-content {
  color: rgba(0, 0, 0, 0.87) !important;
}

.e-input-focus::before,
.e-input-focus::after,
#ScheduleEditForm .e-input-focus .e-float-line::before,
#ScheduleEditForm .e-input-focus .e-float-line::after {
  background: rgb(26, 115, 232) !important;
}

.today-btn {
  padding: 5px 10px;
  border: 1px solid rgba(0, 0, 0, 0.3);
  border-radius: 5px;
  color: rgba(0, 0, 0, 0.8);
  transition: 0.15s;
}
.today-btn:hover {
  background: rgba(0, 0, 0, 0.15);
  transition: 0.15s;
}

.today-btn:active {
  background: rgba(0, 0, 0, 0.3);
  transition: 0.15s;
}

#searchNamesContainer > span {
  border-radius: 0px !important;
  background: rgba(0, 0, 0, 0.05) !important;
  padding: 0 10px !important;
  height: 40px !important;
}

#ScheduleEditForm .e-input-focus label {
  color: rgb(26, 115, 232);
}

#ScheduleEditForm .e-check {
  background: rgb(26, 115, 232) !important;
}
</style>
