<template>
  <div class="h-full schedule-vue-sample">
    <div class="h-full col-md-12 control-section">
      <div class="h-full content-wrapper flex">
        <section class="w-[300px] p-4 flex flex-col items-center gap-8">
          <ejs-calendar id="calendar" />

          <div class="w-full flex flex-col gap-4">
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
          height="100%"
          :css-class="cssClass"
          :selected-date="selectedDate"
          :event-settings="eventSettings"
          :group="group"
          :current-view="currentView"
          :resource-header-template="'resourceHeaderTemplate'"
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
  },
  provide: {
    schedule: [Day, WorkWeek, Month, TimelineViews, Resize, DragAndDrop],
  },
  data: function () {
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
          text: 'File',
          iconCss: 'e-menu-icons e-menu-file',
          items: [
            { text: 'Evento', iconCss: 'e-menu-icons e-menu-open' },
            { text: 'Atividade', iconCss: 'e-menu-icons e-menu-save' },
            { separator: true },
            { text: 'Exit' },
          ],
        },
      ],
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
  methods: {
    getEmployeeName: function (data) {
      let value = JSON.parse(JSON.stringify(data));
      return value.resourceData
        ? value.resourceData[value.resource.textField]
        : value.resourceName;
    },
    getEmployeeImage: function (data) {
      let resourceName = this.getEmployeeName(data);
      return resourceName.toLowerCase();
    },
    getEmployeeDesignation: function (data) {
      let resourceName = this.getEmployeeName(data);
      // eslint-disable-next-line no-nested-ternary
      return resourceName === 'Margaret'
        ? 'Sales Representative'
        : resourceName === 'Robert'
          ? 'Vice President, Sales'
          : 'Inside Sales Coordinator';
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
</style>
