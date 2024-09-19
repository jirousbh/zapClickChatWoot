import ApiClient from './ApiClient';

class KanbanAPI extends ApiClient {
  constructor() {
    super('kanban', { accountScoped: true });
  }

  // eslint-disable-next-line class-methods-use-this
  get() {
    return axios.get(`${this.url}/list_attributes`);
  }
  getCards() {
    return axios.get(`${this.url}/list_cards`);
  }

  update(attributes) {
    return axios.put(`${this.url}/update_attributes`, { attributes });
	}
	
	updateCard(columnTitle, cardId) {
		return axios.put(`${this.url}/${columnTitle}/update_card/${cardId}`)
	}
}

export default new KanbanAPI();
