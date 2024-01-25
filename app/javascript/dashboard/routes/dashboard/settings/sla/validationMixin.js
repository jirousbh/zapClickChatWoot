export default {
  computed: {
    getLabelTitleErrorMessage() {
      let errorMessage = '';
      if (!this.$v.title.$error) {
        errorMessage = '';
      } else if (!this.$v.title.required) {
        errorMessage = this.$t('SLA.FORM.NAME.REQUIRED_ERROR');
      } else if (!this.$v.title.minLength) {
        errorMessage = this.$t('SLA.FORM.NAME.MINIMUM_LENGTH_ERROR');
      } else if (!this.$v.title.validLabelCharacters) {
        errorMessage = this.$t('SLA.FORM.NAME.VALID_ERROR');
      }
      return errorMessage;
    },
  },
};