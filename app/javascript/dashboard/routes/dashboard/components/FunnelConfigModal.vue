<template>
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
</template>

<script>

import Modal from '../../../components/Modal.vue'

export default {
    components: {
        Modal
    },
    data() {
        return {
            name: ''
        }
    },
    methods: {}
}
</script>