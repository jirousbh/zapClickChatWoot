import types from '../mutation-types';
import KanbanAPI from '../../api/kanban';
import AnalyticsHelper from '../../helper/AnalyticsHelper';
import { KANBAN_EVENTS } from '../../helper/AnalyticsHelper/events';

const state = {
  attributes: [],
  cards: null,
  uiFlags: {
    isFetching: false,
    isUpdating: false,
  },
};

export const getters = {
  getUIFlags(_state) {
    return _state.uiFlags;
  },
  getAttributes: _state => {
     return _state.attributes;
  },

  getKanbanCards: _state => {
    return _state.cards;
	},
	getCardById: _state => cardId => {
    return _state.cards.find(
      value => value.id === Number(cardId)
    );
  },

};

export const actions = {
  get: async function getAllAttributes({ commit }) {
    commit(types.SET_KANBAN_ATTRIBUTE_UI_FLAG, { isFetching: true });
    try {
      const response = await KanbanAPI.get();
      commit(types.SET_KANBAN_ATTRIBUTES, response.data);
    } catch (error) {
      // Ignore error
    } finally {
      commit(types.SET_KANBAN_ATTRIBUTE_UI_FLAG, { isFetching: false });
    }
  },
  
  fetchAttributes: async ({ commit }) => {
    commit(types.SET_KANBAN_ATTRIBUTE_UI_FLAG, {
      isFetching: true,
    });
    try {
      const response = await KanbanAPI.get();
      commit(types.SET_KANBAN_ATTRIBUTES, response.data);
    } catch (error) {
      // Handle error appropriately
    } finally {
      commit(types.SET_KANBAN_ATTRIBUTE_UI_FLAG, {
        isFetching: false,
      });
    }
  },
  getKanbanCards: async({ commit }) => {
    commit(types.SET_KANBAN_ATTRIBUTE_UI_FLAG, {
      isFetching: true,
    });
    try {
      const response = await KanbanAPI.getCards();
      commit(types.SET_KANBAN_CARDS, response.data);
    } catch (error) {
      // Handle error appropriately
    } finally {
      commit(types.SET_KANBAN_ATTRIBUTE_UI_FLAG, {
        isFetching: false,
      });
    }
  },
  update: async function updateKanbanAttributes({ commit },  kanbanAttributes ) {
    commit(types.SET_KANBAN_ATTRIBUTE_UI_FLAG, { isUpdating: true });
    try {
      const response = await KanbanAPI.update(kanbanAttributes);
      AnalyticsHelper.track(KANBAN_EVENTS.UPDATE);
      commit(types.UPDATE_KANBAN_ATTRIBUTES, response.data);
    } catch (error) {
      throw new Error(error);
    } finally {
      commit(types.SET_KANBAN_ATTRIBUTE_UI_FLAG, { isUpdating: false });
    }
	},
	
	updateCard: async({ commit },  {columnTitle,cardId}) => {
    commit(types.SET_KANBAN_ATTRIBUTE_UI_FLAG, { isUpdating: true });
    try {
      const response = await KanbanAPI.updateCard(columnTitle,cardId);
      AnalyticsHelper.track(KANBAN_EVENTS.UPDATE);
      commit(types.UPDATE_KANBAN_CARD, response.data);
    } catch (error) {
      throw new Error(error);
    } finally {
      commit(types.SET_KANBAN_ATTRIBUTE_UI_FLAG, { isUpdating: false });
    }
	},
};


export const mutations = {
  [types.SET_KANBAN_ATTRIBUTE_UI_FLAG](_state, data) {
    _state.uiFlags = {
      ..._state.uiFlags,
      ...data,
    };
  },

  [types.SET_KANBAN_ATTRIBUTES] (_state, data) {
   _state.attributes = data;
  },


  [types.SET_KANBAN_CARDS] (_state, data) {
    _state.cards = data;
	},
	[types.UPDATE_KANBAN_CARD] (_state, data) {
    const index = _state.cards.findIndex(
      card => card.id === data.id
    );
    if (index !== -1) {
      _state.cards.splice(index, 1, data);
    }
	},

  [types.UPDATE_KANBAN_ATTRIBUTES] (_state, data) {
    console.log("IS UPDATED DATA", data);
  }
};

export default {
  namespaced: true,
  actions,
  state,
  getters,
  mutations,
};
