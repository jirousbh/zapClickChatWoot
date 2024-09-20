<template v-slot:cardTemplate="{ data }">
  <div class="card-template">
    <div
      class="e-card-header flex justify-center"
      :style="{
        backgroundColor: data.color,
        filter: 'brightness(90%)',
      }"
    >
      <div class="e-card-header-caption">
        <div
          class="e-card-header-title e-tooltip-text"
          :style="{
            color: `#ffffff !important`,
          }"
        >
          <span class="inline-block align-bottom">
            <a v-tooltip.top-end="'Nome do Agente'">
              {{ formatName(data.agent_name) }}</a
            ></span
          >
        </div>
      </div>
    </div>
    <div class="e-card-content e-tooltip-text">
      <div class="e-text">
        {{ formatName(data.title) }}
      </div>

      <div
        v-if="data.agent_last_seen_at && isVisible('agent_last_seen_at')"
        class="e-text"
        v-html="formatText('agent_last_seen_at', data.agent_last_seen_at)"
      ></div>
      <div
        v-if="data.assignee_last_seen_at && isVisible('assignee_last_seen_at')"
        class="e-text"
        v-html="formatText('assignee_last_seen_at', data.assignee_last_seen_at)"
      ></div>
      <div
        v-if="data.contact_last_seen_at && isVisible('contact_last_seen_at')"
        class="e-text"
        v-html="formatText('contact_last_seen_at', data.contact_last_seen_at)"
      ></div>
      <div
        v-if="
          data.custom_attributes &&
          isVisible('custom_attributes') &&
          data.custom_attributes !== '{}'
        "
        class="e-text"
        v-html="formatText('custom_attributes', data.custom_attributes)"
      ></div>
      <div
        v-if="data.muted && isVisible('muted')"
        class="e-text"
        v-html="formatText('mute', data.muted)"
      ></div>
      <div
        v-if="data.snoozed_until && isVisible('snoozed_until')"
        class="e-text"
        v-html="formatText('snnozed_until', data.snoozed_until)"
      ></div>
      <div
        v-if="data.status && isVisible('status')"
        class="e-text"
        v-html="formatText('status', data.status)"
      ></div>
      <div
        v-if="data.created_at && isVisible('created_at')"
        class="e-text"
        v-html="formatText('created_at', data.created_at)"
      ></div>
      <div
        v-if="data.timestamp && isVisible('timestamp')"
        class="e-text"
        v-html="formatText('timestamp', data.timestamp)"
      ></div>
      <div
        v-if="
          data.first_reply_created_at && isVisible('first_reply_created_at')
        "
        class="e-text"
        v-html="
          formatText('first_reply_created_at', data.first_reply_created_at)
        "
      ></div>
      <div
        v-if="data.last_activity_at && isVisible('last_activity_at')"
        class="e-text"
        v-html="formatText('last_activity_at', data.last_activity_at)"
      ></div>
      <div
        v-if="data.priority && isVisible('priority')"
        class="e-text"
        v-html="formatText('priority', data.priority)"
      ></div>
      <div
        v-if="data.waiting_since && isVisible('waiting_since')"
        class="e-text"
        v-html="formatText('waiting_since', data.waiting_since)"
      ></div>
    </div>
    <div class="e-card-custom-footer">
      <div class="e-card-tag-field">
        <span class="text-gray-500 dark:text-gray-400 font-bold"
          >Contato:
        </span>
        {{ formatName(data.contact_name) }}
      </div>
      <div class="e-card-avatar">
        <thumbnail
          :src="data.contact_avatar"
          size="30px"
          :username="data.contact_name"
          :style="null"
        />
      </div>
    </div>
  </div>
</template>
<script>
const MINUTE_IN_MILLI_SECONDS = 60000;
const HOUR_IN_MILLI_SECONDS = MINUTE_IN_MILLI_SECONDS * 60;
const DAY_IN_MILLI_SECONDS = HOUR_IN_MILLI_SECONDS * 24;

import { mapGetters } from 'vuex';
import timeMixin from 'dashboard/mixins/time';
import Thumbnail from '../../../../../components/widgets/Thumbnail.vue';

export default {
  mixins: [timeMixin],
  components: {
    Thumbnail,
  },
  data() {
    return {
      data: {},
    };
  },
  computed: {
    ...mapGetters({
      cardAttributes: 'kanban/getAttributes',
    }),
  },
  methods: {
    formatName(name) {
      const prepositions = ['de', 'da', 'do', 'das', 'dos'];

      return name
        .toLowerCase()
        .split(' ')
        .map((word, index) => {
          // Capitalize words that are not prepositions, or if it's the first word
          if (index === 0 || !prepositions.includes(word)) {
            return word.charAt(0).toUpperCase() + word.slice(1);
          }
          return word; // Keep prepositions lowercase
        })
        .join(' ');
    },
    getString: function (name) {
      return name
        .match(/\b(\w)/g)
        .join('')
        .toUpperCase();
    },
    getCardFooter: function (data) {
      return `<div class='e-card-tag-field e-tooltip-text'> ${data.name} </div>
        <div><thumbnail src="${data.image_agent}" username="${data.image_agent}" class="e-card-avatar"/></div>`;
    },

    getAvatarAgent: function (url) {
      return url;
    },
    isVisible(attributeName) {
      const attribute = this.cardAttributes.find(
        attr => attr.Name === attributeName
      );

      return attribute ? attribute.Visible : false;
    },
    formatTime(time) {
      return `${this.$t('CHAT_LIST.CHAT_TIME_STAMP.LAST_ACTIVITY.ACTIVE')}: ${this.dateFormat(
        time
      )}`;
    },
    formatText(text, value) {
      let result;
      switch (text) {
        case 'agent_last_seen_at':
          result = `<b class="text-sm font-semibold">Agente viu pela última vez em</b>: ${this.dateFormat(
            value
          )}`;
          break;
        case 'assignee_last_seen_at':
          result = `<b class="text-sm font-semibold">Responsável viu pela última vez em</b>: ${this.dateFormat(
            value
          )}`;
          break;
        case 'contact_last_seen_at':
          result = `<b class="text-sm font-semibold">Contato viu pela última</b>: ${this.dateFormat(
            value
          )}`;
          break;
        case 'custom_attributes':
          let campos = '';

          for (let chave in value) {
            if (value.hasOwnProperty(chave)) {
              campos += `${value[chave]}<br/>`;
            }
          }
          result = `${campos.slice(0, -2)}`;
          break;
        case 'muted':
          result = `<b class="text-sm font-semibold">${this.$t('CONTACT_PANEL.MUTED')}</b>: ${value}`;
          break;
        case 'snoozed_until':
          result = `<b class="text-sm font-semibold">Adiado até</b>: ${this.dateFormat(
            value
          )}`;
          break;
        case 'status':
          result = `<b class="text-sm font-semibold">Status</b>: ${value}`;
          break;
        case 'created_at':
          result = `<b class="text-sm font-semibold">${this.$t('CHAT_LIST.CHAT_TIME_STAMP.CREATED.OLDEST')}</b> ${this.dateFormat(
            value
          )}`;
          break;
        case 'timestamp':
          result = `<b class="text-sm font-semibold">${this.$t('CHAT_LIST.CHAT_TIME_STAMP.LAST_ACTIVITY.ACTIVE')}</b>: ${this.dateFormat(
            value
          )}`;
          break;
        case 'first_reply_created_at':
          result = `<b class="text-sm font-semibold">Primeira Resposta</b>: ${this.dateFormat(
            value
          )}`;
          break;
        case 'last_activity_at':
          result = `<b class="text-sm font-semibold">${this.$t('CHAT_LIST.CHAT_TIME_STAMP.LAST_ACTIVITY.ACTIVE')}</b>: ${this.dateFormat(
            value
          )}`;
          break;
        case 'priority':
          result = `<b class="text-sm font-semibold">${this.$t('CONVERSATION.PRIORITY.TITLE')}</b>: ${this.$t('CONVERSATION.PRIORITY.OPTIONS.' + value.toUpperCase())}`;
          break;
        case 'waiting_since':
          result = `<b class="text-sm font-semibold">Esperando desde</b>: ${this.dateFormat(
            value
          )}`;
          break;
        default:
          result = `Sem Nome: ${value}`;
      }

      return result;
    },
  },
};
</script>
<style>
.kanban-overview.e-kanban .header-template-wrap {
  display: inline-flex;
  font-size: 15px;
  font-weight: 500;
}

.kanban-overview.e-kanban .header-template-wrap .header-icon {
  font-family: 'Kanban priority icons';
  margin-top: 3px;
  width: 10%;
}

.kanban-overview.e-kanban .header-template-wrap .header-text {
  margin-left: 15px;
}

.kanban-overview.e-kanban.e-rtl .header-template-wrap .header-text {
  margin-right: 15px;
}

.kanban-overview.e-kanban.e-rtl .e-card-avatar {
  left: 12px;
  right: auto;
}

.kanban-overview.e-kanban .e-card-avatar {
  width: 30px;
  height: 30px;
  text-align: center;
  background-color: gainsboro;
  color: #323232;
  border-radius: 50%;
  position: absolute;
  right: 12px;
  bottom: 10px;
  font-size: 12px;
  font-weight: 400;
  padding: 0px 0px 0px px;
}

.kanban-overview.e-kanban .Open::before {
  content: '\e700';
  color: #0251cc;
  font-size: 16px;
}

.kanban-overview.e-kanban .InProgress::before {
  content: '\e703';
  color: #ea9713;
  font-size: 16px;
}

.kanban-overview.e-kanban .e-image img {
  background: #ececec;
  border: 1px solid #c8c8c8;
  border-radius: 50%;
}

.kanban-overview.e-kanban .Review::before {
  content: '\e701';
  color: #8e4399;
  font-size: 16px;
}

.kanban-overview.e-kanban .Close::before {
  content: '\e702';
  color: #63ba3c;
  font-size: 16px;
}

.kanban-overview.e-kanban .e-card .e-card-tag-field {
  color: #6b6b6b;
  margin-right: 5px;
  line-height: 1.1;
  font-size: 13px;
  border-radius: 3px;
  padding: 4px;
}

.kanban-overview.e-kanban .e-card-custom-footer {
  display: flex;
  padding: 0px 12px 12px;
  line-height: 1;
  height: 35px;
}

.kanban-overview.e-kanban
  .e-kanban-content
  .e-content-row
  .e-content-cells
  .e-card-wrapper
  .e-card.Low.e-selection:hover,
.kanban-overview.e-kanban
  .e-kanban-content
  .e-content-row
  .e-content-cells
  .e-card-wrapper
  .e-card.Low,
.kanban-overview.e-kanban.e-rtl
  .e-kanban
  .e-kanban-content
  .e-content-row
  .e-content-cells
  .e-card-wrapper
  .e-card.Low {
  border-left: 3px solid #1f88e5;
}

.kanban-overview.e-kanban
  .e-kanban-content
  .e-content-row
  .e-content-cells
  .e-card-wrapper
  .e-card.High.e-selection:hover,
.kanban-overview.e-kanban
  .e-kanban-content
  .e-content-row
  .e-content-cells
  .e-card-wrapper
  .e-card.High,
.kanban-overview.e-kanban.e-rtl
  .e-kanban
  .e-kanban-content
  .e-content-row
  .e-content-cells
  .e-card-wrapper
  .e-card.High {
  border-left: 3px solid #673ab8;
}

.kanban-overview.e-kanban
  .e-kanban-content
  .e-content-row
  .e-content-cells
  .e-card-wrapper
  .e-card.Normal.e-selection:hover,
.kanban-overview.e-kanban
  .e-kanban-content
  .e-content-row
  .e-content-cells
  .e-card-wrapper
  .e-card.Normal,
.kanban-overview.e-kanban.e-rtl
  .e-kanban
  .e-kanban-content
  .e-content-row
  .e-content-cells
  .e-card-wrapper
  .e-card.Normal {
  border-left: 3px solid #02897b;
}

.kanban-overview.e-kanban
  .e-kanban-content
  .e-content-row
  .e-content-cells
  .e-card-wrapper
  .e-card.Critical.e-selection:hover,
.kanban-overview.e-kanban
  .e-kanban-content
  .e-content-row
  .e-content-cells
  .e-card-wrapper
  .e-card.Critical,
.kanban-overview.e-kanban.e-rtl
  .e-kanban
  .e-kanban-content
  .e-content-row
  .e-content-cells
  .e-card-wrapper
  .e-card.Critical {
  border-left: 3px solid #e64a19;
}

.kanban-overview.e-kanban.e-rtl
  .e-kanban
  .e-kanban-content
  .e-content-row
  .e-content-cells
  .e-card-wrapper
  .e-card {
  border-left: none;
}

@font-face {
  font-family: 'Kanban priority icons';
  src: url(data:application/x-font-ttf;charset=utf-8;base64,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)
    format('truetype');
  font-weight: normal;
  font-style: normal;
}

[class^='sf-icon-'],
[class*=' sf-icon-'] {
  font-family: 'Kanban priority icons' !important;
  speak: none;
  font-size: 55px;
  font-style: normal;
  font-weight: normal;
  font-variant: normal;
  text-transform: none;
  line-height: 1;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
</style>
