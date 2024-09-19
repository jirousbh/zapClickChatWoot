<template>
  <div class="h-full schedule-vue-sample bg-white">
    <section class="flex flex-col w-full h-full">
      <section
        id="scheduleHeader"
        class="min-h-[64px] flex w-full justify-between items-center py-[8px] px-8 border-custom"
      >
        <div class="h-full flex gap-4 items-center">
          <div id="btnsChevron">
            <woot-button
              type="button"
              class="chevron-button"
              @click="prevMonthDate"
            >
              <span class="flex items-center gap-0.5">
                <fluent-icon icon="chevron-left" size="24" />
              </span>
            </woot-button>
            <woot-button
              type="button"
              class="chevron-button"
              @click="nextMonthDate"
            >
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
            <option value="Agenda">Agenda</option>
          </select>
        </div>
      </section>

      <div class="h-full col-md-12 control-section template-accordion">
        <div class="h-full content-wrapper flex">
          <section class="w-[300px] py-4 px-4 flex flex-col items-center gap-8">
            <ejs-menu :items="menuItems" :select="insertActivityOrEvent" />

            <ejs-calendar id="calendar" :change="onDateChange" locale="pt" />

            <div id="searchNamesContainer" class="w-full flex flex-col gap-4">
              <ejs-autocomplete
                id="searchNames"
                :data-source="names"
                :placeholder="'Buscar por ṕessoa'"
              />
            </div>
          </section>

          <ejs-schedule
            id="Schedule"
            ref="scheduleObj"
            :height="'800px'"
            :css-class="cssClass"
            :selected-date="selectedDate"
            :event-settings="eventSettings"
            :current-view="currentView"
            :resource-header-template="'resourceHeaderTemplate'"
            :timezone="timezone"
            :show-header-bar="false"
            :group="group"
            @actionBegin="onActionBegin"
            :locale="locale"
          >
            <template #resourceHeaderTemplate="{ data }">
              <div class="template-wrap">
                <div class="resource-image">
                  <thumbnail :src="getEmployeeImage(data)" size="48px" />
                </div>
                <div class="resource-details">
                  <div class="resource-name">
                    {{ getEmployeeName(data) }}
                  </div>
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
              <e-view
                option="Agenda"
                :allowVirtualScrolling="virtualscroll"
              ></e-view>
            </e-views>
            <e-resources>
              <e-resource
                field="WorkerIds"
                title="Colaboradores"
                name="Conferences"
                :allow-multiple="allowMultiple"
                :data-source="resourceDataSource"
                text-field="Name"
                id-field="Id"
                color-field="Color"
                roles-field="Roles"
              />
            </e-resources>
          </ejs-schedule>
        </div>
      </div>
    </section>
  </div>
</template>
<script>
import { LOCAL_STORAGE_KEYS } from 'dashboard/constants/localStorage';
import Thumbnail from '../../../components/widgets/Thumbnail.vue';
import { LocalStorage } from 'shared/helpers/localStorage';
import {
  ScheduleComponent,
  ViewDirective,
  ViewsDirective,
  ResourceDirective,
  ResourcesDirective,
  Day,
  Agenda,
  WorkWeek,
  Month,
  Year,
  TimelineViews,
  Resize,
  DragAndDrop,
  ICalendarExport,
  ExcelExport,
} from '@syncfusion/ej2-vue-schedule';
import { CalendarComponent } from '@syncfusion/ej2-vue-calendars';
import { AutoCompleteComponent } from '@syncfusion/ej2-vue-dropdowns';
import { loadCldr, L10n } from '@syncfusion/ej2-base';
import {
  MenuComponent,
  AccordionComponent,
  AccordionItemDirective,
  AccordionItemsDirective,
} from '@syncfusion/ej2-vue-navigations';
import uiSettingsMixin from 'dashboard/mixins/uiSettings';
import { mapGetters } from 'vuex';
import { apiURL, calendarsURL } from '../../../helper/URLHelper';
import AccordionItem from 'dashboard/components/Accordion/AccordionItem.vue';
import Spinner from 'shared/components/Spinner.vue';
import localeText from './syncfusion-locale/pt.json';
L10n.load(localeText);
loadCldr(
  require('cldr-data/supplemental/numberingSystems.json'),
  require('cldr-data/main/pt/ca-gregorian.json'),
  require('cldr-data/main/pt/numbers.json'),
  require('cldr-data/main/pt/timeZoneNames.json'),
  require('cldr-data/supplemental/weekData.json')
);

export default {
  beforeRouteEnter(to, from, next) {
    next(vm => {
      if (!sessionStorage.getItem('reloaded')) {
        vm.reloadPage(); // Recarrega a página apenas se ainda não tiver recarregada
      }
    });
  },
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
    AccordionItem,
    Thumbnail,
    Spinner,
  },
  mixins: [uiSettingsMixin],
  props: {
    isOpen: {
      type: Boolean,
      default: false,
    },
    onToggle: {
      type: Function,
      default: () => {
        !this.isOpen;
      },
    },
  },
  data() {
    return {
      readonly: false,
      locale: 'pt',
      eventSettings: {
        dataSource: [],
      },
      selectedDate: new Date(),
      currentView: 'WorkWeek',
      cssClass: 'groupediting',
      group: {
        allowGroupEdit: true,
        resources: ['Conferences'],
      },
      resourceDataSource: [],
      allowMultiple: true,
      resources: [
        {
          field: 'WorkerId',
          title: 'Worker',
          name: 'Workers',
          allowMultiple: false,
          dataSource: [],
          textField: 'Name',
          idField: 'Id',
          colorField: 'Color',
        },
      ],
      menuItems: [
        {
          text: 'Adicionar',
          items: [
            { text: 'Evento', id: 'event' },
            { text: 'Atividade', id: 'activity' },
          ],
        },
      ],
      exportMenuItems: [
        {
          text: '',
          iconCss: 'horizontaldot e-icons',
          cssClass: 'e-flat',
          items: [
            { text: 'Exportar para iCalendar', id: 'ical' },
            { text: 'exportar para Excel', id: 'xlsx' },
          ],
        },
      ],
      timezone: 'America/Sao_Paulo',
      selectedCalendarId: null,
      virtualscroll: false,
      open: true,
      googleCalendar: null,
      names: ['Guilherme', 'John'],
      eventsSettings: {
        dataSource: [],
      },
      reloadValue: 0,
    };
  },
  provide: {
    schedule: [
      Day,
      WorkWeek,
      Month,
      Year,
      TimelineViews,
      Resize,
      DragAndDrop,
      Agenda,
      ICalendarExport,
      ExcelExport,
    ],
  },
  computed: {
    ...mapGetters({
      accountId: 'getCurrentAccountId',
      currentUser: 'getCurrentUser',
      calendar: 'calendars/defaultCalendar',
      agents: 'agents/getVerifiedAgents',
    }),

    scheduleUrl() {
      return [
        calendarsURL({
          accountId: this.accountId,
          calendarId: 1,
        }),
        this.currentUser.access_token,
      ];
    },
    schedules() {
      return this.$store.getters['calendars/getAllSchedules'];
    },
    monthEventTemplate() {
      return data => {
        return (
          '<div class="template-wrap">' +
          '<div class="subject" style="font-weight: 500;">' +
          data.Subject +
          '</div>' +
          '<div class="time">' +
          this.getEmployeeName(data) +
          '</div>' +
          '</div>'
        );
      };
    },
  },

  beforeMount() {
    this.$store.dispatch('calendars/get');
    this.$store.dispatch('agents/get');
    this.$store.dispatch('calendars/getDefaultCalendar');
    this.updateUISettings({
      show_secondary_sidebar: true,
      previously_used_sidebar_view: true,
    });
  },
  mounted() {
    this.$refs.scheduleObj = this.$refs.scheduleObj.$el.ej2_instances[0];
    this.fetchEvents();
    this.fetchWorkers();
    this.applySyncfusionStyles();
  },
  methods: {
    reloadPage() {
      sessionStorage.setItem('reloaded', 'true');
      window.location.reload();
    },
    applySyncfusionStyles() {
      import('@syncfusion/ej2-base/styles/tailwind.css');
      import('@syncfusion/ej2-layouts/styles/tailwind.css');
      import('@syncfusion/ej2-buttons/styles/tailwind.css');
      import('@syncfusion/ej2-calendars/styles/tailwind.css');
      import('@syncfusion/ej2-dropdowns/styles/tailwind.css');
      import('@syncfusion/ej2-inputs/styles/tailwind.css');
      import('@syncfusion/ej2-navigations/styles/tailwind.css');
      import('@syncfusion/ej2-popups/styles/tailwind.css');
      import('@syncfusion/ej2-vue-schedule/styles/tailwind.css');
    },
    onPanelToggle(value) {
      this.open = !this.open;
    },
    onActionBegin(args) {
      if (args.requestType === 'eventCreate') {
        this.createEvent(args.data[0]);
      } else if (args.requestType === 'eventChange') {
        this.updateEvent(args.data);
      } else if (args.requestType === 'eventRemove') {
        this.deleteEvent(args.data[0]);
      }
    },
    createEvent(event) {
      axios
        .post(apiURL(`accounts/${this.accountId}/schedules`), {
          subject: event.Subject,
          start_time: event.StartTime,
          end_time: event.EndTime,
          description: event.Description,
          location: event.Location,
          user_ids: event.WorkerIds,
        })
        .then(response => {
          this.fetchEvents();
        })
        .catch(error => {
          console.error(error);
        });
    },
    updateEvent(event) {
      axios
        .put(apiURL(`accounts/${this.accountId}/schedules/${event.Id}`), {
          subject: event.Subject,
          start_time: event.StartTime,
          end_time: event.EndTime,
          description: event.Description,
          location: event.Location,
          user_ids: event.WorkerIds,
        })
        .then(response => {
          this.fetchEvents();
        })
        .catch(error => {
          console.error(error);
        });
    },
    deleteEvent(event) {
      axios
        .delete(apiURL(`accounts/${this.accountId}/schedules/${event.Id}`))
        .then(response => {
          this.fetchEvents();
        })
        .catch(error => {
          console.error(error);
        });
    },
    fetchEvents() {
      axios
        .get(apiURL(`accounts/${this.accountId}/schedules`))
        .then(response => {
          const mappedData = response.data.map(event => ({
            Id: event.Id,
            Subject: event.Subject,
            Description: event.Description,
            Location: event.Location,
            StartTime: new Date(event.StartTime),
            EndTime: new Date(event.EndTime),
            IsAllDay: event.IsAllDay,
            IsBlock: event.IsBlock,
            IsReadonly: event.IsReadonly,
            RoomId: event.RoomId,
            ResourceId: event.ResourceId,
            CalendarId: event.CalendarId,
            WorkerIds: event.WorkerIds,
          }));
          console.log('THIS EVENTS', mappedData);
          this.eventSettings = {
            ...this.eventSettings,
            dataSource: mappedData,
          };
        })
        .catch(error => {
          console.error(error);
        });
    },
    fetchWorkers() {
      axios
        .get(apiURL(`accounts/${this.accountId}/agents`))
        .then(response => {
          const workers = response.data.map(worker => ({
            Id: worker.id,
            Name: worker.name,
            Color: worker.color,
            Roles: worker.roles,
          }));
          this.resourceDataSource = workers;
        })
        .catch(error => {
          console.error(error);
        });
    },
    insertActivityOrEvent(event) {
      if (event?.item.id === 'event') {
        let scheduleObj = this.$refs.scheduleObj;
        let endDate = new Date(this.selectedDate.getTime());
        endDate.setMinutes(this.selectedDate.getMinutes() + 30);
        let eventData = {
          Id: 4,
          Subject: '',
          StartTime: this.selectedDate,
          EndTime: endDate,
        };
        scheduleObj.openEditor(eventData, 'Add', true, 0);
      }
    },
    nextMonthDate() {
      let scheduleObj = this.$refs.scheduleObj;
      let nextDate = new Date(this.selectedDate.getTime());
      nextDate.setMonth(nextDate.getMonth() + 1);
      this.selectedDate = nextDate;

      scheduleObj.refresh();
    },
    prevMonthDate() {
      let scheduleObj = this.$refs.scheduleObj;
      let prevDate = new Date(this.selectedDate.getTime());
      prevDate.setMonth(prevDate.getMonth() - 1);
      this.selectedDate = prevDate;

      scheduleObj.refresh();
    },
    getEmployeeName(data) {
      let value = JSON.parse(JSON.stringify(data));
      return value.resourceData
        ? value.resourceData[value.resource.textField]
        : value.resourceName;
    },
    getEmployeeImage(data) {
      let resourceName = this.getEmployeeName(data);

      const avatar_url = this.agents.find(
        agent => agent.name === resourceName
      )?.thumbnail;
      return `${avatar_url}` || 'user';
    },
    getEmployeeDesignation(data) {
      let resourceName = this.getEmployeeName(data);
      const resourceRoles = this.agents.find(
        agent => agent.name === resourceName
      )?.roles;
      return resourceRoles || 'Inside Sales Coordinator';
    },
    onDateChange(args) {
      this.selectedDate = args?.value;
    },
    changeSelectedDateToToday() {
      this.selectedDate = new Date();
    },
    getMyCalendars() {
      const parseCalendars = JSON.parse(JSON.stringify(this.calendars));
      return parseCalendars;
    },

    loadCalendarId() {
      const calendarId = LocalStorage.get(
        LOCAL_STORAGE_KEYS.DEFAULT_CALENDAR_ID || 0
      );
      if (calendarId && calendarId !== this.calendarId) {
        this.selectedCalendarId = parseInt(calendarId, 10);
        this.setCalendarId(calendarId);
      }
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

    setCalendarId(calendarId) {
      if (calendarId === this.calendarId) return;
      this.$store.dispatch('calendars/setDefaultCalendarId', calendarId);
      this.$store.dispatch('calendars/getDefaultCalendarId');
      this.fetchEvents();
    },
    exportCalendar(event) {
      let exportFields = [
        { name: 'Id', text: 'Id' },
        { name: 'Subject', text: 'Assunto' },
        { name: 'StartTime', text: 'Data Inicial' },
        { name: 'EndTime', text: 'Data Final' },
        { name: 'Location', text: 'Local' },
      ];
      let exportValues = { fieldsInfo: exportFields };
      if (event.item.id === 'xlsx') {
        this.$refs.scheduleObj.exportToExcel(exportValues);
      } else if (event.item.id === 'ical') {
        this.$refs.scheduleObj.exportToICalendar();
      }
    },
    getGoogleCalendar() {
      this.googleCalendar =
        this.$store.getters['integrations/getIntegration']('google_calendar');
    },
  },
  beforeDestroy() {
    sessionStorage.removeItem('reloaded'); // Limpa a flag ao sair da rota de schedule
  },
};
</script>

<style>
@import '@syncfusion/ej2-base/styles/tailwind.css';
@import '@syncfusion/ej2-layouts/styles/tailwind.css';
@import '@syncfusion/ej2-buttons/styles/tailwind.css';
@import '@syncfusion/ej2-calendars/styles/tailwind.css';
@import '@syncfusion/ej2-dropdowns/styles/tailwind.css';
@import '@syncfusion/ej2-inputs/styles/tailwind.css';
@import '@syncfusion/ej2-navigations/styles/tailwind.css';
@import '@syncfusion/ej2-popups/styles/tailwind.css';
@import '@syncfusion/ej2-vue-schedule/styles/tailwind.css';
</style>
